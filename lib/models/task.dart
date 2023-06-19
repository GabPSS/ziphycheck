import 'package:checkup_app/data/data_master.dart';

class Task {
  late int id;
  String name = "";
  String _answerPrompt = "";

  String get answerPrompt { return _answerPrompt == "" ? name : _answerPrompt; }
  set answerPrompt(String value) {_answerPrompt = value;}

  Task({required DataMaster dm}) {
    id = dm.taskKey;
    dm.taskKey++;
  }
}