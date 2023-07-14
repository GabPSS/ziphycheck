import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/object_type.dart';

class Task {
  late int id;
  String name = "";
  String _answerPrompt = "";
  List<String> defaultFailOptions = List.empty(growable: true);

  bool get isAnswerPromptEmpty => _answerPrompt == "";

  String get answerPrompt => _answerPrompt == "" ? name : _answerPrompt;

  set answerPrompt(String value) => _answerPrompt = value;

  Task({required DataMaster dm}) {
    id = dm.taskKey;
    dm.taskKey++;
    dm.tasks.add(this);
  }
}
