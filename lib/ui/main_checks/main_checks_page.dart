import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/ui/main_checks/check_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainChecksPage extends StatefulWidget {
  const MainChecksPage({super.key});

  @override
  State<MainChecksPage> createState() => _MainChecksPageState();
}

class _MainChecksPageState extends State<MainChecksPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataMaster>(builder: (context, dm, child) {
      return ListView.builder(
        itemBuilder: (context, index) {
          var check = dm.checks[index];
          return Card(
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckEditorPage(
                      check: check,
                    ),
                  )),
              child: ListTile(
                leading: const Icon(Icons.check_box),
                title: Text(check.name),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckEditorPage(
                                check: check,
                              ),
                            ));
                        break;
                      case 1:
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete \'${check.name}\'?'),
                            content: const Text(
                                "You won't be able to recover this task once it's gone"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    dm.removeObject(check);
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
        itemCount: dm.checks.length,
      );
    });
  }
}
