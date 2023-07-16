import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/add_report_page.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/report.dart';

class ViewReportPage extends StatefulWidget {
  final DataMaster dm;
  final Report report;

  const ViewReportPage({super.key, required this.dm, required this.report});

  @override
  State<ViewReportPage> createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = List.empty(growable: true);
    listWidgets.addAll([
      Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Text(
            widget.report.name,
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
                      return AddReportPage(
                        report: widget.report,
                        dm: widget.dm,
                        parentSetState: setState,
                      );
                    },
                  ));
                },
                child: const Text("Edit report")),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete \'${widget.report.name}\'?'),
                    content: const Text("You won't be able to recover this report once it's gone"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Scaffold.of(context).setState(() {});
                          },
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            setState(() {
                              widget.dm.reports.remove(widget.report);
                            });
                          },
                          child: const Text('Delete'))
                    ],
                  ),
                );
              },
              child: Icon(Icons.delete),
            ),
          )
        ],
      ),
      const Divider()
    ]);
    listWidgets
        .addAll(widget.dm.getAnswersForReport(widget.report).map((reportAnswer) => buildAnswerListTile(reportAnswer, context)));

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FillAnswerPage(
                adding: true,
                dm: widget.dm,
                reportAnswer: ReportAnswer(dm: widget.dm, baseReportId: widget.report.id),
                parentSetState: setState,
              );
            },
          ));
        },
        child: const Icon(Icons.note_add),
      ),
      body: ListView(children: listWidgets),
    );
  }

  ListTile buildAnswerListTile(ReportAnswer reportAnswer, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.assignment),
      title: Text(DateFormat('dd/MM/yyyy HH:mm').format(reportAnswer.answerDate)),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FillAnswerPage(dm: widget.dm, reportAnswer: reportAnswer, parentSetState: setState))),
    );
  }
}
