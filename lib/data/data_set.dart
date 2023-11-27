import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';

class DataSet {
  List<Check> checks = List.empty(growable: true);
  List<ObjectType> objectTypes = List.empty(growable: true);
  List<Report> reports = List.empty(growable: true);
  List<ReportAnswer> reportAnswers = List.empty(growable: true);

  int checkKey = 0;
  int objectTypeKey = 0;
  int reportKey = 0;
  int reportAnswerKey = 0;

  Map<Type, int> get _keys => {
        Check: checkKey,
        ObjectType: objectTypeKey,
        Report: reportKey,
        ReportAnswer: reportAnswerKey
      };

  int? getId<T>() => _keys[T]; //TODO: Write way to update IDs
}
