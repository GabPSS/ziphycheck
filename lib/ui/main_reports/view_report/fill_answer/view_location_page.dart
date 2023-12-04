import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/location_answer.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/fill_location_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'widgets/preview_text_field.dart';

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
          //TODO: #21 Add new redesign widgets
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
              label: Text(AppLocalizations.of(context)!.viewChecksButtonLabel),
              icon: const Icon(Icons.exit_to_app),
            ),
          ),
          PreviewTextField(
              reportAnswer: widget.reportAnswer, location: widget.location)
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
          return Text(AppLocalizations.of(context)!.locationInfoLabel(
              info['checked'] ?? 0, info['total'] ?? 0, info['issues'] ?? 0));
        },
      ),
    );
  }

  Widget buildIssueReporter() {
    return Column(
      children: [
        SwitchListTile(
          value: !locationAnswer.status,
          title: Text(AppLocalizations.of(context)!.reportIssueFieldLabel),
          subtitle:
              Text(AppLocalizations.of(context)!.reportIssueFieldDescription),
          onChanged: (value) {
            setState(() {
              locationAnswer.status = !value;
              if (value == false) {
                locationAnswer.notes = null;
              }
              Provider.of<DataMaster>(context, listen: false).update();
            });
          },
        ),
        if (!locationAnswer.status)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              return TextField(
                controller: TextEditingController(text: locationAnswer.notes),
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .issueDescriptionFieldLabel),
                maxLines: null,
                onChanged: (value) {
                  locationAnswer.notes =
                      value.trim() == "" ? null : value.trim();
                  Provider.of<DataMaster>(context, listen: false).update();
                  //TODO: #22 Why issues and notes? Why not a single thing?
                },
              );
            }),
          )
      ],
    );
  }
}
