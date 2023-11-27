import 'package:checkup_app/models/location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  int id;
  String name;
  List<Location> locations;

  int checkupObjectKey = 0;
  int locationKey = 0;

  Report({this.id = -1, required this.name, required this.locations});

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
