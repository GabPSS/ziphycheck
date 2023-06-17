import 'package:checkup_app/data/dataMaster.dart';
import 'package:checkup_app/models/checkupObject.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/objectType.dart';
import 'package:flutter/material.dart';

class AddReportPage extends StatefulWidget {
  Report report;
  DataMaster dm;
  bool isAdding;
  AddReportPage({super.key, required this.report, this.isAdding = false, required this.dm});

  @override
  State<AddReportPage> createState() => _AddReportPageState(report: report, isAdding: isAdding, dm: dm);
}

class _AddReportPageState extends State<AddReportPage> {
  Report report;
  DataMaster dm;
  bool isAdding;
  _AddReportPageState({required this.report, required this.isAdding, required this.dm});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> objectTypes = List.empty(growable: true);
    objectTypes.add(DropdownMenuItem(
      child: Text('(No type)'),
      value: null,
    ));
    objectTypes.addAll(dm.objectTypes.map((e) => DropdownMenuItem(
          child: Text(e.name),
          value: e,
        )));

    List<Widget> locations = List.empty(growable: true);
    for (var i = 0; i < report.locations.length; i++) {
      List<Widget> objects = List.empty(growable: true);
      for (var x = 0; x < report.locations[i].objects.length; x++) {
        var object = report.locations[i].objects[x];
        objects.add(ListTile(
          leading: const Icon(Icons.desktop_windows),
          title: TextFormField(
            decoration: const InputDecoration(border: InputBorder.none),
            initialValue: object.name == "" ? "Unnamed object" : object.name,
            onChanged: (value) {
              object.name = value;
            },
          ),
          trailing: DropdownButton(
            items: objectTypes,
            value: object.objectType,
            onChanged: (value) {
              setState(() {
                object.objectType = value;
              });
            },
          ),
        ));
      }
      objects.add(ListTile(
        leading: const Icon(Icons.add),
        title: const Text("Add new object"),
        onTap: () {
          setState(() {
            report.locations[i].objects.add(CheckupObject(report: report));
          });
        },
      ));
      locations.add(Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: TextFormField(
              initialValue: report.locations[i].name == ""
                  ? "Unnamed location"
                  : report.locations[i].name,
              onChanged: (value) {
                report.locations[i].name = value;
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
              child: Column(
                children: objects,
              ))
        ],
      ));
    }
    locations.add(ListTile(
      leading: const Icon(Icons.add),
      title: const Text("Add new location"),
      onTap: () {
        setState(() {
          report.locations.add(Location());
        });
      },
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (isAdding) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Discard report?'),
                  content: const Text('Closing will discard this report'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          dm.reports.remove(report);
                        },
                        child: const Text('Discard'))
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
              setState(() {});
            }
          },
        ),
        title: Text(isAdding ? 'New report' : 'Edit report'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
              ))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name'),
              initialValue: report.name,
              onChanged: (value) {
                report.name = value;
                },),
          ),
          Expanded(
              child: ListView(
            children: locations,
          ))
        ],
      ),
    );
  }
}
