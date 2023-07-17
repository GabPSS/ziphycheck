import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_object_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

import '../../../../models/report.dart';

class FillAnswerPage extends StatefulWidget {
  final DataMaster dm;
  final ReportAnswer reportAnswer;
  final bool adding;
  final Function(Function()) parentSetState;

  const FillAnswerPage(
      {super.key, required this.reportAnswer, required this.dm, this.adding = false, required this.parentSetState});

  @override
  State<FillAnswerPage> createState() => _FillAnswerPageState();
}

class _FillAnswerPageState extends State<FillAnswerPage> {
  Report get baseReport => widget.dm.getReportById(widget.reportAnswer.baseReportId);

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
              initialValue: widget.reportAnswer.answerDate,
              decoration: const InputDecoration(
                icon: Icon(Icons.today),
                border: OutlineInputBorder(),
                labelText: "Date and time",
              ),
              onDateSelected: (value) {
                widget.reportAnswer.answerDate = value;
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
        int answeredTasksCount = widget.reportAnswer.getTaskAnswersByObjectId(checkupObject.id).length;

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
                          dm: widget.dm,
                          checkupObject: checkupObject,
                          reportAnswer: widget.reportAnswer,
                        ),
                      ));
                },
              ),
            ));
      }));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.adding ? "Fill answer" : "View answer"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                widget.dm.reportAnswers.remove(widget.reportAnswer);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => widget.reportAnswer.share(widget.dm),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.parentSetState(() {});
              },
              child: const Text('Save'))
        ],
      ),
      body: ListView(children: locationWidgets),
    );
  }
}
