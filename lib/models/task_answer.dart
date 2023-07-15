import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/task.dart';

class TaskAnswer {
  int taskId;
  int objectId;
  bool status = false;
  String? failAnswerPrompt;
  String? notes;
  dynamic attachment;

  TaskAnswer({required this.taskId, required this.objectId});

  void setStatus(bool value, Task task) {
    status = value;
    failAnswerPrompt = status ? null : task.answerPrompt;
  }
}
