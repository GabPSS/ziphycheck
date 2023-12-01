import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/check_widget.dart';
import 'widgets/custom_add_issue_tile.dart';
import 'widgets/custom_issue_tile.dart';
import 'widgets/answer_button.dart';

class FillCheckAnswerOverviewPage extends StatefulWidget {
  final ReportAnswer reportAnswer;
  final CheckupObject initialObject;

  const FillCheckAnswerOverviewPage({
    super.key,
    required this.reportAnswer,
    required this.initialObject,
  });

  @override
  State<FillCheckAnswerOverviewPage> createState() =>
      _FillCheckAnswerOverviewPageState();
}

class _FillCheckAnswerOverviewPageState
    extends State<FillCheckAnswerOverviewPage> {
  late CheckupObject object;
  late DataMaster dm;
  bool forceFalse = false;

  List<Check> get checks => dm.getChecksForObject(object);
  List<CheckAnswer> get checkAnswers =>
      widget.reportAnswer.getAnswersByObject(object);
  CheckAnswer get genericCheckAnswer => checkAnswers.singleWhere(
        (element) => element.checkId == null,
        orElse: () {
          var checkAnswer = CheckAnswer(checkId: null, objectId: object.id);
          widget.reportAnswer.checkAnswers.add(checkAnswer);
          return checkAnswer;
        },
      );

  List<CheckAnswer> getAnswersThatAre(bool status) =>
      checkAnswers.where((element) => element.status == status).toList();

  bool? get status {
    if (getAnswersThatAre(false).isNotEmpty) {
      return false;
    }

    if (getAnswersThatAre(true).length == checks.length) {
      return true;
    }
    return forceFalse ? false : null;
  }

  set status(bool? value) {
    widget.reportAnswer.checkAnswers
        .removeWhere((element) => element.objectId == object.id);

    if (value == true) {
      widget.reportAnswer.markObjectTasksTrue(object, dm);
    } else if (value == false) {
      forceFalse = true;
    } else {
      forceFalse = false;
    }
  }

  void toggleStatus(bool from) {
    setState(() {
      if (status == null || status == !from) {
        status = from;
        return;
      }

      status = null;
      return;
    });
  }

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    object = widget.initialObject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              dm.update();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              getHeader(),
              getContent(),
            ],
          )),
          if (MediaQuery.of(context).viewInsets.bottom < 50) getAnswerButtons(),
        ],
      ),
    );
  }

  Column getAnswerButtons() {
    return Column(
      children: [
        Row(
          children: [
            AnswerButton(
              label: const Text('NO'),
              icon: const Icon(Icons.close),
              onPressed: () => toggleStatus(false),
              backgroundColor: const Color.fromARGB(255, 242, 145, 145),
              checked: !(status ?? true),
            ),
            AnswerButton(
                label: const Text('YES TO ALL'),
                icon: const Icon(Icons.done_all),
                onPressed: () => toggleStatus(true),
                backgroundColor: const Color.fromARGB(255, 169, 219, 151),
                checked: status ?? false),
          ],
        ),
        Row(
          children: [
            AnswerButton(
              label: const Text('PREVIOUS'),
              icon: const Icon(Icons.navigate_before),
              onPressed: () {},
            ),
            AnswerButton(
              label: const Text('NEXT'),
              icon: const Icon(Icons.navigate_next),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      children: [
        Expanded(
            child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(widget.reportAnswer
                    .formatCheckupObjectInfo(object, dm, "Object %ID/%OB")),
              ), //TODO: Update this please
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  object.getFullName(dm),
                  textScaleFactor: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(widget.reportAnswer.formatCheckupObjectInfo(
                    object, dm, "%AW/%TT check%sTT, %IS issue%sIS")),

                //TODO: #18 Add option to see yesterday's answers right from here
              ),
            ],
          ),
        )),
      ],
    );
  }

  List<Check> expandedChecks = List.empty(growable: true);

  Widget getContent() {
    //TODO: #19 Finish implementing content
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
            issues: widget.reportAnswer.getObjectIssues(object),
            onUpdateIssue: (value, name, notes, solved) {
              setState(() {
                var answer =
                    widget.reportAnswer.getOrCreateAnswer(object.id, check.id);
                if (value) {
                  var issue = answer.getOrCreateIssue(name);
                  issue.notes = notes;
                  issue.solved = solved ?? issue.solved;
                } else {
                  answer.removeIssue(name);
                }
                if (answer.getIssuesForCheck(check).isEmpty) {
                  widget.reportAnswer.checkAnswers.remove(answer);
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
        const Text(
            "Yesterday's issues\n- bla bla bla\n- bla bla bla\n- bla bla bla\n- bla bla bla") //TODO: #18 Change this onto a retrieval of the previous issues
    ]);
  }
}
