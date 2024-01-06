import 'package:ziphycheck/ui/main_reports/view_report/view_report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../data/data_master.dart';
import 'add_report_page.dart';

class MainReportsPage extends StatefulWidget {
  const MainReportsPage({super.key});

  @override
  State<MainReportsPage> createState() => _MainReportsPageState();
}

class _MainReportsPageState extends State<MainReportsPage> {
  @override
  Widget build(BuildContext context) {
    int count = Provider.of<DataMaster>(context).reports.length;

    if (count != 0) {
      return Consumer<DataMaster>(
        builder: (context, dm, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                  child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ViewReportPage(
                        report: dm.reports[index],
                      );
                    },
                  ));
                },
                child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.assignment),
                    ),
                    title: Text(dm.reports[index].name),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReportPage(
                                    report: dm.reports[index],
                                  ),
                                ));
                            break;
                          case 1:
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(AppLocalizations.of(context)!
                                    .deleteReportDialogTitle(
                                        dm.reports[index].name)),
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
                                        dm.removeObject(dm.reports[index]);
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .deleteButtonLabel))
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
                              title: Text(AppLocalizations.of(context)!
                                  .editButtonLabel),
                            )),
                        PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: const Icon(Icons.delete),
                              title: Text(AppLocalizations.of(context)!
                                  .deleteButtonLabel),
                            ))
                      ],
                    )),
              ));
            },
            itemCount: count,
          );
        },
      );
    }
    return Center(
      child: Text(AppLocalizations.of(context)!.noReportsLabel),
    );
  }
}
