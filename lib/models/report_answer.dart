import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
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
}
