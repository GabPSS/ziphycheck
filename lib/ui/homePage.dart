import 'package:checkup_app/ui/addObjectTypePage.dart';
import 'package:checkup_app/ui/mainObjectTypesPage.dart';
import 'package:checkup_app/ui/mainReportsPage.dart';
import 'package:checkup_app/ui/viewReportPage.dart';
import 'package:flutter/material.dart';

import '../data/dataMaster.dart';
import '../models/report.dart';
import 'addReportPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? page;
  Function()? fabFunction;
  String title = "";
  DataMaster dm = DataMaster();

  _HomePageState() {
    setPage(0);
  }

  void setPage(int index) {
    switch (index) {
      case 0:
        page = MainReportsPage(dm: dm);
        fabFunction = mainReportsFabTapped;
        title = "Reports";
        break;
      case 1:
        page = Placeholder();
        fabFunction = mainObjectTypesFabTapped;
        title = "Object Types";
        break;
      case 2:
        page = Placeholder();
        fabFunction = null;
        title = "Tasks";
      default:
        throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: fabFunction, child: const Icon(Icons.add)),
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: page,
      drawer: Drawer(
        child: Column(
          children: [
            const ListTile(
              title: Text(
                'Checkup App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Reports'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(0);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.mode),
              title: Text('Object types'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(1);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Tasks'),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                  setPage(2);
                });
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(
                    context: context, applicationName: 'Checkup app');
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
      );
    }));
  }

  mainObjectTypesFabTapped() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddObjectTypePage()));
  }
}
