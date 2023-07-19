import 'dart:convert';
import 'dart:typed_data';

import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/models/task.dart';
import 'package:checkup_app/models/task_answer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FillObjectAnswerPage extends StatefulWidget {
  final DataMaster dm;
  final ReportAnswer reportAnswer;
  final Location? startLocation;
  final Task? startTask;
  final CheckupObject? startObject;
  final bool sortByTasks;

  const FillObjectAnswerPage(
      {super.key,
      required this.dm,
      required this.reportAnswer,
      this.startObject,
      this.startLocation,
      this.startTask,
      this.sortByTasks = false});

  @override
  State<FillObjectAnswerPage> createState() => _FillObjectAnswerPageState();
}

class _FillObjectAnswerPageState extends State<FillObjectAnswerPage> {
  CheckupObject get checkupObject => widget.sortByTasks ? objects[currentObjectIndex] : location.objects[currentObjectIndex];
  int currentObjectIndex = 0;

  List<CheckupObject> get objects => widget.sortByTasks ? widget.dm.getObjectsByTask(currentTask, location) : location.objects;

  Task get currentTask => tasks[currentTaskIndex];
  int currentTaskIndex = 0;

  List<Task> get tasks => widget.sortByTasks
      ? widget.dm.getTasksForLocation(location)
      : checkupObject.getObjectType(widget.dm)?.getTasks(widget.dm) ?? List.empty();

  Location get location => report.locations[currentLocationIndex];
  int currentLocationIndex = 0;

  late Report report;

  String get objectTitleText => "${location.name}, ${checkupObject.getFullName(widget.dm)}";

  @override
  void initState() {
    report = widget.dm.getReportById(widget.reportAnswer.baseReportId);

    if (widget.startLocation != null) {
      int locationIndex = report.locations.indexOf(widget.startLocation!);
      currentLocationIndex = locationIndex != -1 ? locationIndex : 0;
    }
    if (widget.sortByTasks) {
      setInitialTask();
      setInitialObject();
    } else {
      setInitialObject();
      setInitialTask();
    }
    super.initState();
  }

  void setInitialObject() {
    if (widget.startObject != null) {
      int objectIndex = location.objects.indexOf(widget.startObject!);
      currentObjectIndex = objectIndex != -1 ? objectIndex : 0;
    }
  }

  void setInitialTask() {
    if (widget.startTask != null) {
      int taskIndex = tasks.indexOf(widget.startTask!);
      currentTaskIndex = taskIndex != -1 ? taskIndex : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    if (checkupObject.getObjectType(widget.dm) != null) {
      TaskAnswer? answer = widget.reportAnswer.getTaskAnswerByObjectAndTaskIds(checkupObject.id, currentTask.id);

      List<Widget> pageContent = List.empty(growable: true);
      pageContent.add(getPageHeader(answer));
      if (answer != null && !answer.status) {
        pageContent.add(const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Select the option that best matches the problem'),
        ));
        pageContent.add(RadioListTile(
          value: currentTask.answerPrompt,
          groupValue: answer.failAnswerPrompt,
          onChanged: (value) {
            setState(() {
              answer.failAnswerPrompt = value;
            });
          },
          title: Text('${getFormattedPrompt(currentTask.answerPrompt)} (Default)'),
        ));
        pageContent.addAll(currentTask.defaultFailOptions.map((e) => RadioListTile(
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
          pageContent.add(const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Attached photo'),
          ));
          pageContent.add(Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Stack(children: [
              getPhotoWidgetFromTaskAnswer(answer),
              IconButton(
                  onPressed: () => setState(() => answer.photo = null), icon: const Icon(Icons.delete, color: Colors.white))
            ]),
          ));
        }
        pageContent.add(Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
              onPressed: () => pickPhoto(answer).then((value) => setState(() {})),
              icon: const Icon(Icons.add_a_photo),
              label: Text('${answer.photo == null ? 'ADD' : 'REPLACE'} PHOTO')),
        ));
        pageContent.add(Padding(
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
        children: [Expanded(child: ListView(children: pageContent)), getAnswerButtons(answer)],
      );
    } else {
      mainWidget = const Center(child: Text("This object's type does not have any tasks"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              widget.dm.save();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(widget.sortByTasks ? currentTask.name : objectTitleText),
      ),
      body: mainWidget,
    );
  }

  Column getAnswerButtons(TaskAnswer? answer) {
    return Column(
      children: [
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
                    backgroundColor:
                        (answer?.status ?? false) ? const MaterialStatePropertyAll(Color.fromARGB(255, 169, 219, 151)) : null),
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
      ],
    );
  }

  Row getPageHeader(TaskAnswer? answer) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.sortByTasks
                      ? 'Object ${currentObjectIndex + 1}/${objects.length}'
                      : 'Task ${currentTaskIndex + 1}/${checkupObject.getObjectType(widget.dm)?.getTasks(widget.dm).length ?? 0}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.sortByTasks ? objectTitleText : currentTask.name,
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
      widget.reportAnswer.formatPrompt(prompt, [checkupObject.getFullName(widget.dm)], null);

  void addIndex() {
    if (widget.sortByTasks) {
      addObjectIndex(() => addTaskIndex(() => addLocationIndex()));
    } else {
      addTaskIndex(() => addObjectIndex(() => addLocationIndex()));
    }
  }

  void addTaskIndex(Function() next) {
    currentTaskIndex++;
    if (currentTaskIndex > tasks.length - 1) {
      currentTaskIndex = 0;
      next();
    }
  }

  //nonsort
  void addObjectIndex(Function() next) {
    currentObjectIndex++;
    if (currentObjectIndex > objects.length - 1) {
      currentObjectIndex = 0;
      next();
    }
  }

  void addLocationIndex() {
    currentLocationIndex++;
    if (currentLocationIndex > report.locations.length - 1) {
      currentLocationIndex = 0;
    }
  }

  void subtractIndex() {
    if (widget.sortByTasks) {
      subtractObjectIndex(() => subtractTaskIndex(() => subtractLocationIndex()));
    } else {
      subtractTaskIndex(() => subtractObjectIndex(() => subtractLocationIndex()));
    }
  }

  void subtractTaskIndex(Function() next) {
    currentTaskIndex--;
    if (currentTaskIndex < 0) {
      next();
      currentTaskIndex = tasks.length - 1;
    }
  }

  void subtractObjectIndex(Function() next) {
    currentObjectIndex--;
    if (currentObjectIndex < 0) {
      next();
      currentObjectIndex = objects.length - 1;
    }
  }

  void subtractLocationIndex() {
    currentLocationIndex--;
    if (currentLocationIndex < 0) {
      currentLocationIndex = report.locations.length - 1;
    }
  }

  void setStatus(TaskAnswer? answer, bool status) {
    if (answer == null) {
      answer = TaskAnswer(taskId: currentTask.id, objectId: checkupObject.id);
      widget.reportAnswer.answers.add(answer);
    }

    answer.setStatus(status, currentTask);
  }
}
