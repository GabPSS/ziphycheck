import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:share_plus/share_plus.dart';

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
    //TODO: Implement sharing
    Share.share(makeString(dm));
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

  Map<String, dynamic> getCheckupObjectInfo(CheckupObject co, DataMaster dm) {
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
      List<CheckupObject>? allObjects =
          dm.getObjectById<Report>(reportId).getLocationOf(co)?.checkupObjects;

      return {
        'index': (allObjects?.indexOf(co) ?? -2) + 1,
        'objs': allObjects?.length ?? -1,
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
  ///- "%ID" = Index of the object in its location
  ///- "%OB" = Total objects in object's location  ///
  ///- "%TT" = Total of object's checks
  ///- "%AW" = Number of answered checks
  ///- "%IS" = Number of reported issues
  ///- "%s##" = Include an "s" if ## is plural (## can be any of the above, excluding % sign)
  String formatCheckupObjectInfo(
      CheckupObject co, DataMaster dm, String format) {
    Map<String, dynamic> map = getCheckupObjectInfo(co, dm);
    format = format.replaceAll('%ID', map['index'].toString());
    format = format.replaceAll('%OB', map['objs'].toString());
    format = format.replaceAll('%TT', map['total'].toString());
    format = format.replaceAll('%AW', map['answers'].toString());
    format = format.replaceAll('%IS', map['issues'].toString());

    format = format.replaceAll('%sID', map['index'] != 1 ? "s" : "");
    format = format.replaceAll('%sOB', map['objs'] != 1 ? "s" : "");
    format = format.replaceAll('%sTT', map['total'] != 1 ? "s" : "");
    format = format.replaceAll('%sAW', map['answers'] != 1 ? "s" : "");
    format = format.replaceAll('%sIS', map['issues'] != 1 ? "s" : "");
    return format;
  }

  List<CheckAnswer> getAnswersByLocation(Location location, DataMaster dm,
      [bool falseOnly = true]) {
    // List<CheckAnswer> locationAnswers = List.empty(growable: true);

    // for (var objectIndex = 0;
    //     objectIndex < location.checkupObjects.length;
    //     objectIndex++) {
    //   CheckupObject object = location.checkupObjects[objectIndex];
    //   if (object.getObjectType(dm) == null) {
    //     continue;
    //   }
    //   // var objectChecks = dm.getChecksForObjectType(object.getObjectType(dm));
    //   // for (var checkIndex = 0; checkIndex < objectChecks.length; checkIndex++) {
    //   //   var check = objectChecks[checkIndex];
    //   //   CheckAnswer? objectCheckAnswer = getCheckAnswer(object.id, check.id);
    //   //   if (objectCheckAnswer != null &&
    //   //       !(objectCheckAnswer.status && falseOnly)) {
    //   //     locationAnswers.add(objectCheckAnswer);
    //   //   }
    //   // }
    // }

    return checkAnswers
        .where((element) =>
            location.checkupObjectIds.contains(element.objectId) &&
            !(element.status && falseOnly))
        .toList();

    // return locationAnswers;
  }

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

  String makeString(DataMaster dm) {
    Report? report =
        dm.reports.where((element) => element.id == reportId).firstOrNull;
    if (report == null) return "";

    String output =
        "${report.name} ${DateFormat("dd/MM").format(answerDate)}\n\n";

    for (Location location in report.locations) {
      output += "${makeLocationString(location, dm)}\n\n";
    }

    return output.trim();
  }

  String makeLocationString(Location location, DataMaster dm) {
    String output = "${location.name}\n\n";

    List<String> issues = getFormattedIssues(location, dm);

    if (issues.isEmpty) {
      output += "No issues found";
    } else {
      output += "${issues.join("\n")}\n\n";
    }

    output += formatLocationAnswer(location);

    return output.trim();
  }

  List<String> getFormattedIssues(Location location, DataMaster dm) {
    List<Issue> issues = List.empty(growable: true);
    List<CheckAnswer> answers = getAnswersByLocation(location, dm).toList();
    for (CheckAnswer answer in answers) {
      issues.addAll(answer.issues);
    }

    return issues.map((e) => formatIssueString(e.name, location, dm)).toList();
  }

  String formatIssueString(String source, Location location, DataMaster dm) {
    //Obtain all issues that match the name
    //Obtain list of objects that have issues with that name matching
    //format accordingly

    List<CheckAnswer> matchingAnswers = checkAnswers
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

    String suffix = "";
    if (plural) {
      suffix = issueMap.entries
          .map((e) => e.key.notes != null
              ? "${e.value?.getFullName(dm)}: ${e.key.notes}${e.key.solved ? ", solved" : ""}" //TODO: Localize this
              : null)
          .where((element) => element != null)
          .cast<String>()
          .join("; ");
    } else {
      suffix = issueMap.entries
          .map((e) => [
                if (e.key.notes != null) e.key.notes,
                (e.key.solved ? "solved" : "")
              ].join(", "))
          .join("; ");
    }

    if (suffix.trim() != "") suffix = "($suffix)";

    List<String> matchingObjectNames = matchingAnswers
        .map((e) => location.getCheckupObjectById(e.objectId)?.getFullName(dm))
        .where((element) => element != null)
        .cast<String>()
        .toList();

    source = formatIssueBody(source, plural, matchingObjectNames);

    return "$source $suffix".trim();
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

  String formatLocationAnswer(Location location) {
    String output = "";
    LocationAnswer? answer = locationAnswers
        .where((element) =>
            element.locationId == location.id && element.notes != null)
        .singleOrNull;
    if (answer != null) {
      output = "Notes: "; //TODO: Localize this too
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
