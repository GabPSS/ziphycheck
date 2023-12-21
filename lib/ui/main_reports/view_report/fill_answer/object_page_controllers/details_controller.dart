import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/object_page_controllers/answer_page_controller.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/check_widget.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/custom_add_issue_tile.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/custom_issue_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DetailsController implements AnswerPageController {
  late int objectIndex;

  @override
  CheckupObject get object => matchingObjects[objectIndex];

  @override
  set object(CheckupObject value) {
    objectIndex = matchingObjects.indexOf(value);
  }

  late int checkIndex;

  Check get check => checksForLocation[checkIndex];

  set check(Check value) {
    checkIndex = checksForLocation.indexOf(value);
  }

  List<Check> get checksForLocation => dm.getChecksForLocation(location);

  CheckAnswer? get currentCheckAnswer {
    return reportAnswer.getCheckAnswer(object.id, check.id);
  }

  @override
  bool? get status => currentCheckAnswer?.status;

  @override
  set status(bool? value) {
    if (value == null) {
      reportAnswer.checkAnswers.remove(currentCheckAnswer);
      return;
    }

    reportAnswer.getOrCreateAnswer(object.id, check.id).status = value;
  }

  final ReportAnswer reportAnswer;
  final DataMaster dm;
  final Location location;

  List<CheckupObject> get matchingObjects =>
      location.getObjectsByCheck(check, dm);

  DetailsController(
      {required this.dm,
      required this.location,
      required this.reportAnswer,
      required Check initialCheck}) {
    check = initialCheck;
    object = matchingObjects.first;
  }

  @override
  Widget getBody(BuildContext context, Function(Function() p1) setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          }),
        if (status == false)
          CheckWidget(
            onUpdateIssue: (exists, name, notes, solved) {
              Issue? issue = currentCheckAnswer?.getOrCreateIssue(name);
              if (issue == null) return;
              setState(() {
                if (!exists) return currentCheckAnswer?.removeIssue(name);

                issue.notes = notes;
                issue.solved = solved ?? false;
              });
            },
            checkupObject: object,
            reportAnswer: reportAnswer,
            check: check,
            issues: currentCheckAnswer?.issues ?? [],
            expanded: true,
          ),
        if (status == false)
          for (Issue issue in currentCheckAnswer?.getCustomIssues(check) ?? [])
            CustomIssueTile(
              name: issue.name,
              onDeleteIssue: () {
                setState(() {
                  currentCheckAnswer?.removeIssue(issue.name);
                });
              },
              onUpdateIssue: (value, solved) {
                setState(() {
                  issue.name = value;
                  issue.solved = solved;
                });
              },
            ),
        if (status == false)
          CustomAddIssueTile(
            onCreateIssue: (name) =>
                setState(() => currentCheckAnswer?.getOrCreateIssue(name)),
          )
      ],
    );
  }

  @override
  String getLeadingHeaderText(BuildContext context) =>
      reportAnswer.formatCheckupObjectInfo(
          object, dm, AppLocalizations.of(context)!.objectIndexLabel, check) +
      AppLocalizations.of(context)!
          .objectCheckInfoSuffix(checkIndex + 1, checksForLocation.length);

  @override
  String getTrailingHeaderText(BuildContext context) =>
      reportAnswer.formatCheckupObjectInfo(
          object, dm, AppLocalizations.of(context)!.objectInfoLabel, check);

  @override
  String get objectName => object.getFullName(dm);

  @override
  void toggleStatus(bool from) {
    if (status == null || status == !from) {
      status = from;
      if (status == true) next();
      return;
    }

    status = null;
    return;
  }

  @override
  void update() => dm.update();

  @override
  void next() {
    objectIndex++;
    if (matchingObjects.length == objectIndex) {
      checkIndex++;
      if (checksForLocation.length == checkIndex) {
        checkIndex = 0;
      }
      objectIndex = 0;
    }
  }

  @override
  void previous() {
    objectIndex--;
    if (objectIndex < 0) {
      checkIndex--;
      if (checkIndex < 0) {
        checkIndex = checksForLocation.length - 1;
      }
      objectIndex = matchingObjects.length - 1;
    }
  }

  @override
  Text? getPageTitle() => Text(check.name);
}
