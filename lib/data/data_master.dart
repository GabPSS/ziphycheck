import 'package:checkup_app/models/data_set.dart';
import 'package:checkup_app/models/check.dart';
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

  Future<void> init() async {
    _dataSet = await storage.getData();
  }

  void open() {
    //TODO: Write function to open files
    throw UnimplementedError();
  }

  void save() => storage.save(_dataSet);

  void export() {
    //TODO: Write function to export datasets without answers
    throw UnimplementedError();
  }
}
