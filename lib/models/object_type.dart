import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/task.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'object_type.g.dart';

@JsonSerializable()
class ObjectType {
  late int id;
  String name = "";
  final List<int> _taskIds = List<int>.empty(growable: true);

  @JsonKey(includeFromJson: false, includeToJson: false)
  String _pluralName = "";

  String get pluralName => _pluralName == "" ? name : _pluralName;
  set pluralName(String value) => _pluralName = value;

  String getName(bool plural) => plural ? pluralName : name;

  ObjectType({DataMaster? dm}) {
    if (dm != null) {
      id = dm.objectTypeKey;
      dm.objectTypeKey++;
      dm.objectTypes.add(this);
    }
  }

  List<Task> getTasks(DataMaster dm) => dm.tasks.where((element) => _taskIds.contains(element.id)).toList();

  void addTask(Task task) {
    var id = task.id;
    if (!_taskIds.contains(id)) _taskIds.add(id);
  }

  void removeTask(Task task) {
    var id = task.id;
    if (_taskIds.contains(id)) _taskIds.remove(id);
  }

  bool hasTask(Task task) => _taskIds.contains(task.id);

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

  factory ObjectType.fromJson(Map<String, dynamic> json) => _$ObjectTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectTypeToJson(this);
}
