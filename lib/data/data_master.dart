import 'dart:convert';

import 'package:checkup_app/models/task.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localstorage/localstorage.dart';

import '../models/object_type.dart';
import '../models/report.dart';
import '../models/report_answer.dart';

part 'data_master.g.dart';

@JsonSerializable()
class DataMaster {
  List<Task> tasks = List.empty(growable: true);
  List<ObjectType> objectTypes = List.empty(growable: true);
  List<Report> reports = List.empty(growable: true);
  List<ReportAnswer> reportAnswers = List.empty(growable: true);

  int reportKey = 0;
  int objectTypeKey = 0;
  int taskKey = 0;
  int reportAnswerKey = 0;

  DataMaster();

  @JsonKey(includeFromJson: false, includeToJson: false)
  Function()? saveFunction;

  void save() {
    if (saveFunction != null) saveFunction!();
  }

  static const String unknownObject = "Unknown Object";

  List<ReportAnswer> getAnswersForReport(Report report) {
    return List.from(reportAnswers.where((element) => element.baseReportId == report.id));
  }

  Report getReportById(int id) => reports.where((element) => element.id == id).first;

  ObjectType getObjectTypeById(int id) => objectTypes.where((element) => element.id == id).first;

  factory DataMaster.fromJson(Map<String, dynamic> json) => _$DataMasterFromJson(json);

  Map<String, dynamic> toJson() => _$DataMasterToJson(this);

  static DataMaster fromStorage(LocalStorage storage) {
    String? data = storage.getItem('data');
    if (data != null) {
      DataMaster dm = DataMaster.fromJson(jsonDecode(data));

      return dm;
    } else {
      var dm = DataMaster();

      return dm;
    }
  }
}
