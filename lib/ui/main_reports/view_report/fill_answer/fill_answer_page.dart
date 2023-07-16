import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_object_answer_page.dart';
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
    List<Widget> locationWidgets = List.empty(growable: true);
    locationWidgets.add(
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
      locationWidgets.add(
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(baseReport.locations[i].name),
        ),
      );
      locationWidgets.addAll(baseReport.locations[i].objects.map((checkupObject) {
        int objectTasksCount = checkupObject.objectType?.getTasks().length ?? 0;
        int answeredTasksCount = reportAnswer.getTaskAnswersByObjectId(checkupObject.id).length;

        return Padding(
            padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
            child: Card(
              child: ListTile(
                leading: Icon(checkupObject.objectType?.getIcon() ?? Icons.device_unknown),
                title: Text(checkupObject.fullName),
                subtitle: Text("$answeredTasksCount/$objectTasksCount task${objectTasksCount == 1 ? "" : "s"}"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FillObjectAnswerPage(
                          dm: dm,
                          checkupObject: checkupObject,
                          reportAnswer: reportAnswer,
                        ),
                      ));
                },
              ),
            ));
      }));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(adding ? "Fill answer" : "View answer"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                parentSetState(() {});
              },
              child: const Text('Save'))
        ],
      ),
      body: ListView(children: locationWidgets),
    );
  }
}
