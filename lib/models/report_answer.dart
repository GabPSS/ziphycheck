import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/object_type.dart';
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

  Map<String, dynamic> getCheckupObjectInfo(CheckupObject co, DataMaster dm) {
    if (co.objectTypeId != null) {
      List<int> checkIdsForCheckupObject = dm
          .getChecksForObjectType(
              dm.getObjectById<ObjectType>(co.objectTypeId!))
          .map((e) => e.id)
          .toList();
      Iterable<CheckAnswer> answersForCheckupObject =
          checkAnswers.where((answer) => answer.objectId == co.id);
      Iterable<CheckAnswer> answersWithIssues =
          answersForCheckupObject.where((element) => element.status = false);

      return {
        'total': checkIdsForCheckupObject.length,
        'answers': answersForCheckupObject.length,
        'checked':
            checkIdsForCheckupObject.length == answersForCheckupObject.length,
        'issues': answersWithIssues.length
      };
    }
    return {'total': 0, 'answers': 0, 'issues': 0};
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
        CheckAnswer? objectCheckAnswer =
            getCheckAnswerByObjectAndTaskIds(object.id, check.id);
        if (objectCheckAnswer != null &&
            !(objectCheckAnswer.status && falseOnly)) {
          locationAnswers.add(objectCheckAnswer);
        }
      }
    }

    return locationAnswers;
  }

  CheckAnswer? getCheckAnswerByObjectAndTaskIds(int objectId, int taskId) {
    for (var i = 0; i < checkAnswers.length; i++) {
      if (checkAnswers[i].objectId == objectId &&
          checkAnswers[i].checkId == taskId) {
        return checkAnswers[i];
      }
    }
    return null;
  }
}
