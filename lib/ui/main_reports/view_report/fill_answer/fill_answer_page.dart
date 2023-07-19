import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
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
  bool tasksView = false;

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

    if (tasksView) {
      buildTasksView(widgets);
    } else {
      buildDefaultView(widgets, context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.adding ? "Fill answer" : "View answer"),
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
      body: ListView(children: widgets),
    );
  }

  void buildDefaultView(List<Widget> widgets, BuildContext context) {
    for (var i = 0; i < baseReport.locations.length; i++) {
      var location = baseReport.locations[i];
      widgets.add(
        getLocationTile(location),
      );
      widgets.addAll(location.objects.map((checkupObject) {
        int objectTasksCount = checkupObject.getObjectType(widget.dm)?.getTasks(widget.dm).length ?? 0;
        int answeredTasksCount = widget.reportAnswer.getTaskAnswersByObjectId(checkupObject.id).length;

        return getItemTile(getObjectTile(checkupObject, answeredTasksCount, objectTasksCount, context, location));
      }));
    }
  }

  Padding getItemTile(ListTile listTile) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
        child: Card(
          child: listTile,
        ));
  }

  ListTile getObjectTile(
      CheckupObject checkupObject, int answeredTasksCount, int objectTasksCount, BuildContext context, Location location) {
    return ListTile(
      leading: Icon(checkupObject.getObjectType(widget.dm)?.getIcon() ?? Icons.device_unknown),
      title: Text(checkupObject.getFullName(widget.dm)),
      subtitle: Text("$answeredTasksCount/$objectTasksCount task${objectTasksCount == 1 ? "" : "s"}"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FillObjectAnswerPage(
                dm: widget.dm,
                startObject: checkupObject,
                startLocation: location,
                reportAnswer: widget.reportAnswer,
                sortByTasks: false,
              ),
            ));
      },
    );
  }

  ListTile getLocationTile(Location location) => ListTile(leading: const Icon(Icons.location_on), title: Text(location.name));

  void buildTasksView(List<Widget> widgets) {
    for (var location in baseReport.locations) {
      widgets.add(getLocationTile(location));
      widgets.addAll(widget.dm.getTasksForLocation(location).map((task) => getItemTile(ListTile(
            leading: const Icon(Icons.check_box),
            title: Text(task.name),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillObjectAnswerPage(
                      dm: widget.dm,
                      reportAnswer: widget.reportAnswer,
                      sortByTasks: true,
                      startLocation: location,
                      startTask: task,
                    ),
                  ));
            },
          ))));
    }
    // widgets.addAll(baseReport.locations.map((e) => null));
  }
}
