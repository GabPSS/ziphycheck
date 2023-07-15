import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/ui/main_tasks/tasks_editor_page.dart';
import 'package:flutter/material.dart';

class MainTasksPage extends StatefulWidget {
  final DataMaster dm;

  const MainTasksPage({super.key, required this.dm});

  @override
  State<MainTasksPage> createState() => _MainTasksPageState();
}

class _MainTasksPageState extends State<MainTasksPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var task = widget.dm.tasks[index];
        return Card(
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TasksEditorPage(
                    dm: widget.dm,
                    task: task,
                    onUpdate: () => setState(() {}),
                  ),
                )),
            child: ListTile(
              leading: const Icon(Icons.check_box),
              title: Text(task.name),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TasksEditorPage(
                              dm: widget.dm,
                              task: task,
                              onUpdate: () => setState(() {}),
                            ),
                          ));
                      break;
                    case 1:
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete \'${task.name}\'?'),
                          content: const Text("You won't be able to recover this task once it's gone"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    widget.dm.tasks.remove(task);
                                  });
                                },
                                child: const Text('Delete'))
                          ],
                        ),
                      );
                    default:
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                      value: 0,
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      )),
                  const PopupMenuItem(
                      value: 1,
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ))
                ],
              ),
            ),
          ),
        );
      },
      itemCount: widget.dm.tasks.length,
    );
  }
}
