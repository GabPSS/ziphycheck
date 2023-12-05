import 'package:checkup_app/models/check.dart';
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

  Issue getOrCreateIssue(String name) {
    return issues.singleWhere(
      (element) => element.name == name,
      orElse: () {
        removeIssue(name);
        Issue issue = Issue(name: name);
        issues.add(issue);
        return issue;
      },
    );
  }

  void removeIssue(String name) =>
      issues.removeWhere((element) => element.name == name);

  List<Issue> filterIssues(String name) =>
      issues.where((element) => element.name == name).toList();

  List<Issue> getCustomIssues(Check check) => issues
      .where((element) => !check.failOptions.contains(element.name))
      .toList();

  List<String> get issueNames => issues.map((e) => e.name).toList();
}
