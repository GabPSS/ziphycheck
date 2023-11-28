import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/data_set.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/data/storage.dart';
import 'package:flutter/material.dart';

class DataMaster extends ChangeNotifier {
  Storage storage = Storage();
  DataSet _dataSet = DataSet();

  List<Check> get checks => _dataSet.checks;
  List<ObjectType> get objectTypes => _dataSet.objectTypes;
  List<Report> get reports => _dataSet.reports;
  List<ReportAnswer> get reportAnswers => _dataSet.reportAnswers;

  T getObjectById<T>(int id) {
    List<IdentifiableObject>? list = switch (T) {
      Check => checks,
      ObjectType => objectTypes,
      Report => reports,
      ReportAnswer => reportAnswers,
      Type() => null,
    };

    return (list?.firstWhere((element) => element.id == id)
        as IdentifiableObject) as T;
  }

  Future<void> init() async {
    _dataSet = await storage.getData();
  }

  Future<void> import() async {
    DataSet? dataSet = await storage.open();
    if (dataSet != null) _dataSet = dataSet;
    notifyListeners();
  }

  void save() => storage.save(_dataSet);

  void export() {
    //TODO: Write function to export datasets without answers
    throw UnimplementedError();
  }

  void removeReport(Report report) {
    reports.remove(report);
    update();
  }

  void removeObject(Object object) {
    _getObjectList(object)?.remove(object);
    update();
  }

  void addObject(IdentifiableObject object) {
    object.id = _dataSet.getIdFor(object) ?? -1;
    _getObjectList(object)?.add(object);
    update();
  }

  List<Object>? _getObjectList(Object object) {
    List<Object>? list;
    if (object is Check) list = checks;
    if (object is ObjectType) list = objectTypes;
    if (object is Report) list = reports;
    if (object is ReportAnswer) list = reportAnswers;
    return list;
  }

  void update() {
    save();
    notifyListeners();
  }

  List<ReportAnswer> getAnswersForReport(Report report) => List.from(
      reportAnswers.where((element) => element.reportId == report.id));

  List<Check> getChecksForObjectType(ObjectType? ot) => checks
      .where((element) => ot?.checkIds.contains(element.id) ?? false)
      .toList();

  List<Check> getChecksForLocation(Location location) {
    List<ObjectType> types = List.empty(growable: true);

    for (CheckupObject object in location.checkupObjects) {
      ObjectType? objectType = object.getObjectType(this);
      if (objectType != null && !types.contains(objectType)) {
        types.add(objectType);
      }
    }

    List<Check> checks = List.empty(growable: true);
    for (ObjectType type in types) {
      checks.addAll(getChecksForObjectType(type)
          .where((element) => !checks.contains(element)));
    }

    return checks;
  }

  List<CheckupObject> filterObjectsByCheck(
      List<CheckupObject> objects, Check check) {
    List<CheckupObject> objects2 = List.empty(growable: true);

    for (var object in objects) {
      var objectType = object.getObjectType(this);
      if (objectType != null) {
        var tasks = getChecksForObjectType(objectType);
        if (tasks.contains(check)) {
          objects2.add(object);
        }
      }
    }

    return objects2;
  }
}
