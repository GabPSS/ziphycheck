import 'package:checkup_app/ui/main_reports/view_report/view_report_page.dart';
import 'package:flutter/material.dart';

import '../../data/data_master.dart';
import 'add_report_page.dart';

class MainReportsPage extends StatefulWidget {
  final DataMaster dm;
  const MainReportsPage({super.key, required this.dm});

  @override
  State<MainReportsPage> createState() => _MainReportsPageState();
}

class _MainReportsPageState extends State<MainReportsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.dm.reports.isNotEmpty) {
      return ListView.builder(
        itemBuilder: (context, index) {
          String reportName = widget.dm.reports[index].name != "" ? widget.dm.reports[index].name : "Report #${index + 1}";
          return Card(
              child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ViewReportPage(
                    dm: widget.dm,
                    report: widget.dm.reports[index],
                  );
                },
              ));
            },
            child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.assignment),
                ),
                title: Text(reportName),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return AddReportPage(
                              report: widget.dm.reports[index],
                              dm: widget.dm,
                              parentSetState: setState,
                            );
                          },
                        ));
                        break;
                      case 1:
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete \'${widget.dm.reports[index].name}\'?'),
                            content: const Text("You won't be able to recover this report once it's gone"),
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
                                      widget.dm.reports.removeAt(index);
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
                          leading: Icon(Icons.delete),
                          title: Text('Delete'),
                        ))
                  ],
                )),
          ));
        },
        itemCount: widget.dm.reports.length,
      );
    } else {
      return const Center(
        child: Text('There are no reports. Tap + to add a new report'),
      );
    }
  }
}
