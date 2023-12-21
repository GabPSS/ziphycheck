import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
    report = widget.isAdding ? Report(name: "") : widget.report!;
    dm = Provider.of<DataMaster>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: closePage, icon: const Icon(Icons.close)),
        title: Text(widget.isAdding
            ? AppLocalizations.of(context)!.newReportWindowTitle
            : AppLocalizations.of(context)!.editReportWindowTitle),
        actions: [
          TextButton(
              onPressed: save,
              child: Text(AppLocalizations.of(context)!.saveButtonLabel))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.nameFieldLabel),
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
    objectTypes.add(DropdownMenuItem(
      value: null,
      child: Text(AppLocalizations.of(context)!.noObjectTypeDropdownOption),
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
        objects.add(buildObjectListTile(object, objectTypes));
      }
      objects.add(ListTile(
        leading: const Icon(Icons.add),
        title: Text(AppLocalizations.of(context)!.newObjectButtonLabel),
        onTap: () {
          setState(() {
            report.addObject(report.locations[i], CheckupObject());
          });
        },
      ));
      locations.add(buildLocationWidget(i, objects));
    }
    locations.add(ListTile(
      leading: const Icon(Icons.add),
      title: Text(AppLocalizations.of(context)!.newLocationButtonLabel),
      onTap: () {
        setState(() {
          report.addLocation(Location());
        });
      },
    ));

    return locations;
  }

  Column buildLocationWidget(int i, List<Widget> objects) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on),
          title: TextFormField(
            initialValue: report.locations[i].name == ""
                ? AppLocalizations.of(context)!.newLocation
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
    );
  }

  ListTile buildObjectListTile(
      CheckupObject object, List<DropdownMenuItem<dynamic>> objectTypes) {
    return ListTile(
      leading: const Icon(Icons.desktop_windows),
      title: TextFormField(
        decoration: const InputDecoration(border: InputBorder.none),
        initialValue: object.name == ""
            ? AppLocalizations.of(context)!.newObject
            : object.name,
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
    );
  }

  Future<void> closePage() async {
    if (!widget.isAdding) {
      Navigator.pop(context);
      dm.update();
      return;
    }

    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.discardReportDialogTitle),
        content:
            Text(AppLocalizations.of(context)!.discardReportDialogContents),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(AppLocalizations.of(context)!.cancelButtonLabel)),
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(AppLocalizations.of(context)!.discardButtonLabel)),
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
