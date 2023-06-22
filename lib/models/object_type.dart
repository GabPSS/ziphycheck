import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/task.dart';
import 'package:flutter/material.dart';

class ObjectType {
  late int id;
  String name = "";
  List<int> _taskIds = List<int>.empty(growable: true);

  DataMaster dm;

  ObjectType({required this.dm}) {
    id = dm.objectTypeKey;
    dm.objectTypeKey++;
  }

  List<Task> getTasks() => dm.tasks.where((element) => _taskIds.contains(element.id)).toList();

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
