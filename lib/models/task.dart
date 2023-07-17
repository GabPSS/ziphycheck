import 'package:checkup_app/data/data_master.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  late int id;
  String name = "";
  String _answerPrompt = "";
  List<String> defaultFailOptions = List.empty(growable: true);

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isAnswerPromptEmpty => _answerPrompt == "";

  String get answerPrompt => _answerPrompt == "" ? name : _answerPrompt;

  set answerPrompt(String value) => _answerPrompt = value;

  Task({DataMaster? dm}) {
    if (dm != null) {
      id = dm.taskKey;
      dm.taskKey++;
      dm.tasks.add(this);
    }
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
