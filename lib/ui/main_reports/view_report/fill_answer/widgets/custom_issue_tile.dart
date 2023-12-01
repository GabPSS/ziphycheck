import 'package:flutter/material.dart';

class CustomIssueTile extends StatefulWidget {
  final String? name;
  final bool solved;
  // final Function(Issue issue)? onCreateIssue;
  final Function(String value, bool solved)? onUpdateIssue;
  final Function()? onDeleteIssue;

  const CustomIssueTile(
      {super.key,
      // this.onCreateIssue,
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
  // late bool created = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    name = widget.name ?? '';
    solved = widget.solved;
    // created = widget.name != null;
    textEditingController = TextEditingController(text: name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    name = widget.name ?? '';
    textEditingController.text = name;
    return ListTile(
        title: TextFormField(
          decoration: const InputDecoration(hintText: 'Other issue'),
          controller: textEditingController,
          onChanged: (value) {
            if (value.trim() == "") {
              widget.onDeleteIssue?.call();
              // created = false;
              setState(() {});
              return;
            }
            name = value;
            widget.onUpdateIssue?.call(name, solved);
          },
        ),
        trailing: //created
            Checkbox(
          value: solved,
          onChanged: (value) {
            solved = value ?? false;
            widget.onUpdateIssue?.call(name, solved);
          },
        ));
  }
}
