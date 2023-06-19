import 'package:checkup_app/ui/main_reports/view_report/view_report_page.dart';
import 'package:flutter/material.dart';

import '../../data/data_master.dart';
import 'add_report_page.dart';

class MainReportsPage extends StatefulWidget {
  DataMaster dm;
  MainReportsPage({super.key, required this.dm});

  @override
  State<MainReportsPage> createState() => _MainReportsPageState(dm: dm);
}

class _MainReportsPageState extends State<MainReportsPage> {
  DataMaster dm;

  _MainReportsPageState({required this.dm});
  
  @override
  Widget build(BuildContext context) {
    if (dm.reports.isNotEmpty) {
    return ListView.builder(
        itemBuilder: (context, index) {
          String reportName = dm.reports[index].name != ""
              ? dm.reports[index].name
              : "Report #${index + 1}";
          return Card(
              child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ViewReportPage(dm: dm, report: dm.reports[index],);
              },));
            },
            child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.assignment),
                ),
                title: Text(reportName),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return AddReportPage(
                              report: dm.reports[index],
                              dm: dm,
                              parentSetState: setState,
                            );
                          },
                        ));
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title:
                                Text('Delete \'${dm.reports[index].name}\'?'),
                            content: const Text(
                                "You won't be able to recover this report once it's gone"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    setState(() {
                                      dm.reports.removeAt(index);
                                    });
                                  },
                                  child: const Text('Delete'))
                            ],
                          ),
                        );
                      },
                    ))
                  ],
                )),
          ));
        },
        itemCount: dm.reports.length,
      );
    } else {
      return const Center(
        child: Text('There are no reports. Tap + to add a new report'),
      );
    }
  }
}