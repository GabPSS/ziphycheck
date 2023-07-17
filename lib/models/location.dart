import 'package:checkup_app/models/checkup_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  String name = "";
  List<CheckupObject> objects = List.empty(growable: true);

  CheckupObject getCheckupObjectById(int id) => objects.where((element) => element.id == id).first;

  Location();

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
