import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckEditorPage extends StatefulWidget {
  bool get isAdding => check == null;
  final Check? check;

  const CheckEditorPage({super.key, this.check});

  @override
  State<CheckEditorPage> createState() => _CheckEditorPageState();
}

class _CheckEditorPageState extends State<CheckEditorPage> {
  late Check check;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.check == null || widget.isAdding) {
      check = Check();
    } else {
      assert(widget.check != null);
      check = widget.check!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name *',
          ),
          initialValue: check.name,
          onChanged: (value) {
            if (formKey.currentState!.validate()) {
              check.name = value.trim();
            }
          },
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return "* Required";
            }
            return null;
          },
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: TextFormField(
      //     decoration: const InputDecoration(
      //       border: OutlineInputBorder(),
      //       labelText: 'Answer prompt',
      //       hintText: '% {has|have} display issues',
      //       helperText:
      //           "'%' = Objects that match, '{x|y}' = singular/plural text",
      //     ),
      //     initialValue: check.isAnswerPromptEmpty ? "" : check.answerPrompt,
      //     onChanged: (value) {
      //       if (formKey.currentState!.validate()) {
      //         check.answerPrompt = value.trim();
      //         update();
      //       }
      //     },
      //     validator: (value) {
      //       if ((value != null && (value.trim().isNotEmpty)) &&
      //           !check.isAnswerPromptEmpty) {
      //         if (!value.contains('%')) {
      //           return "Add at least one '%' character";
      //         }
      //       }

      //       return null;
      //     },
      //   ),
      // ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Fail options'),
      )
    ].toList(growable: true);

    for (var i = 0; i < check.failOptions.length; i++) {
      listWidgets.add(ListTile(
        title: TextFormField(
          decoration: const InputDecoration(
              hintText: '% {has|that have} some ghosting'),
          initialValue: check.failOptions[i],
          onChanged: (value) {
            check.failOptions[i] = value;
          },
        ),
        trailing: IconButton(
          onPressed: () => setState(() => check.failOptions.removeAt(i)),
          icon: const Icon(Icons.delete),
        ),
      ));
    }

    listWidgets.add(ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Add fail option'),
      onTap: () {
        setState(() {
          check.failOptions.add('');
        });
      },
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                var dm = Provider.of<DataMaster>(context, listen: false);
                if (widget.isAdding) {
                  dm.addObject(check);
                } else {
                  dm.update();
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard changes?'),
                    content: const Text(
                        'Closing will discard changes to this task due to invalid inputs'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Discard'))
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(widget.isAdding ? 'Add check' : 'Edit check'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: listWidgets,
        ),
      ),
    );
  }
}
