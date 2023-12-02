import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/add_report_page.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/report.dart';

class ViewReportPage extends StatefulWidget {
  final Report report;

  const ViewReportPage({super.key, required this.report});

  @override
  State<ViewReportPage> createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  late DataMaster dm;

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataMaster>(
      builder: (context, dm, child) {
        List<Widget> listWidgets = List.empty(growable: true);
        listWidgets.addAll([
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Text(
                widget.report.name,
                style: const TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
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
                          );
                        },
                      ));
                    },
                    child: const Text("Edit report")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete \'${widget.report.name}\'?'),
                        content: const Text(
                            "You won't be able to recover this report once it's gone"),
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
                                  dm.reports.remove(widget.report);
                                });
                              },
                              child: const Text('Delete'))
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.delete),
                ),
              )
            ],
          ),
          const Divider()
        ]);
        listWidgets.addAll(dm
            .getAnswersForReport(widget.report)
            .map((reportAnswer) => buildAnswerListTile(reportAnswer, context)));

        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              var newAnswer = ReportAnswer(reportId: widget.report.id);
              dm.addObject(newAnswer);
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FillAnswerPage(
                    reportAnswer: newAnswer,
                  );
                },
              ));
            },
            child: const Icon(Icons.note_add),
          ),
          body: ListView(children: listWidgets),
        );
      },
    );
  }

  ListTile buildAnswerListTile(
      ReportAnswer reportAnswer, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.assignment),
      title:
          Text(DateFormat('dd/MM/yyyy HH:mm').format(reportAnswer.answerDate)),
      trailing: PopupMenuButton(
        onSelected: (value) {
          switch (value) {
            case 0:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FillAnswerPage(reportAnswer: reportAnswer)));
              break;
            case 1:
              reportAnswer.share(dm);
              break;
            case 2:
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete report answer?'),
                  content: const Text(
                      "You won't be able to recover this report answer once it's gone"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            dm.reportAnswers.remove(reportAnswer);
                          });
                        },
                        child: const Text('Delete'))
                  ],
                ),
              );
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
                leading: Icon(Icons.share),
                title: Text('Share'),
              )),
          const PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ))
        ],
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FillAnswerPage(reportAnswer: reportAnswer))),
    );
  }
}
