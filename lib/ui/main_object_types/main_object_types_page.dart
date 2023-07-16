import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:flutter/material.dart';

class MainObjectTypesPage extends StatefulWidget {
  final DataMaster dm;

  const MainObjectTypesPage({super.key, required this.dm});

  @override
  State<MainObjectTypesPage> createState() => _MainObjectTypesPageState();
}

class _MainObjectTypesPageState extends State<MainObjectTypesPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.dm.objectTypes.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          var objectType = widget.dm.objectTypes[index];
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ObjectTypeEditorPage(
                        dm: widget.dm,
                        objectType: objectType,
                        onUpdate: () => setState(() {}),
                      ),
                    ));
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(objectType.getIcon()),
                ),
                title: Text(objectType.name),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ObjectTypeEditorPage(
                                      dm: widget.dm,
                                      objectType: objectType,
                                      onUpdate: () => setState(() {}),
                                    )));
                        break;
                      case 1:
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete \'${objectType.name}\'?'),
                            content: const Text("You won't be able to recover this object type once it's gone"),
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
                                    setState(() => widget.dm.objectTypes.remove(objectType));
                                  },
                                  child: const Text('Delete'))
                            ],
                          ),
                        );
                        break;
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
        itemCount: widget.dm.objectTypes.length,
      );
    }

    return const Center(
      child: Text('There are no object types. Tap + to add a new object type'),
    );
  }
}
