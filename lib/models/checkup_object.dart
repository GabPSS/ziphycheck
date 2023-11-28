import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkup_object.g.dart';

@JsonSerializable()
class CheckupObject {
  int id;
  String name;
  int? objectTypeId;

  CheckupObject(
      {this.id = -1, this.name = "Unnamed object", this.objectTypeId});

  factory CheckupObject.fromJson(Map<String, dynamic> json) =>
      _$CheckupObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CheckupObjectToJson(this);

  ObjectType? getObjectType(DataMaster dm) =>
      objectTypeId != null ? dm.getObjectById<ObjectType>(objectTypeId!) : null;
  set objectType(ObjectType? value) => objectTypeId = value?.id;
}
