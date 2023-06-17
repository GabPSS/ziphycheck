import 'package:checkup_app/data/dataMaster.dart';
import 'package:checkup_app/models/reportAnswer.dart';
import 'package:checkup_app/ui/addReportPage.dart';
import 'package:checkup_app/ui/fillAnswerPage.dart';
import 'package:flutter/material.dart';

import '../models/report.dart';

class ViewReportPage extends StatefulWidget {
  DataMaster dm;
  Report report;

  ViewReportPage({super.key, required this.dm, required this.report});

  @override
  State<ViewReportPage> createState() =>
      _ViewReportPageState(dm: dm, report: report);
}

class _ViewReportPageState extends State<ViewReportPage> {
  DataMaster dm;
  Report report;

  _ViewReportPageState({required this.dm, required this.report});

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = List.empty(growable: true);
    listWidgets.addAll([
      Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Text(
            report.name,
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AddReportPage(report: report, dm: dm);
                    },
                  ));
                },
                child: Text("Edit report")),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: null, child: Icon(Icons.delete)),
          )
        ],
      ),
      Divider()
    ]);
    listWidgets.addAll(dm.getAnswersForReport(report).map((e) => ListTile(
          title: Text(e.answerDate.toString()),
        )));

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FillAnswerPage(adding: true, dm: dm, reportAnswer: ReportAnswer(dm: dm, baseReportId: report.id),);
            },
          ));
        },
        child: Icon(Icons.note_add),
      ),
      body: ListView(children: listWidgets),
    );
  }
}
