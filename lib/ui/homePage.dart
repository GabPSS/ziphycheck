import 'package:flutter/material.dart';

import '../data/DataMaster.dart';
import '../models/Report.dart';
import 'addReportPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataMaster dm = DataMaster();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // editReportDialog(context, true);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              Report report = Report(dm: dm);
              dm.reports.add(report);
              return AddReportPage(
                report: report,
                dm: dm,
              );
            }));
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Checkup App'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String reportName = dm.reports[index].name != ""
              ? dm.reports[index].name
              : "Report #${index + 1}";
          return Card(
              child: InkWell(
            onTap: () {},
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
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const ListTile(
              title: Text('Checkup App', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Reports'),
            ),
            const ListTile(
              leading: Icon(Icons.mode),
              title: Text('Object types'),
            ),
            const ListTile(
              leading: Icon(Icons.check_box),
              title: Text('Tasks'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('About'),
              onTap: () {
                showAboutDialog(context: context, applicationName: 'Checkup app');
              },
            )
          ],
        ),
      ),
    );
  }
}
