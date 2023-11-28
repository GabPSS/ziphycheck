import 'package:checkup_app/models/checkup_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  int id;
  String name;
  List<CheckupObject> checkupObjects = List.empty(growable: true);

  Location({this.id = -1, this.name = "Unnamed location"});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
