import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/view_location_page.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';

import '../../../../models/report.dart';

class FillAnswerPage extends StatefulWidget {
  final ReportAnswer reportAnswer;

  const FillAnswerPage({super.key, required this.reportAnswer});

  @override
  State<FillAnswerPage> createState() => _FillAnswerPageState();
}

class _FillAnswerPageState extends State<FillAnswerPage> {
  bool tasksView = false;
  late DataMaster dm;
  late Report baseReport;

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    baseReport = dm.getObjectById<Report>(widget.reportAnswer.reportId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(
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

    // if (tasksView) {
    //   buildTasksView(widgets);
    // } else {
    //   buildDefaultView(widgets, context);
    // }

    buildLocationWidgets(widgets);

    return Scaffold(
      appBar: AppBar(
        title: const Text("View answer"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  tasksView = !tasksView;
                });
              },
              icon: Icon(tasksView ? Icons.view_in_ar : Icons.checklist)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                dm.removeObject(widget.reportAnswer);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => widget.reportAnswer.share(),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                dm.update();
              },
              child: const Text('Save'))
        ],
      ),
      body: ListView(children: widgets),
    );
  }

  void buildLocationWidgets(List<Widget> widgets) {
    widgets.addAll(baseReport.locations.map((e) => Card(
          child: ListTile(
            leading: const Icon(Icons.place),
            title: Text(e.name),
            subtitle: Consumer<DataMaster>(builder: (context, dm, child) {
              Map<String, int> info = e.getInfo(widget.reportAnswer, dm);
              return Text(
                  "${info['checked']}/${info['total']} checked, ${info['issues']} issue${info['issues'] != 1 ? 's' : ''}");
            }),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewLocationPage(
                            location: e,
                            reportAnswer: widget.reportAnswer,
                          )));
            },
          ),
        )));
  }
}
