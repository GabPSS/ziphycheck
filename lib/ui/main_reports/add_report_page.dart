import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:flutter/material.dart';

class AddReportPage extends StatefulWidget {
  final Report report;
  final DataMaster dm;
  final bool isAdding;
  final Function(Function()) parentSetState;
  const AddReportPage({super.key, required this.report, this.isAdding = false, required this.dm, required this.parentSetState});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  _AddReportPageState();

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> objectTypes = List.empty(growable: true);
    objectTypes.add(const DropdownMenuItem(
      value: null,
      child: Text('(No type)'),
    ));
    objectTypes.addAll(widget.dm.objectTypes.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        )));

    List<Widget> locations = List.empty(growable: true);
    for (var i = 0; i < widget.report.locations.length; i++) {
      List<Widget> objects = List.empty(growable: true);
      for (var x = 0; x < widget.report.locations[i].objects.length; x++) {
        var object = widget.report.locations[i].objects[x];
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
            widget.report.locations[i].objects.add(CheckupObject(report: widget.report));
          });
        },
      ));
      locations.add(Column(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: TextFormField(
              initialValue: widget.report.locations[i].name == "" ? "Unnamed location" : widget.report.locations[i].name,
              onChanged: (value) {
                widget.report.locations[i].name = value;
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
          widget.report.locations.add(Location());
        });
      },
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (widget.isAdding) {
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
                          widget.dm.reports.remove(widget.report);
                        },
                        child: const Text('Discard'))
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
              widget.parentSetState(
                () {},
              );
            }
          },
        ),
        title: Text(widget.isAdding ? 'New report' : 'Edit report'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.parentSetState(() {});
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
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
              initialValue: widget.report.name,
              onChanged: (value) {
                widget.report.name = value;
              },
            ),
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
