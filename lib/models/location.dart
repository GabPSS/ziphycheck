import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/report_answer.dart';
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
    // ra.checkAnswers
    //     .where((element) => checkupObjectIds.contains(element.objectId));
    // return {'total': checkupObjects.length};
    int checkedObjects = 0, issues = 0;
    for (var co in checkupObjects) {
      Map<String, dynamic> checkupObjectInfo = ra.getCheckupObjectInfo(co, dm);
      if (checkupObjectInfo['checked'] as bool) {
        checkedObjects++;
      }
      issues += (checkupObjectInfo['issues'] as int);
    }
    return {
      'total': checkupObjects.length,
      'checked': checkedObjects,
      'issues': issues
    };
  }
}
