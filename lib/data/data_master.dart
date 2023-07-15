import 'package:checkup_app/models/task.dart';

import '../models/object_type.dart';
import '../models/report.dart';
import '../models/report_answer.dart';

class DataMaster {
  List<Report> reports = List.empty(growable: true);
  List<ObjectType> objectTypes = List.empty(growable: true);
  List<Task> tasks = List.empty(growable: true);
  List<ReportAnswer> reportAnswers = List.empty(growable: true);

  int reportKey = 0;
  int objectTypeKey = 0;
  int taskKey = 0;
  int reportAnswerKey = 0;

  static const String unknownObject = "Unknown Object";

  List<ReportAnswer> getAnswersForReport(Report report) {
    return List.from(reportAnswers.where((element) => element.baseReportId == report.id));
  }

  Report getReportById(int id) => reports.where((element) => element.id == id).first;
}
