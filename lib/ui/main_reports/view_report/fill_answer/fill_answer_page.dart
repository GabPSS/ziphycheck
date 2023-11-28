import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report_answer.dart';
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
  late ReportAnswer reportAnswer;
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

  // void buildDefaultView(List<Widget> widgets, BuildContext context) {
  //   for (var i = 0; i < baseReport.locations.length; i++) {
  //     var location = baseReport.locations[i];
  //     widgets.add(
  //       getLocationTile(location),
  //     );
  //     widgets.addAll(location.objects.map((checkupObject) {
  //       int objectTasksCount = checkupObject
  //               .getObjectType(dm)
  //               ?.getTasks(dm)
  //               .length ??
  //           0;
  //       int answeredTasksCount = widget.reportAnswer
  //           .getTaskAnswersByObjectId(checkupObject.id)
  //           .length;

  //       return getItemTile(getObjectTile(checkupObject, answeredTasksCount,
  //           objectTasksCount, context, location));
  //     }));
  //   }
  // }

  Padding getItemTile(ListTile listTile) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
        child: Card(
          child: listTile,
        ));
  }

  // ListTile getObjectTile(CheckupObject checkupObject, int answeredTasksCount,
  //     int objectTasksCount, BuildContext context, Location location) {
  //   return ListTile(
  //     leading: Icon(
  //         checkupObject.getObjectType(dm)?.getIcon() ?? Icons.device_unknown),
  //     title: Text(checkupObject.getFullName(dm)),
  //     subtitle: Text(
  //         "$answeredTasksCount/$objectTasksCount answer${objectTasksCount != 1 ? 's' : ''}"),
  //     onTap: () {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => FillObjectAnswerPage(
  //               dm: dm,
  //               startObject: checkupObject,
  //               startLocation: location,
  //               reportAnswer: widget.reportAnswer,
  //               sortByTasks: false,
  //             ),
  //           ));
  //     },
  //   );
  // }

  ListTile getLocationTile(Location location) => ListTile(
      leading: const Icon(Icons.location_on), title: Text(location.name));

  // void buildTasksView(List<Widget> widgets) {
  //   for (var location in baseReport.locations) {
  //     widgets.add(getLocationTile(location));
  //     widgets.addAll(dm.getTasksForLocation(location).map((task) {
  //       List<CheckupObject> objects =
  //           dm.getObjectsByTask(task, location);
  //       Iterable<TaskAnswer> answers = widget.reportAnswer
  //           .getAnswersByLocation(location, dm, false)
  //           .where((element) => element.taskId == task.id);
  //       return getItemTile(ListTile(
  //           leading: const Icon(Icons.check_box),
  //           title: Text(task.name),
  //           subtitle: Text(
  //               '${answers.length}/${objects.length} answer${objects.length != 1 ? 's' : ''}'),
  //           onTap: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => FillObjectAnswerPage(
  //                           dm: dm,
  //                           reportAnswer: widget.reportAnswer,
  //                           sortByTasks: true,
  //                           startLocation: location,
  //                           startTask: task,
  //                         )));
  //           }));
  //     }));
  //   }
  // }
}
