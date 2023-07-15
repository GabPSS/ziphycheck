import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';

class CheckupObject {
  late int id;
  ObjectType? objectType;
  String name = "";

  CheckupObject({required Report report, this.objectType}) {
    id = report.checkupObjectKey;
    report.checkupObjectKey++;
  }
}
