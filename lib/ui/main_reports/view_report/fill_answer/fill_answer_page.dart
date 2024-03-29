import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:ziphycheck/settings/settings.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/view_location_page.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../../../../models/report.dart';
import 'widgets/preview_text_field.dart';

class FillAnswerPage extends StatefulWidget {
  final ReportAnswer reportAnswer;

  const FillAnswerPage({super.key, required this.reportAnswer});

  @override
  State<FillAnswerPage> createState() => _FillAnswerPageState();
}

class _FillAnswerPageState extends State<FillAnswerPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewAnswerWindowTitle),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                dm.removeObject(widget.reportAnswer);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => widget.reportAnswer.share(
                dm,
                Provider.of<Settings>(context, listen: false)
                    .getReportOutputLocale(Localizations.localeOf(context))),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                dm.update();
              },
              child: Text(AppLocalizations.of(context)!.saveButtonLabel))
        ],
      ),
      body: ListView(children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DateTimeFormField(
                initialValue: widget.reportAnswer.answerDate,
                decoration: InputDecoration(
                  icon: const Icon(Icons.today),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.dateTimeFieldLabel,
                ),
                onDateSelected: (value) {
                  widget.reportAnswer.answerDate = value;
                },
                mode: DateTimeFieldPickerMode.dateAndTime,
              ),
            )),
          ],
        ),
        for (var location in baseReport.locations)
          Card(
            child: ListTile(
              leading: const Icon(Icons.place),
              title: Text(location.name),
              subtitle: Consumer<DataMaster>(builder: (context, dm, child) {
                Map<String, int> info =
                    location.getInfo(widget.reportAnswer, dm);
                return Text(AppLocalizations.of(context)!.locationInfoLabel(
                    info['checked'] ?? 0,
                    info['total'] ?? 0,
                    info['issues'] ?? 0));
              }),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewLocationPage(
                              location: location,
                              reportAnswer: widget.reportAnswer,
                            )));
                dm.update();
              },
            ),
          ),
        PreviewTextField(reportAnswer: widget.reportAnswer),
      ]),
    );
  }
}
