import 'package:checkup_app/models/location.dart';

import '../data/data_master.dart';

class Report {
  late int id;
  String name = "";
  List<Location> locations = List.empty(growable: true);
  int checkupObjectKey = 0;

  Report({required DataMaster dm}) {
    id = dm.reportKey;
    dm.reportKey++;
  }
}