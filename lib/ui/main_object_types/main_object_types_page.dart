import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
                                title: Text(AppLocalizations.of(context)!
                                    .deleteReportDialogTitle(objectType.name)),
                                content: Text(AppLocalizations.of(context)!
                                    .deleteObjectTypeDialogContents),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .cancelButtonLabel)),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          dm.removeObject(objectType);
                                        });
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .deleteButtonLabel))
                                ],
                              ),
                            );
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 0,
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text(AppLocalizations.of(context)!
                                  .editButtonLabel),
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text(AppLocalizations.of(context)!
                                  .deleteButtonLabel),
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

        return Center(
          child: Text(AppLocalizations.of(context)!.noObjectTypesLabel),
        );
      },
    );
  }
}
