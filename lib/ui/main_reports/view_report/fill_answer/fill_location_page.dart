import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/check_answer.dart';
import 'package:ziphycheck/models/checkup_object.dart';
import 'package:ziphycheck/models/issue.dart';
import 'package:ziphycheck/models/location.dart';
import 'package:ziphycheck/models/report.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/fill_check_answer_page.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/widgets/issue_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

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
          title: Text(widget.location.name),
          bottom: TabBar(tabs: [
            Tab(
              text: AppLocalizations.of(context)!.overviewTabTitle,
            ),
            Tab(
              text: AppLocalizations.of(context)!.detailsTabTitle,
            )
          ]),
        ),
        body: Consumer<DataMaster>(builder: (context, dm, child) {
          return TabBarView(
              children: [buildOverview(context, dm), buildTasksView(dm)]);
        }),
      ),
    );
  }

  Widget buildOverview(BuildContext context, DataMaster dm) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(widget.location.checkupObjects.map((checkupObject) {
      Map<String, dynamic> checkupObjectInfo =
          widget.answer.getCheckupObjectInfo(checkupObject, dm);

      return Column(
        children: [
          Card(
            child: getObjectTile(
                checkupObject, checkupObjectInfo, context, widget.location, dm),
          ),
          for (Issue issue in widget.answer.getObjectIssues(checkupObject))
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
              child: Card(
                child: IssueTile(
                  checkupObject: checkupObject,
                  reportAnswer: widget.answer,
                  style: IssueTileStyle.preview,
                  solved: issue.solved,
                  value: true,
                  issueName: issue.name,
                  onDelete: () {
                    setState(() {
                      widget.answer.removeIssue(issue, checkupObject);
                    });
                  },
                  onUpdateIssue: (exists, name, notes, solved) {
                    setState(() {
                      issue.solved = solved ?? false;
                    });
                  },
                ),
              ),
            )
        ],
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
          checkupObject, dm, AppLocalizations.of(context)!.objectInfoLabel)),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FillCheckAnswerPage(
                location: location,
                reportAnswer: widget.answer,
                initialObject: checkupObject,
                initialCheck: null,
              ),
            ));
        dm.update();
      },
    );
  }

  Widget buildTasksView(DataMaster dm) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.addAll(dm.getChecksForLocation(widget.location).map((check) {
      List<CheckupObject> objects =
          dm.getObjectsByCheck(widget.location.checkupObjects, check);
      Iterable<CheckAnswer> answers = widget.answer
          .getAnswersByLocation(widget.location, dm, false)
          .where((element) => element.checkId == check.id);
      return Card(
        child: ListTile(
            leading: const Icon(Icons.check_box),
            title: Text(check.name),
            subtitle: Text(AppLocalizations.of(context)!.checkInfoLabel(
                answers.length,
                objects.length,
                objects.length != 1 ? 's' : '')),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillCheckAnswerPage(
                      initialCheck: check,
                      reportAnswer: widget.answer,
                      location: widget.location,
                      initialObject: null,
                    ),
                  ));
              dm.update();
              setState(() {});
            }),
      );
    }));
    return ListView(children: widgets);
  }
}
