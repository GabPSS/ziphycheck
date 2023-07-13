import 'package:checkup_app/models/location.dart';

import '../data/data_master.dart';

class Report {
  late int id;
  String name = "";
  List<Location> locations = List.empty(growable: true);
  int checkupObjectKey = 0;

  DataMaster dm;

  Report({required this.dm}) {
    id = dm.reportKey;
    dm.reportKey++;
  }

  int getObjectCount() {
    int objectCount = 0;
    for (var i = 0; i < locations.length; i++) {
      objectCount += locations[i].objects.length;
    }
    return objectCount;
  }

  DateTime? getLastFilledDate() {
    for (var i = 0; i < dm.reportAnswers.length; i++) {
      var reportAnswer = dm.reportAnswers[i];
      if (reportAnswer.id == id) {
        return reportAnswer.answerDate;
      }
    }
    return null;
  }
}
