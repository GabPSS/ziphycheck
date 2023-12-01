import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:checkup_app/ui/main_reports/view_report/fill_answer/widgets/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FillCheckAnswerDetailsPage extends StatefulWidget {
  final Check initialCheck;
  final ReportAnswer reportAnswer;
  final Location location;

  const FillCheckAnswerDetailsPage(
      {super.key,
      required this.initialCheck,
      required this.reportAnswer,
      required this.location});

  @override
  State<FillCheckAnswerDetailsPage> createState() =>
      _FillCheckAnswerDetailsPageState();
}

class _FillCheckAnswerDetailsPageState
    extends State<FillCheckAnswerDetailsPage> {
  late DataMaster dm;

  late Check currentCheck;
  late CheckupObject? currentObject;

  List<CheckupObject> get objects => widget.location.checkupObjects
      .where((element) =>
          element.getObjectType(dm)?.checkIds.contains(currentCheck.id) ??
          false)
      .toList();

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    currentCheck = widget.initialCheck;
    currentObject = objects.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              dm.update();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(currentCheck.name),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              getHeader(),
              // getContent(), //TODO: Implement content (and everything from the overview page)
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
              label: const Text('NO'),
              icon: const Icon(Icons.close),
              onPressed: () {},
              // onPressed: () => toggleStatus(false),
              backgroundColor: const Color.fromARGB(255, 242, 145, 145),
              // checked: !(status ?? true),
              checked: false,
            ),
            AnswerButton(
                label: const Text('YES TO ALL'),
                icon: const Icon(Icons.done_all),
                // onPressed: () => toggleStatus(true),
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 169, 219, 151),
                // checked: status ?? false),
                checked: false),
          ],
        ),
        Row(
          children: [
            AnswerButton(
              label: const Text('PREVIOUS'),
              icon: const Icon(Icons.navigate_before),
              onPressed: () {},
            ),
            AnswerButton(
              label: const Text('NEXT'),
              icon: const Icon(Icons.navigate_next),
              onPressed: () {},
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
                child: Text(currentObject != null
                    ? widget.reportAnswer.formatCheckupObjectInfo(
                        currentObject!, dm, "Object %ID/%OB")
                    : ""),
              ), //TODO: Update this please
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  currentObject?.getFullName(dm) ?? "No object",
                  textScaleFactor: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(currentObject != null
                    ? widget.reportAnswer.formatCheckupObjectInfo(
                        currentObject!, dm, "%AW/%TT check%sTT, %IS issue%sIS")
                    : ""),

                //TODO: Add option to see yesterday's answers right from here
              ),
            ],
          ),
        )),
      ],
    );
  }
}
