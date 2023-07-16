import 'package:checkup_app/models/task.dart';

class TaskAnswer {
  int taskId;
  int objectId;
  bool status = false;
  String? failAnswerPrompt;
  String? notes;
  String? photo;

  TaskAnswer({required this.taskId, required this.objectId});

  void setStatus(bool value, Task task) {
    status = value;
    failAnswerPrompt = status ? null : task.answerPrompt;
  }
}
