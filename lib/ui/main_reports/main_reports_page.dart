import 'package:checkup_app/ui/main_reports/view_report/view_report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                                title: Text(
                                    'Delete \'${dm.reports[index].name}\'?'),
                                content: const Text(
                                    "You won't be able to recover this report once it's gone"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        dm.removeObject(dm.reports[index]);
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
                              leading: Icon(Icons.delete),
                              title: Text('Delete'),
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
    return const Center(
      child: Text('There are no reports. Tap + to add a new report'),
    );
  }
}
