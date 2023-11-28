import 'package:checkup_app/models/identifiable_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report extends IdentifiableObject {
  String name;
  List<Location> locations = List.empty(growable: true);

  int checkupObjectKey = 0;
  int locationKey = 0;

  Report({super.id = -1, required this.name});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);

  getCheckupObjectById(int id) {}
}
