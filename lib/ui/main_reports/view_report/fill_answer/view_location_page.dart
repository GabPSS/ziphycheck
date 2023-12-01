import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_location_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewLocationPage extends StatefulWidget {
  final Location location;
  final ReportAnswer reportAnswer;

  const ViewLocationPage({
    super.key,
    required this.location,
    required this.reportAnswer,
  });

  @override
  State<ViewLocationPage> createState() => _ViewLocationPageState();
}

class _ViewLocationPageState extends State<ViewLocationPage> {
  LocationAnswer get locationAnswer =>
      widget.reportAnswer.getOrCreateLocationAnswer(widget.location);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          buildLocationHeader(),
          //TODO: Add new redesign widgets
          buildIssueReporter(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FillLocationPage(
                          answer: widget.reportAnswer,
                          location: widget.location),
                    ));
              },
              label: const Text("View checks"),
              icon: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLocationHeader() {
    return ListTile(
      leading: const Icon(Icons.place, size: 64),
      title: Text(
        widget.location.name,
        textScaleFactor: 1.5,
      ),
      subtitle: Consumer<DataMaster>(
        builder: (context, dm, child) {
          Map<String, int> info =
              widget.location.getInfo(widget.reportAnswer, dm);
          return Text(
              "${info['checked']}/${info['total']} checked\n${info['issues']} issue(s)");
        },
      ),
    );
  }

  Widget buildIssueReporter() {
    return Column(
      children: [
        SwitchListTile(
          value: !locationAnswer.status,
          title: Text("Report issue"),
          subtitle: Text("Use this if you found location issues"),
          onChanged: (value) {
            setState(() {
              locationAnswer.status = !value;
              // Provider.of<DataMaster>(context, listen: false).update();
            });
          },
        ),
        if (!locationAnswer.status)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              return TextField(
                controller: TextEditingController(text: locationAnswer.notes),
                decoration: InputDecoration(labelText: 'Issue description'),
                onChanged: (value) {
                  locationAnswer.notes = value;
                  //TODO: Why issues and notes? Why not a single thing?
                },
              );
            }),
          )
      ],
    );
  }
}
