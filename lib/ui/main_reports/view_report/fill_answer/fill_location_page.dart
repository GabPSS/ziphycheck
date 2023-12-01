import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_check_answer_details_page.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_check_answer_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FillLocationPage extends StatefulWidget {
  final ReportAnswer answer;
  final Location location;

  const FillLocationPage(
      {super.key, required this.answer, required this.location});

  @override
  State<FillLocationPage> createState() => _FillLocationPageState();
}

class _FillLocationPageState extends State<FillLocationPage> {
  Report? get report => Provider.of<DataMaster>(context)
      .reports
      .where((element) => widget.answer.reportId == element.id)
      .singleOrNull;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.location.name} checks"),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Overview',
            ),
            Tab(
              text: 'Details',
            )
          ]),
        ),
        body: Consumer<DataMaster>(builder: (context, dm, child) {
          return TabBarView(children: [
            buildDefaultView(context, dm),
            buildTasksView(dm) //TODO: Readd tasks view here
          ]);
        }),
      ),
    );
  }

  Widget buildDefaultView(BuildContext context, DataMaster dm) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(widget.location.checkupObjects.map((checkupObject) {
      Map<String, dynamic> checkupObjectInfo =
          widget.answer.getCheckupObjectInfo(checkupObject, dm);

      return Card(
        child: getObjectTile(
            checkupObject, checkupObjectInfo, context, widget.location, dm),
      );
    }));
    return ListView(children: widgets);
  }

  Padding getItemTile(ListTile listTile) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
        child: Card(
          child: listTile,
        ));
  }

  ListTile getObjectTile(
      CheckupObject checkupObject,
      Map<String, dynamic> checkupObjectInfo,
      BuildContext context,
      Location location,
      DataMaster dm) {
    return ListTile(
      leading: Icon(
          checkupObject.getObjectType(dm)?.getIcon() ?? Icons.device_unknown),
      title: Text(checkupObject.getFullName(dm)),
      subtitle: Text(widget.answer.formatCheckupObjectInfo(
          checkupObject, dm, "%AW/%TT check%sTT, %IS issue%sIS")),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FillCheckAnswerOverviewPage(
                  reportAnswer: widget.answer, initialObject: checkupObject),
            ));
      },
    );
  }

  Widget buildTasksView(DataMaster dm) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(dm.getChecksForLocation(widget.location).map((check) {
      List<CheckupObject> objects =
          dm.filterObjectsByCheck(widget.location.checkupObjects, check);
      Iterable<CheckAnswer> answers = widget.answer
          .getAnswersByLocation(widget.location, dm, false)
          .where((element) => element.checkId == check.id);
      return Card(
        child: ListTile(
            leading: const Icon(Icons.check_box),
            title: Text(check.name),
            subtitle: Text(
                '${answers.length}/${objects.length} answer${objects.length != 1 ? 's' : ''}'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillCheckAnswerDetailsPage(
                        initialCheck: check,
                        reportAnswer: widget.answer,
                        location: widget.location),
                  ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => FillObjectAnswerPage(
              //               dm: dm,
              //               reportAnswer: widget.reportAnswer,
              //               sortByTasks: true,
              //               startLocation: location,
              //               startTask: task,
              //             )));
            }),
      );
    }));
    return ListView(children: widgets);
  }
}
