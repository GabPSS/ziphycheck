import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          buildLocationHeader(),
          //TODO: Add new redesign widgets
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillLocationPage(
                            answer: widget.reportAnswer,
                            location: widget.location),
                      ));
                },
                child: const Text("View checks")),
          )
        ],
      ),
    );
  }

  Widget buildLocationHeader() {
    return ListTile(
      leading: const Icon(Icons.place, size: 72),
      title: Text(
        widget.location.name,
        textScaleFactor: 1.5,
      ),
      subtitle: Consumer<DataMaster>(
        builder: (context, dm, child) {
          Map<String, int> info =
              widget.location.getInfo(widget.reportAnswer, dm);
          return Text(
              "${info['checked']}/${info['total']} checked, ${info['issues']} issue(s)");
        },
      ),
    );
  }
}
