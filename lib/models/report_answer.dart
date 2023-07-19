import 'dart:convert';

import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../data/data_master.dart';
import 'task_answer.dart';

part 'report_answer.g.dart';

@JsonSerializable()
class ReportAnswer {
  late int id;
  int baseReportId = -1;
  DateTime answerDate = DateTime.now();
  List<TaskAnswer> answers = List.empty(growable: true);

  ReportAnswer({DataMaster? dm, required this.baseReportId}) {
    if (dm != null) {
      id = dm.reportAnswerKey;
      dm.reportAnswerKey++;
      dm.reportAnswers.add(this);
    }
  }

  String getReportString(DataMaster dm) {
    Report baseReport = dm.getReportById(baseReportId);

    String reportString = "${baseReport.name} ${DateFormat('d/M').format(answerDate)}\n\n";

    for (Location location in baseReport.locations) {
      List<TaskAnswer> locationAnswers = getAnswersByLocation(location, dm);

      if (locationAnswers.isEmpty) {
        continue;
      }

      reportString += "${location.name}\n\n";

      List<String> prompts = getPromptsFromAnswers(locationAnswers);

      for (String prompt in prompts) {
        List<String> checkupObjectNames = getCheckupObjectNamesForPrompt(locationAnswers, prompt, location, dm);
        String? answerNotes = getAnswerNotesForPrompt(locationAnswers, prompt, location, dm);
        reportString += "${formatPrompt(prompt, checkupObjectNames, answerNotes)}\n";
      }

      reportString += "\n";
    }

    return reportString.trim();
  }

  List<String> getCheckupObjectNamesForPrompt(List<TaskAnswer> answers, String prompt, Location location, DataMaster dm) {
    List<String> output = List.empty(growable: true);

    for (var answerIndex = 0; answerIndex < answers.length; answerIndex++) {
      var answer = answers[answerIndex];
      if (answer.failAnswerPrompt == prompt) {
        var checkupObject = location.getCheckupObjectById(answer.objectId);
        output.add(checkupObject.getFullName(dm));
      }
    }

    return output;
  }

  List<TaskAnswer> getAnswersByLocation(Location location, DataMaster dm, [bool falseOnly = true]) {
    List<TaskAnswer> locationAnswers = List.empty(growable: true);

    for (var objectIndex = 0; objectIndex < location.objects.length; objectIndex++) {
      CheckupObject object = location.objects[objectIndex];
      if (object.getObjectType(dm) == null) {
        continue;
      }
      var objectTasks = object.getObjectType(dm)!.getTasks(dm);
      for (var taskIndex = 0; taskIndex < objectTasks.length; taskIndex++) {
        var task = objectTasks[taskIndex];
        TaskAnswer? objectTaskAnswer = getTaskAnswerByObjectAndTaskIds(object.id, task.id);
        if (objectTaskAnswer != null && !(objectTaskAnswer.status && falseOnly)) {
          locationAnswers.add(objectTaskAnswer);
        }
      }
    }

    return locationAnswers;
  }

  List<String> getPromptsFromAnswers(List<TaskAnswer> locationAnswers) {
    List<String> answerPrompts = List.empty(growable: true);

    for (var answerIndex = 0; answerIndex < locationAnswers.length; answerIndex++) {
      TaskAnswer answer = locationAnswers[answerIndex];
      if (answer.failAnswerPrompt != null && !answerPrompts.contains(answer.failAnswerPrompt)) {
        answerPrompts.add(answer.failAnswerPrompt!);
      }
    }

    return answerPrompts;
  }

  List<String> getPromptsFromLocation(Location location, DataMaster dm, [bool falseOnly = true]) =>
      getPromptsFromAnswers(getAnswersByLocation(location, dm, falseOnly));

  TaskAnswer? getTaskAnswerByObjectId(int id) {
    for (var i = 0; i < answers.length; i++) {
      if (answers[i].objectId == id) {
        return answers[i];
      }
    }
    return null;
  }

  List<TaskAnswer> getTaskAnswersByObjectId(int id) {
    List<TaskAnswer> output = List.empty(growable: true);
    for (var i = 0; i < answers.length; i++) {
      if (answers[i].objectId == id) {
        output.add(answers[i]);
      }
    }
    return output;
  }

  TaskAnswer? getTaskAnswerByObjectAndTaskIds(int objectId, int taskId) {
    for (var i = 0; i < answers.length; i++) {
      if (answers[i].objectId == objectId && answers[i].taskId == taskId) {
        return answers[i];
      }
    }
    return null;
  }

  String formatPrompt(String prompt, List<String> checkupObjectNames, String? notes) {
    // RegExp matchWholeKey = RegExp(r'/\{.*?\}/gm');
    RegExp matchNonSingular = RegExp(r'(\|.*?})|{');
    RegExp matchNonPlural = RegExp(r'({.*?\|)|}');

    var isSingular = checkupObjectNames.length == 1;
    prompt = isSingular
        ? prompt.replaceAllMapped(matchNonSingular, (match) => "")
        : prompt.replaceAllMapped(matchNonPlural, (match) => "");

    prompt = prompt.replaceAll('%', checkupObjectNames.join(', '));

    if (notes != null && notes != "") {
      prompt += " ($notes)";
    }

    return prompt;
  }

  List<XFile> getAnswerImages() {
    List<XFile> output = List.empty(growable: true);

    for (var answer in answers) {
      if (answer.photo != null) {
        output.add(XFile.fromData(base64Decode(answer.photo!), mimeType: 'image/jpeg'));
      }
    }

    return output;
  }

  void share(DataMaster dm) {
    var answerImages = getAnswerImages();
    var reportString = getReportString(dm);
    if (answerImages.isNotEmpty) {
      Share.shareXFiles(answerImages, text: reportString);
    } else {
      Share.share(reportString);
    }
  }

  factory ReportAnswer.fromJson(Map<String, dynamic> json) => _$ReportAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$ReportAnswerToJson(this);

  String? getAnswerNotesForPrompt(List<TaskAnswer> locationAnswers, String prompt, Location location, DataMaster dm) {
    List<CheckupObject> objects = List.empty(growable: true);
    List<String> answerNotes = List.empty(growable: true);

    for (var answer in locationAnswers) {
      if (answer.failAnswerPrompt == prompt && answer.notes != null) {
        objects.add(location.getCheckupObjectById(answer.objectId));
        answerNotes.add(answer.notes!);
      }
    }

    if (answerNotes.isEmpty) {
      return null;
    }

    if (objects.length > 1) {
      for (var i = 0; i < answerNotes.length; i++) {
        answerNotes[i] = "${objects[i].getFullName(dm)}: ${answerNotes[i]}";
      }
    }

    return answerNotes.join('; ').trim();
  }
}
