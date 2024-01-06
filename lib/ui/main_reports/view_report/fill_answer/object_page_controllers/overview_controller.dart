import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/check.dart';
import 'package:ziphycheck/models/check_answer.dart';
import 'package:ziphycheck/models/checkup_object.dart';
import 'package:ziphycheck/models/issue.dart';
import 'package:ziphycheck/models/location.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/object_page_controllers/answer_page_controller.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/widgets/check_widget.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/widgets/custom_add_issue_tile.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/widgets/custom_issue_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class OverviewController implements AnswerPageController {
  late int objectIndex;

  @override
  CheckupObject get object => allObjects[objectIndex];

  @override
  set object(CheckupObject value) {
    objectIndex = allObjects.indexOf(value);
  }

  List<CheckupObject> get allObjects => location.checkupObjects;

  @override
  String get objectName => object.getFullName(dm);
  @override
  String getLeadingHeaderText(BuildContext context) =>
      reportAnswer.formatCheckupObjectInfo(
          object, dm, AppLocalizations.of(context)!.objectIndexLabel);
  @override
  String getTrailingHeaderText(BuildContext context) =>
      reportAnswer.formatCheckupObjectInfo(
          object, dm, AppLocalizations.of(context)!.objectInfoLabel);

  final DataMaster dm;
  final ReportAnswer reportAnswer;
  final Location location;

  List<Check> get checks => dm.getChecksForObject(object);
  List<CheckAnswer> get checkAnswers => reportAnswer.getAnswersByObject(object);
  CheckAnswer get genericCheckAnswer => checkAnswers.singleWhere(
        (element) => element.checkId == null,
        orElse: () {
          var checkAnswer = CheckAnswer(checkId: null, objectId: object.id);
          reportAnswer.checkAnswers.add(checkAnswer);
          return checkAnswer;
        },
      );

  List<CheckAnswer> getAnswersThatAre(bool status) =>
      checkAnswers.where((element) => element.status == status).toList();

  @override
  bool? get status {
    if (getAnswersThatAre(false).isNotEmpty) {
      return false;
    }

    if (getAnswersThatAre(true).length == checks.length) {
      return true;
    }
    return forceFalse ? false : null;
  }

  @override
  set status(bool? value) {
    reportAnswer.checkAnswers
        .removeWhere((element) => element.objectId == object.id);

    if (value == true) {
      reportAnswer.markObjectTasksTrue(object, dm);
    } else if (value == false) {
      forceFalse = true;
    } else {
      forceFalse = false;
    }
  }

  bool forceFalse = false;

  @override
  void toggleStatus(bool from) {
    if (status == null || status == !from) {
      status = from;
      return;
    }

    status = null;
    return;
  }

  OverviewController(
      {required this.location,
      required CheckupObject initialObject,
      required this.reportAnswer,
      required this.dm}) {
    object = initialObject;
  }

  @override
  void update() => dm.update();

  List<Check> expandedChecks = List.empty(growable: true);

  @override
  Widget getBody(BuildContext context, Function(Function()) setState) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (status == false)
        for (Check check in checks)
          CheckWidget(
            showHeader: true,
            check: check,
            expanded: expandedChecks.contains(check),
            onTap: () {
              setState(() {
                expandedChecks.contains(check)
                    ? expandedChecks.remove(check)
                    : expandedChecks.add(check);
              });
            },
            checkupObject: object,
            reportAnswer: reportAnswer,
            issues: reportAnswer.getObjectIssues(object),
            onUpdateIssue: (value, name, notes, solved) {
              setState(() {
                var answer =
                    reportAnswer.getOrCreateAnswer(object.id, check.id);
                if (value) {
                  var issue = answer.getOrCreateIssue(name);
                  issue.notes = notes;
                  issue.solved = solved ?? issue.solved;
                } else {
                  answer.removeIssue(name);
                }
                // if (answer.getIssuesForCheck(check).isEmpty) {
                if (answer.issues.isEmpty) {
                  reportAnswer.checkAnswers.remove(answer);
                }
              });
            },
          ),
      if (status == false)
        for (Issue customIssue in genericCheckAnswer.issues)
          if (status == false)
            CustomIssueTile(
              name: customIssue.name,
              solved: customIssue.solved,
              onUpdateIssue: (value, solved) {
                setState(() {
                  customIssue.name = value;
                  customIssue.solved = solved;
                });
              },
              onDeleteIssue: () {
                setState(() {
                  genericCheckAnswer.issues.remove(customIssue);
                });
              },
            ),
      if (status == false)
        CustomAddIssueTile(
          onCreateIssue: (name) {
            setState(() {
              genericCheckAnswer.issues.add(Issue(name: name));
            });
          },
        ),
      if (status == null)
        Builder(builder: (context) {
          String? issues = dm
              .getPreviousAnswer(reportAnswer)
              ?.getObjectIssues(object)
              .map((e) => reportAnswer
                  .formatIssueBody(e.name, false, [object.getFullName(dm)]))
              .join("\n");
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text((issues != null && issues.trim() != ""
                ? "${AppLocalizations.of(context)!.previousIssues}:\n\n$issues"
                : AppLocalizations.of(context)!.noPreviousIssues)),
          );
        })
    ]);
  }

  @override
  void next() {
    objectIndex++;
    if (allObjects.length == objectIndex) {
      objectIndex = 0;
    }
    forceFalse = false;
  }

  @override
  void previous() {
    objectIndex--;
    if (objectIndex < 0) {
      objectIndex = allObjects.length - 1;
    }
    forceFalse = false;
  }

  @override
  Text? getPageTitle() => null;
}
