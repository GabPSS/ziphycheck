import 'package:json_annotation/json_annotation.dart';

part 'object_type.g.dart';

@JsonSerializable()
class ObjectType {
  int id;
  String name;
  List<int> checkIds;

  ObjectType({this.id = -1, required this.name, required this.checkIds});

  factory ObjectType.fromJson(Map<String, dynamic> json) =>
      _$ObjectTypeFromJson(json);
}
