import 'package:json_annotation/json_annotation.dart';

part 'location_answer.g.dart';

@JsonSerializable()
class LocationAnswer {
  int locationId;
  bool status;
  String? issue;
  String? notes;

  LocationAnswer(
      {required this.locationId, required this.status, this.issue, this.notes});

  factory LocationAnswer.fromJson(Map<String, dynamic> json) =>
      _$LocationAnswerFromJson(json);
  Map<String, dynamic> toJson() => _$LocationAnswerToJson(this);
}
