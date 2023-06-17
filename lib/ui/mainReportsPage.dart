import 'package:checkup_app/ui/viewReportPage.dart';
import 'package:flutter/material.dart';

import '../data/dataMaster.dart';
import 'addReportPage.dart';

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
  }
}