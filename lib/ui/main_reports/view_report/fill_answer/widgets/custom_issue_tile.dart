import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class CustomIssueTile extends StatefulWidget {
  final String? name;
  final bool solved;
  final Function(String value, bool solved)? onUpdateIssue;
  final Function()? onDeleteIssue;

  const CustomIssueTile(
      {super.key,
      this.onDeleteIssue,
      required this.name,
      this.solved = false,
      this.onUpdateIssue});

  @override
  State<CustomIssueTile> createState() => _CustomIssueTileState();
}

class _CustomIssueTileState extends State<CustomIssueTile> {
  late String name;
  late bool solved;
  late TextEditingController textEditingController;

  @override
  void initState() {
    name = widget.name ?? '';
    solved = widget.solved;
    textEditingController = TextEditingController(text: name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    name = widget.name ?? '';
    textEditingController.text = name;
    return ListTile(
        title: TextFormField(
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.customIssueFieldLabel),
          controller: textEditingController,
          onChanged: (value) {
            if (value.trim() == "") {
              widget.onDeleteIssue?.call();
              setState(() {});
              return;
            }
            name = value;
            widget.onUpdateIssue?.call(name, solved);
          },
        ),
        trailing: Checkbox(
          value: solved,
          onChanged: (value) {
            solved = value ?? false;
            widget.onUpdateIssue?.call(name, solved);
          },
        ));
  }
}
