import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:json_annotation/json_annotation.dart';

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

  void share() {
    //TODO: Implement sharing
    throw UnimplementedError();
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
    List<CheckAnswer> locationAnswers = List.empty(growable: true);

    for (var objectIndex = 0;
        objectIndex < location.checkupObjects.length;
        objectIndex++) {
      CheckupObject object = location.checkupObjects[objectIndex];
      if (object.getObjectType(dm) == null) {
        continue;
      }
      var objectChecks = dm.getChecksForObjectType(object.getObjectType(dm));
      for (var checkIndex = 0; checkIndex < objectChecks.length; checkIndex++) {
        var check = objectChecks[checkIndex];
        CheckAnswer? objectCheckAnswer = getCheckAnswer(object.id, check.id);
        if (objectCheckAnswer != null &&
            !(objectCheckAnswer.status && falseOnly)) {
          locationAnswers.add(objectCheckAnswer);
        }
      }
    }

    return locationAnswers;
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
}
