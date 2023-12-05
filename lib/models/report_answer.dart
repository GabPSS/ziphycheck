import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

part 'report_answer.g.dart';

@JsonSerializable()
class ReportAnswer extends IdentifiableObject {
  int reportId;
  DateTime answerDate = DateTime.now();
  List<CheckAnswer> checkAnswers = List.empty(growable: true);
  List<LocationAnswer> locationAnswers = List.empty(growable: true);

  ReportAnswer({super.id = -1, required this.reportId});

  factory ReportAnswer.fromJson(Map<String, dynamic> json) =>
      _$ReportAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$ReportAnswerToJson(this);

  void share(DataMaster dm) {
    //TODO: Implement sharing && locale overriding
    //TODO: #31 Implement a settings panel
    Share.share(buildString(dm));
  }

  void markObjectTasksTrue(CheckupObject co, DataMaster dm) {
    removeObjectAnswers(co);

    checkAnswers.addAll(
      dm.getChecksForObjectType(co.getObjectType(dm)).map(
        (check) {
          return CheckAnswer(checkId: check.id, objectId: co.id, status: true);
        },
      ),
    );
  }

  void removeObjectAnswers(CheckupObject co) =>
      checkAnswers.removeWhere((element) => element.objectId == co.id);

  Map<String, dynamic> getCheckupObjectInfo(CheckupObject co, DataMaster dm,
      [Check? check]) {
    if (co.objectTypeId != null) {
      List<int> checkIdsForCheckupObject = dm
          .getChecksForObjectType(
              dm.getObjectById<ObjectType>(co.objectTypeId!))
          .map((e) => e.id)
          .toList();
      Iterable<CheckAnswer> answersForCheckupObject = checkAnswers.where(
          (answer) => answer.objectId == co.id); //&& answer.checkId != null);
      int answersWithIssues = answersForCheckupObject
          .where((element) => element.status == false)
          .fold<int>(
              0,
              (previousValue, element) =>
                  previousValue + element.issues.length);
      List<CheckupObject>? locationObjects =
          dm.getObjectById<Report>(reportId).getLocationOf(co)?.checkupObjects;

      List<CheckupObject>? objects = check == null
          ? locationObjects
          : dm.getObjectsByCheck(locationObjects ?? [], check);

      int index = (objects?.indexOf(co) ?? -2) + 1;
      int totalObjects = objects?.length ?? -1;

      return {
        'index': index,
        'objs': totalObjects,
        'total': checkIdsForCheckupObject.length,
        'answers': answersForCheckupObject
            .where((element) => element.checkId != null)
            .length,
        'checked':
            checkIdsForCheckupObject.length == answersForCheckupObject.length,
        'issues': answersWithIssues
      };
    }
    return {};
  }

  ///Gets checkupobject info and formats it onto a string using the specified [format]
  ///
  ///Format options:
  ///- "%ID" = Index of the object in its location (or in relation to [check])
  ///- "%OB" = Total objects in object's location  (or in relation to [check])
  ///- "%TT" = Total of object's checks
  ///- "%AW" = Number of answered checks
  ///- "%IS" = Number of reported issues
  ///- "%abc|def|##" = "abc" if ## (one of the codes above, without the percent sign) is singular, "def" if plural
  String formatCheckupObjectInfo(CheckupObject co, DataMaster dm, String format,
      [Check? check]) {
    Map<String, dynamic> map = getCheckupObjectInfo(co, dm, check);
    format = format.replaceAll('%ID', map['index'].toString());
    format = format.replaceAll('%OB', map['objs'].toString());
    format = format.replaceAll('%TT', map['total'].toString());
    format = format.replaceAll('%AW', map['answers'].toString());
    format = format.replaceAll('%IS', map['issues'].toString());

    format = _formatInfoItem(format, "ID", map['index'] != 1);
    format = _formatInfoItem(format, "OB", map['objs'] != 1);
    format = _formatInfoItem(format, "TT", map['total'] != 1);
    format = _formatInfoItem(format, "AW", map['answers'] != 1);
    format = _formatInfoItem(format, "IS", map['issues'] != 1);
    return format;
  }

  String _formatInfoItem(String source, String code, bool plural) {
    Iterable<RegExpMatch> allMatches =
        RegExp(r'%([^%]*)\|([^%]*)\|' + code).allMatches(source);
    for (var match in allMatches) {
      source = source.replaceAll(match[0] ?? "", match[plural ? 2 : 1] ?? "");
    }
    return source;
  }

  List<CheckAnswer> getAnswersByLocation(Location location, DataMaster dm,
          [bool falseOnly = true]) =>
      checkAnswers
          .where((element) =>
              location.checkupObjectIds.contains(element.objectId) &&
              !(element.status && falseOnly))
          .toList();

  CheckAnswer? getCheckAnswer(int objectId, int taskId) {
    for (var i = 0; i < checkAnswers.length; i++) {
      if (checkAnswers[i].objectId == objectId &&
          checkAnswers[i].checkId == taskId) {
        return checkAnswers[i];
      }
    }
    return null;
  }

  CheckAnswer getOrCreateAnswer(int objectId, int checkId) {
    var answer = getCheckAnswer(objectId, checkId);
    if (answer == null) {
      answer = CheckAnswer(checkId: checkId, objectId: objectId);
      checkAnswers.add(answer);
    }
    return answer;
  }

  List<Issue> getObjectIssues(CheckupObject object) {
    List<Issue> issues = List.empty(growable: true);
    getAnswersByObject(object).forEach((element) {
      issues.addAll(element.issues);
    });
    return issues;
  }

  List<Issue> getCustomIssuesByObject(CheckupObject object, DataMaster dm) {
    List<CheckAnswer> answersByObject = getAnswersByObject(object);

    List<Issue> issues = List.empty(growable: true);

    for (var answer in answersByObject) {
      if (answer.checkId == null) {
        issues.addAll(answer.issues);
        continue;
      }

      List<String> failOptions =
          dm.getObjectById<Check>(answer.checkId!).failOptions;

      issues.addAll(answer.issues
          .where((element) => !failOptions.contains(element.name)));
    }

    return issues;
  }

  void removeIssue(Issue issue, CheckupObject object) =>
      getAnswersByObject(object)
          .forEach((element) => element.issues.remove(issue));

  List<CheckAnswer> getAnswersByObject(CheckupObject object) =>
      checkAnswers.where((element) => element.objectId == object.id).toList();

  LocationAnswer getOrCreateLocationAnswer(Location location) =>
      locationAnswers.singleWhere(
        (element) => element.locationId == location.id,
        orElse: () {
          LocationAnswer newAnswer =
              LocationAnswer(locationId: location.id, status: true);
          locationAnswers.add(newAnswer);
          return newAnswer;
        },
      );

  String buildString(DataMaster dm,
      [Locale locale = const Locale('en', 'US')]) {
    Report? report =
        dm.reports.where((element) => element.id == reportId).firstOrNull;
    if (report == null) return "";

    String output =
        "${report.name} ${DateFormat("dd/MM").format(answerDate)}\n\n";

    for (Location location in report.locations) {
      output += "${buildLocationString(location, dm, locale)}\n\n";
    }

    return output.trim();
  }

  String buildLocationString(Location location, DataMaster dm,
      [Locale locale = const Locale('en', 'US')]) {
    AppLocalizations localizations = lookupAppLocalizations(locale);

    String output = "${location.name}\n\n";

    List<String> issues = formatIssuesAtLocation(location, dm);

    if (issues.isEmpty) {
      output += localizations.noIssuesFoundReportText;
    } else {
      output += "${issues.join("\n")}\n\n";
    }

    output += formatLocationAnswer(location, locale);

    return output.trim();
  }

  List<String> formatIssuesAtLocation(Location location, DataMaster dm,
      [Locale locale = const Locale('en', 'US')]) {
    List<String> allIssueNames = List.empty(growable: true);

    List<CheckAnswer> answers = getAnswersByLocation(location, dm).toList();
    for (CheckAnswer answer in answers) {
      allIssueNames.addAll(answer.issueNames
          .where((element) => !allIssueNames.contains(element)));
    }

    return allIssueNames
        .map((issue) => formatIssueString(issue, location, dm, locale))
        .toList();
  }

  String formatIssueString(String source, Location location, DataMaster dm,
      [Locale locale = const Locale('en', 'US')]) {
    List<CheckAnswer> matchingAnswers = getAnswersByLocation(location, dm)
        .where((element) => element.issueNames.contains(source))
        .toList();

    Map<Issue, CheckupObject?> issueMap = Map.identity();
    for (var answer in matchingAnswers) {
      List<Issue> filterIssues = answer.filterIssues(source);
      for (var issue in filterIssues) {
        issueMap
            .addAll({issue: location.getCheckupObjectById(answer.objectId)});
      }
    }

    bool plural = issueMap.length > 1;

    List<String> matchingObjectNames = matchingAnswers
        .map((e) => location.getCheckupObjectById(e.objectId)?.getFullName(dm))
        .where((element) => element != null)
        .cast<String>()
        .toList();

    source = formatIssueBody(source, plural, matchingObjectNames);
    String suffix = formatIssueSuffix(plural, issueMap, dm, locale);

    return "$source $suffix".trim();
  }

  String formatIssueSuffix(
      bool plural, Map<Issue, CheckupObject?> issueMap, DataMaster dm,
      [Locale locale = const Locale('en', 'US')]) {
    AppLocalizations localizations = lookupAppLocalizations(locale);
    String suffix = "";
    if (plural) {
      suffix = issueMap.entries
          .map((e) => e.key.notes != null
              ? "${e.value?.getFullName(dm)}: ${e.key.notes}${e.key.solved ? ", ${localizations.solvedReportText}" : ""}"
              : null)
          .where((element) => element != null)
          .cast<String>()
          .join("; ");
    } else {
      suffix = issueMap.entries
          .map((e) => [
                if (e.key.notes != null) e.key.notes,
                if (e.key.solved) localizations.solvedReportText,
              ].join(", "))
          .join("; ");
    }

    if (suffix.trim() != "") suffix = "($suffix)";
    return suffix;
  }

  String formatIssueBody(
      String source, bool plural, List<String> matchingObjectNames) {
    RegExp matchNonSingular = RegExp(r'(\|.*?})|{');
    RegExp matchNonPlural = RegExp(r'({.*?\|)|}');

    source = plural
        ? source.replaceAllMapped(matchNonPlural, (match) => "")
        : source.replaceAllMapped(matchNonSingular, (match) => "");

    source = source.replaceAll('%', matchingObjectNames.join(', '));
    return source;
  }

  String formatLocationAnswer(Location location,
      [Locale locale = const Locale('en', 'US')]) {
    AppLocalizations localizations = lookupAppLocalizations(locale);
    String output = "";
    LocationAnswer? answer = locationAnswers
        .where((element) =>
            element.locationId == location.id && element.notes != null)
        .singleOrNull;
    if (answer != null) {
      output = "${localizations.notesReportText}: ";
      List<String> notes = answer.notes!.split("\n");
      if (notes.length > 1) {
        output += "\n${notes.map((e) => "- ${e.trim()}").join("\n")}";
      } else {
        output += notes.join(". ");
      }
    }
    return output.trim();
  }
}
