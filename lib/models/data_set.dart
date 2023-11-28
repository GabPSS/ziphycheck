import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_set.g.dart';

@JsonSerializable()
class DataSet {
  List<Check> checks = List.empty(growable: true);
  List<ObjectType> objectTypes = List.empty(growable: true);
  List<Report> reports = List.empty(growable: true);
  List<ReportAnswer> reportAnswers = List.empty(growable: true);

  int checkKey = -1;
  int objectTypeKey = -1;
  int reportKey = -1;
  int reportAnswerKey = -1;

  DataSet();

  factory DataSet.fromJson(Map<String, dynamic> json) =>
      _$DataSetFromJson(json);

  Map<String, dynamic> toJson() => _$DataSetToJson(this);

  Map<Type, int> get _keys => {
        Check: checkKey,
        ObjectType: objectTypeKey,
        Report: reportKey,
        ReportAnswer: reportAnswerKey
      };

  int? getId<T>() {
    incrementId<T>();
    return _keys[T];
  } //TODO: Write way to update IDs

  void incrementId<T>() {
    switch (T) {
      case Check:
        checkKey++;
        break;
      case ObjectType:
        objectTypeKey++;
        break;
      case Report:
        reportKey++;
        break;
      case ReportAnswer:
        reportAnswerKey++;
        break;
    }
  }
}
