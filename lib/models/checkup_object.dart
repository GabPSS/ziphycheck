import 'package:json_annotation/json_annotation.dart';

part 'checkup_object.g.dart';

@JsonSerializable()
class CheckupObject {
  int id;
  String name;
  int? objectTypeId;

  CheckupObject({this.id = -1, required this.name, required this.objectTypeId});

  factory CheckupObject.fromJson(Map<String, dynamic> json) =>
      _$CheckupObjectFromJson(json);
}
