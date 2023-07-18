import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkup_object.g.dart';

@JsonSerializable()
class CheckupObject {
  late int id = -1;
  String name = "";

  int? objectTypeId; //TODO: Stopped here

  ObjectType? getObjectType(DataMaster dm) => objectTypeId != null ? dm.getObjectTypeById(objectTypeId!) : null;

  set objectType(ObjectType? value) => objectTypeId = value?.id;

  CheckupObject({Report? report, ObjectType? objectType}) {
    this.objectType = objectType;
    if (report != null) {
      id = report.checkupObjectKey;
      report.checkupObjectKey++;
    }
  }

  String getFullName(DataMaster dm) => (getObjectType(dm)?.name ?? "") + name;

  factory CheckupObject.fromJson(Map<String, dynamic> json) => _$CheckupObjectFromJson(json);

  Map<String, dynamic> toJson() => _$CheckupObjectToJson(this);
}
