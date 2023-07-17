import 'package:checkup_app/models/task.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_answer.g.dart';

@JsonSerializable()
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

  factory TaskAnswer.fromJson(Map<String, dynamic> json) => _$TaskAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$TaskAnswerToJson(this);
}
