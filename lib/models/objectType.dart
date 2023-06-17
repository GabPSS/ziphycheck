import 'package:checkup_app/data/dataMaster.dart';
import 'package:checkup_app/models/task.dart';

class ObjectType {
  late int id;
  String name = "";
  List<int> _taskIds = List<int>.empty(growable: true);

  ObjectType({required DataMaster dm}) {
    id = dm.objectTypeKey;
    dm.objectTypeKey++;
  }

  List<Task> getTasks() {
    throw UnimplementedError();
    //TODO: Implement this later
  }
}