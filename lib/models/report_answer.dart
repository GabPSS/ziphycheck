import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';

import '../data/data_master.dart';
import 'task_answer.dart';

class ReportAnswer {
  late int id;
  int baseReportId = -1;
  DateTime answerDate = DateTime.now();
  List<TaskAnswer> answers = List.empty(growable: true);

  ReportAnswer({required DataMaster dm, required this.baseReportId}) {
    id = dm.reportAnswerKey;
    dm.reportAnswerKey++;
    dm.reportAnswers.add(this);
  }

  String getReportString(DataMaster dm) {
    Report baseReport = dm.getReportById(baseReportId);

    String reportOut = "${baseReport.name} ${answerDate.toString()}\n\n";

    for (var locationIndex = 0; locationIndex < baseReport.locations.length; locationIndex++) {
      Location location = baseReport.locations[locationIndex];
      reportOut += "${location.name}\n\n";

      List<TaskAnswer> locationAnswers = List.empty(growable: true);
      getFalseAnswersByLocation(location, locationAnswers);

      List<String> answerPrompts = List.empty(growable: true);
      getAllAnswerPrompts(locationAnswers, answerPrompts);

      for (var promptIndex = 0; promptIndex < answerPrompts.length; promptIndex++) {
        String prompt = answerPrompts[promptIndex];
        List<String> checkupObjectNames = List.empty(growable: true);
        getCheckupObjectNamesFromTaskAnswers(locationAnswers, prompt, location, checkupObjectNames);
        reportOut += "${formatPrompt(prompt, checkupObjectNames)}\n";
      }
    }

    return reportOut;
  }

  void getCheckupObjectNamesFromTaskAnswers(
      List<TaskAnswer> locationAnswers, String prompt, Location location, List<String> checkupObjectNames) {
    for (var answerIndex = 0; answerIndex < locationAnswers.length; answerIndex++) {
      var answer = locationAnswers[answerIndex];
      if (answer.failAnswerPrompt == prompt) {
        var checkupObject = location.getCheckupObjectById(answer.objectId);
        checkupObjectNames.add((checkupObject.objectType?.name ?? "") + checkupObject.name);
      }
    }
  }

  void getFalseAnswersByLocation(Location location, List<TaskAnswer> locationAnswers) {
    for (var objectIndex = 0; objectIndex < location.objects.length; objectIndex++) {
      CheckupObject object = location.objects[objectIndex];
      TaskAnswer? objectTaskAnswer = getTaskAnswerByObjectId(object.id);
      if (objectTaskAnswer != null && !objectTaskAnswer.status) {
        locationAnswers.add(objectTaskAnswer);
      }
    }
  }

  void getAllAnswerPrompts(List<TaskAnswer> locationAnswers, List<String> answerPrompts) {
    for (var answerIndex = 0; answerIndex < locationAnswers.length; answerIndex++) {
      TaskAnswer answer = locationAnswers[answerIndex];
      if (answer.failAnswerPrompt != null && !answerPrompts.contains(answer.failAnswerPrompt)) {
        answerPrompts.add(answer.failAnswerPrompt!);
      }
    }
  }

  TaskAnswer? getTaskAnswerByObjectId(int id) {
    for (var i = 0; i < answers.length; i++) {
      if (answers[i].objectId == id) {
        return answers[i];
      }
    }
    return null;
  }

  String formatPrompt(String prompt, List<String> checkupObjectNames) {
    // RegExp matchWholeKey = RegExp(r'/\{.*?\}/gm');
    RegExp matchNonSingular = RegExp(r'(\|.*?})|{');
    RegExp matchNonPlural = RegExp(r'({.*?\|)|}');

    var isSingular = checkupObjectNames.length == 1;
    prompt = isSingular
        ? prompt.replaceAllMapped(matchNonSingular, (match) => "")
        : prompt.replaceAllMapped(matchNonPlural, (match) => "");

    prompt = prompt.replaceAll('%', checkupObjectNames.join(', '));

    return prompt;
  }
}
