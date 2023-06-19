class TaskAnswer {
  int taskId;
  int objectId;
  bool status = false;
  String details = "";
  dynamic attachment;

  TaskAnswer({required this.taskId, required this.objectId});
}