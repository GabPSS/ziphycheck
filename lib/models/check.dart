import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check {
  int id;
  String name;
  List<String> failOptions;

  Check({this.id = -1, required this.name, required this.failOptions});

  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
}
