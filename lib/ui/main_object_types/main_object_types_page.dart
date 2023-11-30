import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainObjectTypesPage extends StatefulWidget {
  const MainObjectTypesPage({super.key});

  @override
  State<MainObjectTypesPage> createState() => _MainObjectTypesPageState();
}

class _MainObjectTypesPageState extends State<MainObjectTypesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataMaster>(
      builder: (context, dm, child) {
        if (dm.objectTypes.isNotEmpty) {
          return ListView.builder(
            itemBuilder: (context, index) {
              var objectType = dm.objectTypes[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObjectTypeEditorPage(
                            objectType: objectType,
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
                                          objectType: objectType,
                                        )));
                            break;
                          case 1:
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete \'${objectType.name}\'?'),
                                content: const Text(
                                    "You won't be able to recover this object type once it's gone"),
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
                                          dm.removeObject(objectType);
                                        });
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
            itemCount: dm.objectTypes.length,
          );
        }

        return const Center(
          child:
              Text('There are no object types. Tap + to add a new object type'),
        );
      },
    );
  }
}
