import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/issue_notes.dart';
import 'package:flutter/material.dart';

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
