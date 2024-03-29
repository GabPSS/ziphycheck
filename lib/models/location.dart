import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/check.dart';
import 'package:ziphycheck/models/checkup_object.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  int id;
  String name;
  List<CheckupObject> checkupObjects = List.empty(growable: true);

  List<int> get checkupObjectIds => checkupObjects.map((e) => e.id).toList();

  Location({this.id = -1, this.name = "Unnamed location"});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  Map<String, int> getInfo(ReportAnswer ra, DataMaster dm) {
    int checkedObjects = 0, issues = 0;
    for (var co in checkupObjects) {
      Map<String, dynamic> checkupObjectInfo = ra.getCheckupObjectInfo(co, dm);
      var checkedBool = checkupObjectInfo['checked'] ?? false;
      if (checkedBool != null && checkedBool as bool) {
        checkedObjects++;
      }
      issues += (checkupObjectInfo['issues'] ?? 0) as int;
    }
    return {
      'total': checkupObjects.length,
      'checked': checkedObjects,
      'issues': issues
    };
  }

  CheckupObject? getCheckupObjectById(int id) =>
      checkupObjects.where((element) => element.id == id).singleOrNull;

  List<CheckupObject> getObjectsByCheck(Check? check, DataMaster dm) {
    return checkupObjects.where((object) {
      var objectType = object.getObjectType(dm);
      if (objectType == null && check == null) return true;
      if (objectType?.checkIds.contains(check?.id) ?? false) return true;
      return false;
    }).toList();
  }
}
