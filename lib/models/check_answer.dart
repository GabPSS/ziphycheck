import 'package:checkup_app/models/issue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_answer.g.dart';

@JsonSerializable()
class CheckAnswer {
  int? checkId;
  int objectId;
  bool status = false;
  List<Issue> issues = List.empty(growable: true);
  String? photoReference;

  CheckAnswer(
      {required this.checkId,
      required this.objectId,
      this.status = false,
      this.photoReference});

  factory CheckAnswer.fromJson(Map<String, dynamic> json) =>
      _$CheckAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$CheckAnswerToJson(this);
}
