import 'package:flutter/material.dart';

class CustomAddIssueTile extends StatefulWidget {
  const CustomAddIssueTile({super.key, required this.onCreateIssue});
  final Function(String name) onCreateIssue;

  @override
  State<CustomAddIssueTile> createState() => _CustomAddIssueTileState();
}

class _CustomAddIssueTileState extends State<CustomAddIssueTile> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController =
        TextEditingController.fromValue(TextEditingValue.empty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: textEditingController,
        decoration: const InputDecoration(hintText: 'Other issue'),
        onSubmitted: (value) {
          widget.onCreateIssue(value);
          textEditingController.text = "";
        },
      ),
    );
  }
}
