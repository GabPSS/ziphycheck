import 'package:checkup_app/data/data_master.dart';
import 'package:checkup_app/models/location.dart';
import 'package:checkup_app/models/report_answer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              decoration: const InputDecoration(
                labelText: 'Preview',
                border: InputBorder.none,
              ),
              controller: TextEditingController(
                  text: location == null
                      ? reportAnswer.buildString(dm)
                      : reportAnswer.buildLocationString(location!, dm)),
              maxLines: null,
            );
          }),
        ),
      ],
    );
  }
}
