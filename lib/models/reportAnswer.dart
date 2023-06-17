import '../data/dataMaster.dart';
import 'taskAnswer.dart';

class ReportAnswer {
  late int id;
  int baseReportId = -1;
  DateTime answerDate = DateTime.now();
  List<TaskAnswer> answers = List.empty(growable: true);

  ReportAnswer({required DataMaster dm, required this.baseReportId}) {
    id = dm.reportAnswerKey;
    dm.reportAnswerKey++;
  }
}