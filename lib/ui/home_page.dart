import 'dart:convert';
import 'dart:typed_data';

import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:checkup_app/ui/main_object_types/main_object_types_page.dart';
import 'package:checkup_app/ui/main_reports/main_reports_page.dart';
import 'package:checkup_app/ui/main_tasks/main_tasks_page.dart';
import 'package:checkup_app/ui/main_tasks/tasks_editor_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:share_plus/share_plus.dart';

import '../data/data_master.dart';
import '../models/report.dart';
import 'main_reports/add_report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocalStorage storage = LocalStorage('userdata');
  Widget? page;
  int pageIndex = 0;
  Function()? fabFunction;
  String title = "";
  DataMaster dm = DataMaster();

  _HomePageState() {
    setPage(index: 0);
  }

  Future<DataMaster?> getData() async {
    if (await storage.ready) {
      String? item = storage.getItem('data');
      if (item != null) {
        var dataMaster = DataMaster.fromJson(jsonDecode(item));
        dataMaster.saveFunction = save;
        return dataMaster;
      }
    }
    return null;
  }

  void setPage({int? index}) {
    if (index != null) {
      pageIndex = index;
    }
    switch (pageIndex) {
      case 0:
        page = MainReportsPage(dm: dm);
        fabFunction = mainReportsFabTapped;
        title = "Reports";
        break;
      case 1:
        page = MainObjectTypesPage(
          dm: dm,
        );
        fabFunction = mainObjectTypesFabTapped;
        title = "Object Types";
        break;
      case 2:
        page = MainTasksPage(dm: dm);
        fabFunction = mainTasksFabTapped;
        title = "Tasks";
      default:
        throw Error();
    }
  }

  void save() {
    try {
      storage.setItem('data', jsonEncode(dm.toJson()));
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    setPage();
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: fabFunction, child: const Icon(Icons.add)),
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(onPressed: () => save(), icon: const Icon(Icons.save)),
          IconButton(
              onPressed: () async {
                var newDm = await getData();
                if (newDm != null) {
                  setState(() {
                    dm = newDm;
                  });
                }
              },
              icon: const Icon(Icons.file_open))
        ],
      ),
      body: page,
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(accountName: Text('CheckupApp'), accountEmail: null),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Reports'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(index: 0);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.mode),
              title: const Text('Object types'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(index: 1);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_box),
              title: const Text('Tasks'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(index: 2);
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Import/Export data'),
              leading: const Icon(Icons.import_export),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Pick an option'),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.download),
                          title: const Text('Import from file...'),
                          onTap: () => importFromFile(),
                        ),
                        ListTile(
                          leading: const Icon(Icons.upload),
                          title: const Text('Share data export...'),
                          onTap: () => shareData(),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(context: context, applicationName: 'Checkup app');
              },
            )
          ],
        ),
      ),
    );
  }

  //FAB functions

  mainReportsFabTapped() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Report report = Report(dm: dm);
      dm.reports.add(report);
      return AddReportPage(
        report: report,
        dm: dm,
        isAdding: true,
        parentSetState: setState,
      );
    }));
  }

  mainObjectTypesFabTapped() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ObjectTypeEditorPage(
                  dm: dm,
                  isAdding: true,
                  onUpdate: () => setState(() {}),
                )));
  }

  mainTasksFabTapped() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TasksEditorPage(
            dm: dm,
            isAdding: true,
            onUpdate: () => setState(() {}),
          ),
        ));
  }

  // https://stackoverflow.com/questions/28565242/convert-uint8list-to-string-with-dart by Günter Zöchbauer

  importFromFile() {
    FilePicker.platform.pickFiles().then((value) {
      if (value != null && value.files.length == 1) {
        String path = value.files.single.path!;
        try {
          var file = XFile(path);
          file.readAsString().then((value) {
            DataMaster newDm = DataMaster.fromJson(jsonDecode(value));
            setState(() {
              dm = newDm;
            });
            save();
          });
        } catch (e) {
          return;
        }
      }
    });
  }

  shareData() {
    String jsonData = jsonEncode(dm.toJson());
    XFile file = XFile.fromData(Uint8List.fromList(utf8.encode(jsonData)));
    Share.shareXFiles([file]);
  }
}
