import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/add_report_page.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_answer_page.dart';
import 'package:flutter/material.dart';

import '../../../models/report.dart';

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
            style: const TextStyle(fontSize: 32),
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
                      return AddReportPage(report: report, dm: dm, parentSetState: setState,);
                    },
                  ));
                },
                child: const Text("Edit report")),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: null, child: Icon(Icons.delete)),
          )
        ],
      ),
      const Divider()
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
              return FillAnswerPage(adding: true, dm: dm, reportAnswer: ReportAnswer(dm: dm, baseReportId: report.id), parentSetState: setState,);
            },
          ));
        },
        child: const Icon(Icons.note_add),
      ),
      body: ListView(children: listWidgets),
    );
  }
}
