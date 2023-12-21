import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class PreviewTextField extends StatelessWidget {
  const PreviewTextField(
      {super.key, required this.reportAnswer, this.location});

  final ReportAnswer reportAnswer;
  final Location? location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<DataMaster>(builder: (context, dm, child) {
            return TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.previewFieldLabel,
                border: InputBorder.none,
              ),
              controller: TextEditingController(
                  text: location == null
                      ? reportAnswer.buildString(
                          dm,
                          Provider.of<Settings>(context, listen: false)
                              .getReportOutputLocale(
                                  Localizations.localeOf(context)))
                      : reportAnswer.buildLocationString(
                          location!,
                          dm,
                          Provider.of<Settings>(context, listen: false)
                              .getReportOutputLocale(
                                  Localizations.localeOf(context)))),
              maxLines: null,
            );
          }),
        ),
      ],
    );
  }
}
