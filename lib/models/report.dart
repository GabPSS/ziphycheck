import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report extends IdentifiableObject {
  String name;
  List<Location> locations = List.empty(growable: true);

  int checkupObjectKey = -1;
  int locationKey = -1;

  Report({super.id = -1, required this.name});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);

  Location? getLocationOf(CheckupObject object) {
    return locations
        .where((element) => element.checkupObjects.contains(object))
        .singleOrNull;
  }

  void addLocation(Location location) {
    locationKey++;
    location.id = locationKey;
    locations.add(location);
  }

  void addObject(Location location, CheckupObject object) {
    checkupObjectKey++;
    object.id = checkupObjectKey;
    location.checkupObjects.add(object);
  }
}
