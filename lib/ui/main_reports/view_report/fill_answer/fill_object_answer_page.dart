import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FillObjectAnswerpage extends StatefulWidget {
  final ReportAnswer reportAnswer;
  final CheckupObject initialObject;
  final AnswerPageType type;

  const FillObjectAnswerpage(
      {super.key,
      required this.reportAnswer,
      required this.initialObject,
      this.type = AnswerPageType.singleObjectOverview});

  @override
  State<FillObjectAnswerpage> createState() => _FillObjectAnswerpageState();
}

enum AnswerPageType { singleObjectOverview, detailsView }

class _FillObjectAnswerpageState extends State<FillObjectAnswerpage> {
  late CheckupObject object;
  late DataMaster dm;

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

  bool forceFalse = false;

  bool? get status {
    //TODO: Handle status differently when changing to detailsview
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
                label: Text(switch (widget.type) {
                  AnswerPageType.detailsView => 'YES',
                  AnswerPageType.singleObjectOverview => 'YES TO ALL',
                }),
                icon: Icon(switch (widget.type) {
                  AnswerPageType.detailsView => Icons.done,
                  AnswerPageType.singleObjectOverview => Icons.done_all,
                }),
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

                //TODO: Add option to see yesterday's answers right from here
              ),
            ],
          ),
        )),
      ],
    );
  }

  List<Check> expandedChecks = List.empty(growable: true);

  Widget getContent() {
    //TODO: Finish implementing content
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
              issue: customIssue,
              onDeleteIssue: () =>
                  setState(() => genericCheckAnswer.issues.remove(customIssue)),
            ),
      if (status == false)
        CustomIssueTile(
          onCreateIssue: (issue) =>
              setState(() => genericCheckAnswer.issues.add(issue)),
        ),
      if (status == null)
        const Text(
            "Yesterday's issues\n- bla bla bla\n- bla bla bla\n- bla bla bla\n- bla bla bla") //TODO: Change this onto a retrieval of the previous issues
    ]);
  }
}

class CheckWidget extends StatelessWidget {
  final Check check;
  final bool showHeader;
  final bool expanded;
  final Function()? onTap;
  final List<Issue> issues;
  final Function(bool exists, String name, String? notes, bool? solved)?
      onUpdateIssue;

  const CheckWidget({
    super.key,
    required this.check,
    this.expanded = false,
    this.onTap,
    required this.issues,
    this.onUpdateIssue,
    this.showHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showHeader)
          ListTile(
            onTap: onTap,
            leading: expanded
                ? const Icon(Icons.keyboard_arrow_down)
                : const Icon(Icons.keyboard_arrow_right),
            title: Text(check.name),
          ),
        if (expanded)
          for (String option in check.failOptions)
            Builder(builder: (context) {
              Issue? issue = getIssue(option);
              return IssueTile(
                value: issues.map((e) => e.name).contains(option),
                issueName: option,
                solved: issue?.solved ?? false,
                onUpdateIssue: onUpdateIssue,
                notes: issue?.notes,
              );
            })
      ],
    );
  }

  Issue? getIssue(String name) =>
      issues.where((element) => element.name == name).singleOrNull;
}

class IssueTile extends StatelessWidget {
  const IssueTile({
    super.key,
    required this.value,
    required this.issueName,
    required this.onUpdateIssue,
    this.solved,
    this.notes,
  });

  final bool value;
  final bool? solved;
  final String issueName;
  final String? notes;
  final Function(bool exists, String name, String? notes, bool? solved)?
      onUpdateIssue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            value: value,
            onChanged: (newValue) {
              onUpdateIssue?.call(newValue ?? false, issueName, notes, solved);
            },
          ),
          title: Text(issueName),
          //TODO: Change to formatted text once that's been implemented
          onTap: () {
            onUpdateIssue?.call(!value, issueName, notes, solved);
          },
        ),
        if (value)
          IssueNotes(
              notes: notes,
              onUpdateIssue: onUpdateIssue,
              value: value,
              issueName: issueName,
              solved: solved),
      ],
    );
  }
}

class CustomIssueTile extends StatefulWidget {
  final Issue? issue;
  final Function(Issue issue)? onCreateIssue;
  final Function()? onDeleteIssue;

  const CustomIssueTile(
      {super.key, this.issue, this.onCreateIssue, this.onDeleteIssue});

  @override
  State<CustomIssueTile> createState() => _CustomIssueTileState();
}

class _CustomIssueTileState extends State<CustomIssueTile> {
  late Issue issue;

  @override
  void initState() {
    issue = widget.issue ?? Issue(name: '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        decoration: const InputDecoration(hintText: 'Custom issue'),
        initialValue: issue.name,
        onChanged: (value) {
          setState(() {
            issue.name = value;
          });
        },
        onEditingComplete: () {
          if (issue.name.trim() == "") {
            widget.onDeleteIssue?.call();
            return;
          }
          if (widget.issue == null) {
            widget.onCreateIssue?.call(issue);
            return;
          }
          //TODO: Close the keyboard after this
        },
      ),
      trailing: issue.name.trim() != ""
          ? Checkbox(
              value: issue.solved,
              onChanged: (value) {
                setState(() {
                  issue.solved = value ?? false;
                });
              },
            )
          : null,
    );
  }
}

class IssueNotes extends StatelessWidget {
  const IssueNotes({
    super.key,
    required this.notes,
    required this.onUpdateIssue,
    required this.value,
    required this.issueName,
    required this.solved,
  });

  final String? notes;
  final Function(bool exists, String name, String? notes, bool? solved)?
      onUpdateIssue;
  final bool value;
  final String issueName;
  final bool? solved;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextFormField(
        initialValue: notes,
        decoration: const InputDecoration(labelText: 'Notes'),
        onChanged: (newNotes) {
          String? trim = newNotes.trim();
          trim = trim.isEmpty ? null : trim;
          onUpdateIssue?.call(value, issueName, trim, solved);
        },
      ),
      trailing: Checkbox(
        value: solved ?? false,
        onChanged: (newSolved) =>
            onUpdateIssue?.call(value, issueName, notes, newSolved),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final Widget label;
  final Widget icon;
  final Function() onPressed;
  final bool checked;
  final Color? backgroundColor;

  const AnswerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: ButtonStyle(
          iconSize: const MaterialStatePropertyAll(48),
          shape: const MaterialStatePropertyAll(LinearBorder()),
          fixedSize: const MaterialStatePropertyAll(Size(0, 120)),
          backgroundColor:
              checked ? MaterialStatePropertyAll(backgroundColor) : null,
        ),
      ),
    );
  }
}
