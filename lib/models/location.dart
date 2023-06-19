import 'package:checkup_app/models/checkup_object.dart';

class Location {
  String name = "";
  List<CheckupObject> objects = List.empty(growable: true);
}