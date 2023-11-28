import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddReportPage extends StatefulWidget {
  final Report? report;
  bool get isAdding => report == null;

  const AddReportPage({
    super.key,
    required this.report,
  });

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  late Report report;
  late DataMaster dm;

  @override
  void initState() {
    report = widget.isAdding ? Report(name: 'New report') : widget.report!;
    dm = Provider.of<DataMaster>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: closePage, icon: const Icon(Icons.close)),
        title: Text(widget.isAdding ? 'New report' : 'Edit report'),
        actions: [
          TextButton(
              onPressed: save,
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
              },
            ),
          ),
          Expanded(
              child: ListView(
            children: buildWidgets(),
          ))
        ],
      ),
    );
  }

  List<Widget> buildWidgets() {
    List<DropdownMenuItem> objectTypes = List.empty(growable: true);
    objectTypes.add(const DropdownMenuItem(
      value: null,
      child: Text('(No type)'),
    ));
    objectTypes.addAll(dm.objectTypes.map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.name),
        )));

    List<Widget> locations = List.empty(growable: true);
    for (var i = 0; i < report.locations.length; i++) {
      List<Widget> objects = List.empty(growable: true);
      for (var x = 0; x < report.locations[i].checkupObjects.length; x++) {
        var object = report.locations[i].checkupObjects[x];
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
            value: object.getObjectType(dm),
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
        title: const Text("New object"),
        onTap: () {
          setState(() {
            report.locations[i].checkupObjects.add(CheckupObject());
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

    return locations;
  }

  Future<void> closePage() async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard report?'),
        content: const Text('Closing will discard this report'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Discard')),
        ],
      ),
    );

    if (result == true) {
      if (!mounted) return;
      Navigator.pop(context);
      dm.removeReport(report);
    }
  }

  void save() {
    Navigator.pop(context);
    if (widget.isAdding) {
      dm.addObject(report);
    } else {
      dm.update();
    }
  }
}
