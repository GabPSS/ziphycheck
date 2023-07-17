import 'dart:developer';

import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/object_type.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/models/task.dart';
import 'package:checkup_app/models/task_answer.dart';
import 'package:checkup_app/ui/main_object_types/object_type_editor_page.dart';
import 'package:checkup_app/ui/main_object_types/main_object_types_page.dart';
import 'package:checkup_app/ui/main_reports/main_reports_page.dart';
import 'package:checkup_app/ui/main_tasks/main_tasks_page.dart';
import 'package:checkup_app/ui/main_tasks/tasks_editor_page.dart';
import 'package:flutter/material.dart';

import '../data/data_master.dart';
import '../models/report.dart';
import 'main_reports/add_report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? page;
  int pageIndex = 0;
  Function()? fabFunction;
  String title = "";
  DataMaster dm = DataMaster();

  _HomePageState() {
    setPage(index: 0);
  }

  @override
  void initState() {
    // TODO: Replace placeholder DM with DM opening from file later
    var task = Task(dm: dm);
    task.name = "Check PCs later";
    task.answerPrompt = "% {has an issue|have issues} there";

    var objectType = ObjectType(dm: dm);
    objectType.name = "PC";
    objectType.addTask(task);

    var report = Report(dm: dm);
    report.name = "First report";

    var location = Location();
    location.name = "Place 1";

    var checkupObject = CheckupObject(report: report);
    checkupObject.objectType = objectType;
    checkupObject.name = "1";

    var checkupObject2 = CheckupObject(report: report);
    checkupObject2.objectType = objectType;
    checkupObject2.name = "2";

    location.objects.add(checkupObject);
    location.objects.add(checkupObject2);
    report.locations.add(location);

    var reportAnswer = ReportAnswer(dm: dm, baseReportId: report.id);
    reportAnswer.answerDate = DateTime.now();

    var taskAnswer = TaskAnswer(taskId: task.id, objectId: checkupObject.id);
    taskAnswer.failAnswerPrompt = task.answerPrompt;
    var taskAnswer2 = TaskAnswer(taskId: task.id, objectId: checkupObject2.id);
    taskAnswer2.failAnswerPrompt = task.answerPrompt;
    reportAnswer.answers.add(taskAnswer);
    reportAnswer.answers.add(taskAnswer2);
    dm.reports.add(report);

    log(reportAnswer.getReportString(dm));

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    setPage();
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: fabFunction, child: const Icon(Icons.add)),
      appBar: AppBar(
        title: Text(title),
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
}
