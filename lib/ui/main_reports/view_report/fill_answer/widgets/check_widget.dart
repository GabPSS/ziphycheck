import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/issue.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/issue_tile.dart';
import 'package:flutter/material.dart';

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
