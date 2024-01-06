import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/object_type.dart';
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
      dm.tryGetObjectById<ObjectType>(objectTypeId);
  set objectType(ObjectType? value) => objectTypeId = value?.id;

  String getFullName(DataMaster dm) =>
      ("${getObjectType(dm)?.name ?? ""} $name").trim();
}
