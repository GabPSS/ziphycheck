import 'package:json_annotation/json_annotation.dart';

part 'issue.g.dart';

@JsonSerializable()
class Issue {
  String name;
  String? notes;
  bool solved = false;

  Issue({required this.name, this.notes, this.solved = false});

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
  Map<String, dynamic> toJson() => _$IssueToJson(this);
}
