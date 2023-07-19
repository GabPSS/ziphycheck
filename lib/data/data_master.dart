import 'dart:convert';

import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
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

  List<Task> getTasksForLocation(Location location) {
    List<ObjectType> types = List.empty(growable: true);

    for (CheckupObject object in location.objects) {
      ObjectType? objectType = object.getObjectType(this);
      if (objectType != null && !types.contains(objectType)) {
        types.add(objectType);
      }
    }

    List<Task> tasks = List.empty(growable: true);
    for (ObjectType type in types) {
      tasks.addAll(type.getTasks(this).where((element) => !tasks.contains(element)));
    }

    return tasks;
  }

  List<CheckupObject> getObjectsByTask(Task task, Location location) {
    List<CheckupObject> objects = List.empty(growable: true);

    for (var object in location.objects) {
      var objectType = object.getObjectType(this);
      if (objectType != null) {
        var tasks = objectType.getTasks(this);
        if (tasks.contains(task)) {
          objects.add(object);
        }
      }
    }

    return objects;
  }
}
