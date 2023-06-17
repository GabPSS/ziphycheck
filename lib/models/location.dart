import 'package:checkup_app/models/checkupObject.dart';

class Location {
  String name = "";
  List<CheckupObject> objects = List.empty(growable: true);
}