class TaskAnswer {
  int taskId;
  int objectId;
  bool status = false;
  String? failAnswerPrompt;
  String? notes;
  dynamic attachment;

  TaskAnswer({required this.taskId, required this.objectId});
}
