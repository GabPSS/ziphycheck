import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/location_answer.dart';

class ReportAnswer {
  int id;
  int reportId;
  DateTime answerTimestamp = DateTime.now();
  List<CheckAnswer> checkAnswers = List.empty(growable: true);
  List<LocationAnswer> locationAnswers = List.empty(growable: true);

  ReportAnswer({this.id = -1, required this.reportId});
}
