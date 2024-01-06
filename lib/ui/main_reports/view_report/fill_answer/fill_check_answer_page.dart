import 'package:ziphycheck/data/data_master.dart';
import 'package:ziphycheck/models/check.dart';
import 'package:ziphycheck/models/checkup_object.dart';
import 'package:ziphycheck/models/location.dart';
import 'package:ziphycheck/models/report_answer.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/object_page_controllers/answer_page_controller.dart';
import 'package:ziphycheck/ui/main_reports/view_report/fill_answer/object_page_controllers/overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'object_page_controllers/details_controller.dart';
import 'widgets/answer_button.dart';

class FillCheckAnswerPage extends StatefulWidget {
  final ReportAnswer reportAnswer;
  final CheckupObject? initialObject;
  final Check? initialCheck;
  final Location location;

  const FillCheckAnswerPage({
    super.key,
    required this.reportAnswer,
    required this.initialObject,
    required this.initialCheck,
    required this.location,
  });

  @override
  State<FillCheckAnswerPage> createState() => _FillCheckAnswerPageState();
}

class _FillCheckAnswerPageState extends State<FillCheckAnswerPage> {
  bool onDetails = false;
  late AnswerPageController controller;

  @override
  void initState() {
    var dm = Provider.of<DataMaster>(context, listen: false);
    if (widget.initialCheck != null) {
      controller = DetailsController(
          location: widget.location,
          initialCheck: widget.initialCheck!,
          reportAnswer: widget.reportAnswer,
          dm: dm);
      onDetails = true;
    } else {
      if (widget.initialObject != null) {
        controller = OverviewController(
            location: widget.location,
            initialObject: widget.initialObject!,
            reportAnswer: widget.reportAnswer,
            dm: dm);
      } else {
        throw UnimplementedError();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: controller.getPageTitle(),
        leading: IconButton(
            onPressed: () {
              controller.update();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              getHeader(),
              controller.getBody(context, setState),
            ],
          )),
          if (MediaQuery.of(context).viewInsets.bottom < 50) getAnswerButtons(),
        ],
      ),
    );
  }

  Column getAnswerButtons() {
    return Column(
      children: [
        Row(
          children: [
            AnswerButton(
              label: Text(AppLocalizations.of(context)!.noFillingButtonLabel),
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => controller.toggleStatus(false)),
              backgroundColor: const Color.fromARGB(255, 242, 145, 145),
              checked: !(controller.status ?? true),
            ),
            AnswerButton(
                label: Text(onDetails
                    ? AppLocalizations.of(context)!.yesFillingButtonLabel
                    : AppLocalizations.of(context)!.yesToAllFillingButtonLabel),
                icon: Icon(onDetails ? Icons.done : Icons.done_all),
                onPressed: () => setState(() => controller.toggleStatus(true)),
                backgroundColor: const Color.fromARGB(255, 169, 219, 151),
                checked: controller.status ?? false),
          ],
        ),
        Row(
          children: [
            AnswerButton(
              label: Text(
                  AppLocalizations.of(context)!.previousFillingButtonLabel),
              icon: const Icon(Icons.navigate_before),
              onPressed: () => setState(() => controller.previous()),
            ),
            AnswerButton(
              label: Text(AppLocalizations.of(context)!.nextFillingButtonLabel),
              icon: const Icon(Icons.navigate_next),
              onPressed: () => setState(() => controller.next()),
            ),
          ],
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      children: [
        Expanded(
            child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(controller.getLeadingHeaderText(context)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  controller.objectName,
                  textScaler: const TextScaler.linear(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(controller.getTrailingHeaderText(context)),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
