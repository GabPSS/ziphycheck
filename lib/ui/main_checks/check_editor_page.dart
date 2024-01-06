import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/check.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: '${AppLocalizations.of(context)!.nameFieldLabel} *',
          ),
          initialValue: check.name,
          onChanged: (value) {
            if (formKey.currentState!.validate()) {
              check.name = value.trim();
            }
          },
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return "* ${AppLocalizations.of(context)!.requiredIndicatorLabel}";
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(AppLocalizations.of(context)!.failOptionsSectionLabel),
      )
    ].toList(growable: true);

    for (var i = 0; i < check.failOptions.length; i++) {
      listWidgets.add(ListTile(
        title: TextFormField(
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.failOptionExampleHint),
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
      title: Text(AppLocalizations.of(context)!.addFailOptionButtonLabel),
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
                    title: Text(
                        AppLocalizations.of(context)!.discardTaskDialogTitle),
                    content: Text(AppLocalizations.of(context)!
                        .discardTaskDialogContents),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.cancelButtonLabel)),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                              AppLocalizations.of(context)!.discardButtonLabel))
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(widget.isAdding
            ? AppLocalizations.of(context)!.addCheckWindowTitle
            : AppLocalizations.of(context)!.editCheckWindowTitle),
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
