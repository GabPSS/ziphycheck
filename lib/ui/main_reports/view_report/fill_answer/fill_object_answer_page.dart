import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/models/task.dart';
import 'package:checkup_app/models/task_answer.dart';
import 'package:flutter/material.dart';

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
    tasks = widget.checkupObject.objectType?.getTasks() ?? List.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    if (widget.checkupObject.objectType != null) {
      TaskAnswer? answer = widget.reportAnswer.getTaskAnswerByObjectAndTaskIds(widget.checkupObject.id, currentTask.id);

      List<Widget> failAnswerPromptWidgets = List.empty(growable: true);
      if (answer != null && !answer.status) {
        failAnswerPromptWidgets.add(const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Select the option that best matches the problem'),
        ));
        failAnswerPromptWidgets.add(RadioListTile(
          value: currentTask.answerPrompt,
          groupValue: answer.failAnswerPrompt,
          onChanged: (value) {
            setState(() {
              answer.failAnswerPrompt = value;
            });
          },
          title: Text('${getFormattedPrompt(currentTask.answerPrompt)} (Default)'),
        ));
        failAnswerPromptWidgets.addAll(currentTask.defaultFailOptions.map((e) => RadioListTile(
              value: e,
              groupValue: answer.failAnswerPrompt,
              onChanged: (value) {
                setState(() {
                  answer.failAnswerPrompt = value;
                });
              },
              title: Text(getFormattedPrompt(e)),
            )));
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
                        child: Text('Task ${currentTaskIndex + 1}/${widget.checkupObject.objectType?.getTasks().length ?? 0}'),
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
                padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      setStatus(answer, false);
                    });
                  },
                  icon: Icon(Icons.close),
                  label: Text('NO'),
                  style: ButtonStyle(
                      iconSize: MaterialStatePropertyAll(48),
                      backgroundColor:
                          (!(answer?.status ?? true)) ? MaterialStatePropertyAll(Color.fromARGB(255, 242, 145, 145)) : null),
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      setStatus(answer, true);
                      addIndex();
                    });
                  },
                  icon: Icon(Icons.check),
                  label: Text('YES'),
                  style: ButtonStyle(
                      iconSize: MaterialStatePropertyAll(48),
                      backgroundColor:
                          (answer?.status ?? false) ? MaterialStatePropertyAll(Color.fromARGB(255, 169, 219, 151)) : null),
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        subtractIndex();
                      });
                    },
                    icon: Icon(Icons.navigate_before),
                    label: Text('PREVIOUS'),
                    style: ButtonStyle(iconSize: MaterialStatePropertyAll(48))),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        addIndex();
                      });
                    },
                    icon: Icon(Icons.navigate_next),
                    label: Text('NEXT'),
                    style: ButtonStyle(iconSize: MaterialStatePropertyAll(48))),
              )),
            ],
          ),
          Expanded(
            child: ListView(
              children: failAnswerPromptWidgets,
            ),
          )
        ],
      );
    } else {
      mainWidget = const Center(child: Text("This object's type does not have any tasks"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checkupObject.fullName),
      ),
      body: mainWidget,
    );
  }

  String getFormattedPrompt(String prompt) => widget.reportAnswer.formatPrompt(prompt, [widget.checkupObject.fullName]);

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
