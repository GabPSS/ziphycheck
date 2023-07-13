import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

import '../../../../models/report.dart';

class FillAnswerPage extends StatelessWidget {
  final DataMaster dm;
  final ReportAnswer reportAnswer;
  Report get baseReport => dm.getReportById(reportAnswer.baseReportId);
  final bool adding;
  final Function(Function()) parentSetState;

  const FillAnswerPage(
      {super.key, required this.reportAnswer, required this.dm, this.adding = false, required this.parentSetState});

  @override
  Widget build(BuildContext context) {
    List<Widget> locations = List.empty(growable: true);
    locations.add(
      Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimeFormField(
              initialValue: reportAnswer.answerDate,
              decoration: const InputDecoration(
                icon: Icon(Icons.today),
                border: OutlineInputBorder(),
                labelText: "Date and time",
              ),
              onDateSelected: (value) {
                reportAnswer.answerDate = value;
              },
              mode: DateTimeFieldPickerMode.dateAndTime,
            ),
          )),
        ],
      ),
    );

    for (var i = 0; i < baseReport.locations.length; i++) {
      locations.add(
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(baseReport.locations[i].name),
        ),
      );

      for (var x = 0; x < baseReport.locations[i].objects.length; x++) {
        locations.add(Padding(
            padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
            child: Card(
                child: ListTile(leading: const Icon(Icons.computer), title: Text(baseReport.locations[i].objects[x].name)))));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(adding ? "Fill answer" : "View answer"),
        actions: [
          TextButton(
              onPressed: () {
                if (adding) {
                  dm.reportAnswers.add(reportAnswer);
                }
                Navigator.pop(context);
                parentSetState(() {});
              },
              child: const Text('Save'))
        ],
      ),
      body: ListView(children: locations),
    );
  }
}
