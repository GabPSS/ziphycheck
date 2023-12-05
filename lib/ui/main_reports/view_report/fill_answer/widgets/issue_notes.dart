import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.issueNotesFieldLabel),
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
