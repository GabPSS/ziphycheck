import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/task.dart';
import 'package:flutter/material.dart';

class TasksEditorPage extends StatefulWidget {
  final DataMaster dm;
  final bool isAdding;
  final Task? task;
  final Function()? onUpdate;

  const TasksEditorPage({super.key, required this.dm, this.isAdding = false, this.task, this.onUpdate});

  @override
  State<TasksEditorPage> createState() => _TasksEditorPageState();
}

class _TasksEditorPageState extends State<TasksEditorPage> {
  late Task task;
  bool isAdding = false;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.task == null || widget.isAdding) {
      isAdding = true;
      task = Task(dm: widget.dm);
    } else {
      assert(widget.task != null);
      task = widget.task!;
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
            border: OutlineInputBorder(),
            labelText: 'Name *',
          ),
          initialValue: task.name,
          onChanged: (value) {
            if (formKey.currentState!.validate()) {
              task.name = value.trim();
              update();
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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Answer prompt',
            hintText: '% {has|have} display issues',
            helperText: "'%' = Objects that match, '{x|y}' = singular/plural text",
          ),
          initialValue: task.isAnswerPromptEmpty ? "" : task.answerPrompt,
          onChanged: (value) {
            if (formKey.currentState!.validate()) {
              task.answerPrompt = value.trim();
              update();
            }
          },
          validator: (value) {
            if ((value != null && (value.trim().isNotEmpty)) && !task.isAnswerPromptEmpty) {
              if (!value.contains('%')) {
                return "Add at least one '%' character";
              }
            }

            return null;
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Fail options'),
      )
    ].toList(growable: true);

    for (var i = 0; i < task.defaultFailOptions.length; i++) {
      listWidgets.add(ListTile(
        leading: Icon(null),
        title: TextFormField(
          decoration: InputDecoration(hintText: '% {has|that have} some ghosting'),
          initialValue: task.defaultFailOptions[i],
          onChanged: (value) {
            task.defaultFailOptions[i] = value;
          },
        ),
        trailing: IconButton(
          onPressed: () => setState(() => task.defaultFailOptions.removeAt(i)),
          icon: Icon(Icons.delete),
        ),
      ));
    }

    // listWidgets.addAll(task.defaultFailOptions.map(

    listWidgets.add(ListTile(
      leading: Icon(Icons.add),
      title: Text('Add fail option'),
      onTap: () {
        setState(() {
          task.defaultFailOptions.add('');
        });
      },
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard changes?'),
                    content: const Text('Closing will discard changes to this task due to invalid inputs'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (isAdding) {
                              widget.dm.tasks.remove(task);
                            }
                          },
                          child: const Text('Discard'))
                    ],
                  ),
                );
              }
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(isAdding ? 'Add task' : 'Edit task'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: listWidgets,
        ),
      ),
    );
  }

  void update() {
    if (widget.onUpdate != null) widget.onUpdate!();
  }
}
