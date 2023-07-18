import 'dart:convert';
import 'dart:typed_data';

import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/models/task.dart';
import 'package:checkup_app/models/task_answer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FillObjectAnswerPage extends StatefulWidget {
  final DataMaster dm;
  final ReportAnswer reportAnswer;
  final CheckupObject checkupObject;

  const FillObjectAnswerPage({
    super.key,
    required this.dm,
    required this.reportAnswer,
    required this.checkupObject,
  });

  @override
  State<FillObjectAnswerPage> createState() => _FillObjectAnswerPageState();
}

class _FillObjectAnswerPageState extends State<FillObjectAnswerPage> {
  late List<Task> tasks;

  Task get currentTask => tasks[currentTaskIndex];
  int currentTaskIndex = 0;

  @override
  void initState() {
    tasks = widget.checkupObject.getObjectType(widget.dm)?.getTasks(widget.dm) ?? List.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    if (widget.checkupObject.getObjectType(widget.dm) != null) {
      TaskAnswer? answer = widget.reportAnswer.getTaskAnswerByObjectAndTaskIds(widget.checkupObject.id, currentTask.id);

      List<Widget> failAnswerWidgets = List.empty(growable: true);
      if (answer != null && !answer.status) {
        failAnswerWidgets.add(const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Select the option that best matches the problem'),
        ));
        failAnswerWidgets.add(RadioListTile(
          value: currentTask.answerPrompt,
          groupValue: answer.failAnswerPrompt,
          onChanged: (value) {
            setState(() {
              answer.failAnswerPrompt = value;
            });
          },
          title: Text('${getFormattedPrompt(currentTask.answerPrompt)} (Default)'),
        ));
        failAnswerWidgets.addAll(currentTask.defaultFailOptions.map((e) => RadioListTile(
              value: e,
              groupValue: answer.failAnswerPrompt,
              onChanged: (value) {
                setState(() {
                  answer.failAnswerPrompt = value;
                });
              },
              title: Text(getFormattedPrompt(e)),
            )));
        if (answer.photo != null) {
          failAnswerWidgets.add(const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Attached photo'),
          ));
          failAnswerWidgets.add(Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Stack(children: [
              getPhotoWidgetFromTaskAnswer(answer),
              IconButton(
                  onPressed: () => setState(() => answer.photo = null), icon: const Icon(Icons.delete, color: Colors.white))
            ]),
          ));
        }
        failAnswerWidgets.add(Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
              onPressed: () => pickPhoto(answer).then((value) => setState(() {})),
              icon: const Icon(Icons.add_a_photo),
              label: Text('${answer.photo == null ? 'ADD' : 'REPLACE'} PHOTO')),
        ));
        failAnswerWidgets.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Notes'),
            initialValue: answer.notes,
            onChanged: (value) {
              if (value.trim() == "") {
                answer.notes = null;
              } else {
                answer.notes = value.trim();
              }
            },
          ),
        ));
      }

      mainWidget = Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            'Task ${currentTaskIndex + 1}/${widget.checkupObject.getObjectType(widget.dm)?.getTasks(widget.dm).length ?? 0}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentTask.name,
                          textAlign: TextAlign.center,
                          textScaleFactor: 2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Answer: ${answer?.status}'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      setStatus(answer, false);
                    });
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('NO'),
                  style: ButtonStyle(
                      iconSize: const MaterialStatePropertyAll(48),
                      backgroundColor: (!(answer?.status ?? true))
                          ? const MaterialStatePropertyAll(Color.fromARGB(255, 242, 145, 145))
                          : null),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      setStatus(answer, true);
                      addIndex();
                    });
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('YES'),
                  style: ButtonStyle(
                      iconSize: const MaterialStatePropertyAll(48),
                      backgroundColor: (answer?.status ?? false)
                          ? const MaterialStatePropertyAll(Color.fromARGB(255, 169, 219, 151))
                          : null),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        subtractIndex();
                      });
                    },
                    icon: const Icon(Icons.navigate_before),
                    label: const Text('PREVIOUS'),
                    style: const ButtonStyle(iconSize: MaterialStatePropertyAll(48))),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        addIndex();
                      });
                    },
                    icon: const Icon(Icons.navigate_next),
                    label: const Text('NEXT'),
                    style: const ButtonStyle(iconSize: MaterialStatePropertyAll(48))),
              )),
            ],
          ),
          Expanded(
            child: ListView(
              children: failAnswerWidgets,
            ),
          )
        ],
      );
    } else {
      mainWidget = const Center(child: Text("This object's type does not have any tasks"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checkupObject.getFullName(widget.dm)),
      ),
      body: mainWidget,
    );
  }

  Future<void> pickPhoto(TaskAnswer answer) async {
    XFile? photoFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photoFile != null) {
      Uint8List photoBytes = await photoFile.readAsBytes();
      String encodedPhotoBytes = base64Encode(photoBytes);
      answer.photo = encodedPhotoBytes;
    }
  }

  Image getPhotoWidgetFromTaskAnswer(TaskAnswer answer) {
    assert(answer.photo != null);

    return Image.memory(base64Decode(answer.photo!));
  }

  String getFormattedPrompt(String prompt) =>
      widget.reportAnswer.formatPrompt(prompt, [widget.checkupObject.getFullName(widget.dm)], null);

  void addIndex() {
    currentTaskIndex++;
    if (currentTaskIndex > tasks.length - 1) currentTaskIndex = 0;
  }

  void subtractIndex() {
    currentTaskIndex--;
    if (currentTaskIndex < 0) currentTaskIndex = tasks.length - 1;
  }

  void setStatus(TaskAnswer? answer, bool status) {
    if (answer == null) {
      answer = TaskAnswer(taskId: currentTask.id, objectId: widget.checkupObject.id);
      widget.reportAnswer.answers.add(answer);
    }

    answer.setStatus(status, currentTask);
  }
}
