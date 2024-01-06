import 'package:ziphycheck/models/check.dart';
import 'package:ziphycheck/models/identifiable_object.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'object_type.g.dart';

@JsonSerializable()
class ObjectType extends IdentifiableObject {
  String name;
  List<int> checkIds = List.empty(growable: true);

  ObjectType({
    super.id = -1,
    this.name = "Unnamed Object type",
  });

  factory ObjectType.fromJson(Map<String, dynamic> json) =>
      _$ObjectTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ObjectTypeToJson(this);

  void addCheck(Check check) {
    var id = check.id;
    if (!checkIds.contains(id)) checkIds.add(id);
  }

  void removeCheck(Check check) {
    var id = check.id;
    if (checkIds.contains(id)) checkIds.remove(id);
  }

  bool hasCheck(Check check) => checkIds.contains(check.id);

  IconData getIcon() {
    switch (name) {
      case "PC":
        return Icons.computer;
      case "Phone":
        return Icons.smartphone;
      case "TV":
        return Icons.tv;
      default:
        return Icons.token;
    }
  }
}
