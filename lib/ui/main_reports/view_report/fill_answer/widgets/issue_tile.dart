import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/issue_notes.dart';
import 'package:flutter/material.dart';

enum IssueTileStyle { selection, preview }

class IssueTile extends StatelessWidget {
  const IssueTile({
    super.key,
    required this.value,
    required this.issueName,
    required this.onUpdateIssue,
    this.style = IssueTileStyle.selection,
    this.solved,
    this.notes,
    this.onDelete,
  });

  final bool value;
  final bool? solved;
  final String issueName;
  final String? notes;
  final IssueTileStyle style;
  final Function(bool exists, String name, String? notes, bool? solved)?
      onUpdateIssue;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: getLeading(),
          title: Text(issueName),
          //TODO: Change to formatted text once that's been implemented
          onTap: style == IssueTileStyle.selection
              ? () {
                  onUpdateIssue?.call(!value, issueName, notes, solved);
                }
              : null,
          trailing: style == IssueTileStyle.preview
              ? Checkbox(
                  value: solved ?? false,
                  onChanged: (solved) {
                    onUpdateIssue?.call(value, issueName, notes, solved);
                  },
                )
              : null,
        ),
        if (value && style == IssueTileStyle.selection)
          IssueNotes(
              notes: notes,
              onUpdateIssue: onUpdateIssue,
              value: value,
              issueName: issueName,
              solved: solved),
      ],
    );
  }

  Widget getLeading() {
    switch (style) {
      case IssueTileStyle.selection:
        return Checkbox(
          value: value,
          onChanged: (newValue) {
            onUpdateIssue?.call(newValue ?? false, issueName, notes, solved);
          },
        );

      case IssueTileStyle.preview:
        return IconButton(
            onPressed: () {
              onDelete?.call();
            },
            icon: Icon(Icons.delete));
      default:
        throw UnimplementedError();
    }
  }
}
