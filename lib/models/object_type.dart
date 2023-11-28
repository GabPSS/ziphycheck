import 'package:checkup_app/models/identifiable_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'object_type.g.dart';

@JsonSerializable()
class ObjectType extends IdentifiableObject {
  String name;
  List<int> checkIds;

  ObjectType({super.id = -1, required this.name, required this.checkIds});

  factory ObjectType.fromJson(Map<String, dynamic> json) =>
      _$ObjectTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ObjectTypeToJson(this);
}
