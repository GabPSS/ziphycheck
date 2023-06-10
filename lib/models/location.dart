import 'package:checkup_app/models/CheckupObject.dart';

class Location {
  String name = "";
  List<CheckupObject> objects = List.empty(growable: true);
}