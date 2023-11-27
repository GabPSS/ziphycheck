import 'package:checkup_app/data/data_set.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';

class DataMaster extends ChangeNotifier {
  DataSet _dataSet = DataSet();

  List<Check> get checks => _dataSet.checks;
  List<ObjectType> get objectTypes => _dataSet.objectTypes;
  List<Report> get reports => _dataSet.reports;
  List<ReportAnswer> get reportAnswers => _dataSet.reportAnswers;

  void initDataset() async {
    //TODO: Write function to retrieve dataset
    _dataSet = DataSet();
  }

  void open() {
    //TODO: Write function to open files
    throw UnimplementedError();
  }

  void save() {
    //TODO: Write function to save files
    throw UnimplementedError();
  }

  void export() {
    //TODO: Write function to export datasets without answers
    throw UnimplementedError();
  }
}
