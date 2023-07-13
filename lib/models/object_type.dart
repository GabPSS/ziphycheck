import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/task.dart';
import 'package:flutter/material.dart';

class ObjectType {
  late int id;
  String name = "";
  final List<int> _taskIds = List<int>.empty(growable: true);

  DataMaster dm;

  ObjectType({required this.dm}) {
    id = dm.objectTypeKey;
    dm.objectTypeKey++;
    dm.objectTypes.add(this);
  }

  List<Task> getTasks() => dm.tasks.where((element) => _taskIds.contains(element.id)).toList();

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
}
