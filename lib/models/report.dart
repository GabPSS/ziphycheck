import 'package:checkup_app/models/location.dart';

class Report {
  int id;
  String name;
  List<Location> locations;

  int checkupObjectKey = 0;
  int locationKey = 0;

  Report({this.id = -1, required this.name, required this.locations});
}
