import 'package:checkup_app/models/checkup_object.dart';

class Location {
  int id;
  String name;
  List<CheckupObject> checkupObjects;

  Location({this.id = -1, required this.name, required this.checkupObjects});
}
