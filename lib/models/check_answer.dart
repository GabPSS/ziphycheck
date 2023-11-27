import 'package:checkup_app/models/issue.dart';

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
}
