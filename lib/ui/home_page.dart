import 'package:checkup_app/ui/main_checks/check_editor_page.dart';
import 'package:checkup_app/ui/main_checks/main_checks_page.dart';
import 'package:checkup_app/ui/main_object_types/main_object_types_page.dart';
import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:checkup_app/ui/main_reports/main_reports_page.dart';
import 'package:flutter/material.dart';
import 'main_reports/add_report_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? page;
  int pageIndex = 0;
  String title = "";

  _HomePageState() {
    setPage(index: 0);
  }

  void setPage({int? index}) {
    if (index != null) {
      pageIndex = index;
    }
    switch (pageIndex) {
      case 0:
        page = const MainReportsPage();
        title = mounted ? AppLocalizations.of(context)!.reports : "";
        break;
      case 1:
        page = const MainObjectTypesPage();
        title = mounted ? AppLocalizations.of(context)!.objectTypes : "";
        break;
      case 2:
        page = const MainChecksPage();
        title = mounted ? AppLocalizations.of(context)!.checks : "";
      default:
        throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    setPage();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: fabTapped, child: const Icon(Icons.add)),
      appBar: AppBar(
        title: Text(title),
      ),
      body: page,
      drawer: buildDrawer(context),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
              accountName: Text('CheckupApp'), accountEmail: null),
          ListTile(
            leading: const Icon(Icons.assignment),
            title: Text(AppLocalizations.of(context)!.reports),
            onTap: () {
              setState(() {
                Navigator.pop(context);
                setPage(index: 0);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.mode),
            title: Text(AppLocalizations.of(context)!.objectTypes),
            onTap: () {
              setState(() {
                Navigator.pop(context);
                setPage(index: 1);
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: Text(AppLocalizations.of(context)!.checks),
            onTap: () {
              setState(() {
                Navigator.pop(context);
                setPage(index: 2);
              });
            },
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.importExport),
            leading: const Icon(Icons.import_export),
            onTap: () {
              //TODO: #24 Implement importexport dialog
              throw UnimplementedError();
              // showDialog(
              //   context: context,
              //   builder: (context) {
              //     return SimpleDialog(
              //       title: const Text('Pick an option'),
              //       children: [
              //         ListTile(
              //           leading: const Icon(Icons.download),
              //           title: const Text('Import from file...'),
              //           onTap: () => importFromFile(),
              //         ),
              //         ListTile(
              //           leading: const Icon(Icons.upload),
              //           title: const Text('Share data export...'),
              //           onTap: () => shareData(),
              //         )
              //       ],
              //     );
              //   },
              // );
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(AppLocalizations.of(context)!.aboutButtonLabel),
            onTap: () {
              showAboutDialog(context: context, applicationName: 'CheckupApp');
            },
          )
        ],
      ),
    );
  }

  fabTapped() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => switch (pageIndex) {
            0 => const AddReportPage(report: null),
            1 => const ObjectTypeEditorPage(objectType: null),
            2 => const CheckEditorPage(check: null),
            _ => throw UnimplementedError(),
          },
        ));
  }

  // shareData() async {
  //   String? path = await FilePicker.platform.saveFile();
  //   if (path != null) {
  //     var file = File(path);
  //     await file.writeAsString(jsonEncode(dm.toJson()));
  //   }
  // }
}
