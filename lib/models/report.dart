import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data/data_master.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  late int id;
  String name = "";
  List<Location> locations = List.empty(growable: true);
  int checkupObjectKey = 0;

  Report({DataMaster? dm}) {
    if (dm != null) {
      id = dm.reportKey;
      dm.reportKey++;
    }
  }

  int getObjectCount() {
    int objectCount = 0;
    for (var i = 0; i < locations.length; i++) {
      objectCount += locations[i].objects.length;
    }
    return objectCount;
  }

  DateTime? getLastFilledDate(DataMaster dm) {
    for (var i = 0; i < dm.reportAnswers.length; i++) {
      var reportAnswer = dm.reportAnswers[i];
      if (reportAnswer.id == id) {
        return reportAnswer.answerDate;
      }
    }
    return null;
  }

  CheckupObject? getCheckupObjectById(int id) {
    for (var locationIndex = 0; locationIndex < locations.length; locationIndex++) {
      for (var checkupObject in locations[locationIndex].objects) {
        if (checkupObject.id == id) return checkupObject;
      }
    }
    return null;
  }

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
