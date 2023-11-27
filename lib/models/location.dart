import 'package:checkup_app/models/checkup_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  int id;
  String name;
  List<CheckupObject> checkupObjects;

  Location({this.id = -1, required this.name, required this.checkupObjects});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
