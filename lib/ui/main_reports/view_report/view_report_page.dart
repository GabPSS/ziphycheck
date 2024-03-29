import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:ziphycheck/settings/settings.dart';
import 'package:ziphycheck/ui/main_reports/add_report_page.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/fill_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AddReportPage(
                            report: widget.report,
                          );
                        },
                      ));
                      dm.update();
                    },
                    child: Text(
                        AppLocalizations.of(context)!.editReportWindowTitle)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context)!
                            .deleteReportDialogTitle(widget.report.name)),
                        content: Text(AppLocalizations.of(context)!
                            .deleteReportDialogContents),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .cancelButtonLabel)),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                setState(() {
                                  dm.reports.remove(widget.report);
                                });
                                dm.update();
                              },
                              child: Text(AppLocalizations.of(context)!
                                  .deleteButtonLabel))
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
            onPressed: () async {
              var newAnswer = ReportAnswer(reportId: widget.report.id);
              dm.addObject(newAnswer);
              await Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FillAnswerPage(
                    reportAnswer: newAnswer,
                  );
                },
              ));
              dm.update();
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
              reportAnswer.share(
                  dm,
                  Provider.of<Settings>(context, listen: false)
                      .getReportOutputLocale(Localizations.localeOf(context)));
              break;
            case 2:
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!
                      .deleteReportAnswerDialogTitle),
                  content: Text(AppLocalizations.of(context)!
                      .deleteReportAnswerDialogContents),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                            AppLocalizations.of(context)!.cancelButtonLabel)),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            dm.reportAnswers.remove(reportAnswer);
                          });
                        },
                        child: Text(
                            AppLocalizations.of(context)!.deleteButtonLabel))
                  ],
                ),
              );
            default:
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 0,
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: Text(AppLocalizations.of(context)!.editButtonLabel),
              )),
          PopupMenuItem(
              value: 1,
              child: ListTile(
                leading: const Icon(Icons.share),
                title: Text(AppLocalizations.of(context)!.shareButtonLabel),
              )),
          PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: const Icon(Icons.delete),
                title: Text(AppLocalizations.of(context)!.deleteButtonLabel),
              ))
        ],
      ),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FillAnswerPage(reportAnswer: reportAnswer)));
        dm.update();
      },
    );
  }
}
