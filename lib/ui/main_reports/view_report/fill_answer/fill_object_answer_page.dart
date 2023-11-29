import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/check.dart';
import 'package:checkup_app/models/check_answer.dart';
import 'package:checkup_app/models/checkup_object.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FillObjectAnswerpage extends StatefulWidget {
  final ReportAnswer answer;
  final CheckupObject initialObject;
  final AnswerPageType type;

  const FillObjectAnswerpage(
      {super.key,
      required this.answer,
      required this.initialObject,
      this.type = AnswerPageType.singleObjectOverview});

  @override
  State<FillObjectAnswerpage> createState() => _FillObjectAnswerpageState();
}

enum AnswerPageType { singleObjectOverview, detailsView }

class _FillObjectAnswerpageState extends State<FillObjectAnswerpage> {
  late CheckupObject object;
  late DataMaster dm;

  List<Check> get checks => dm.getChecksForObjectType(object.getObjectType(dm));
  List<CheckAnswer> get answers => widget.answer.getAnswersByObject(object);

  List<CheckAnswer> getAnswersThatAre(bool status) =>
      answers.where((element) => element.status == status).toList();

  bool? get status {
    //TODO: Handle status differently when changing to detailsview
    if (getAnswersThatAre(false).isNotEmpty) {
      return false;
    }

    if (getAnswersThatAre(true).length == checks.length) {
      return true;
    }
    return null;
  }

  set status(bool? value) {
    if (value == null) {
      widget.answer.checkAnswers
          .removeWhere((element) => element.objectId == object.id);
      return;
    }

    if (value) {
      //TODO: Set all checks to true in reportAnswer
    } else {
      //TODO: Set temp status to false?
    }
  }

  void toggleStatus(bool from) {
    setState(() {
      if (status == null || status == !from) {
        status = from;
        return;
      }

      status = null;
      return;
    });
  }

  @override
  void initState() {
    dm = Provider.of<DataMaster>(context, listen: false);
    object = widget.initialObject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              getHeader(),
              getContent(),
            ],
          )),
          getAnswerButtons(),
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
              onPressed: () {
                toggleStatus(false);
              },
              backgroundColor: const Color.fromARGB(255, 242, 145, 145),
              checked: !(status ?? true),
            ),
            AnswerButton(
                label: Text(switch (widget.type) {
                  AnswerPageType.detailsView => 'YES',
                  AnswerPageType.singleObjectOverview => 'YES TO ALL',
                }),
                icon: Icon(switch (widget.type) {
                  AnswerPageType.detailsView => Icons.done,
                  AnswerPageType.singleObjectOverview => Icons.done_all,
                }),
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 169, 219, 151),
                checked: status ?? false),
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
                child: Text(widget.answer
                    .formatCheckupObjectInfo(object, dm, "Object %ID/%OB")),
              ), //TODO: Update this please
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  object.getFullName(dm),
                  textScaleFactor: 2,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                    'TO BE ADDED'), //TODO: Add option to see yesterday's answers right from here
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget getContent() {
    return const Column(
      children: [
        Text('To be added!') //TODO: Implement content
      ],
    );
  }
}

class AnswerButton extends StatelessWidget {
  final Widget label;
  final Widget icon;
  final Function() onPressed;
  final bool checked;
  final Color? backgroundColor;

  const AnswerButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: label,
        style: ButtonStyle(
          iconSize: const MaterialStatePropertyAll(48),
          shape: const MaterialStatePropertyAll(LinearBorder()),
          fixedSize: const MaterialStatePropertyAll(Size(0, 120)),
          backgroundColor:
              checked ? MaterialStatePropertyAll(backgroundColor) : null,
        ),
      ),
    );
  }
}
