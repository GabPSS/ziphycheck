import 'package:ziphycheck/models/checkup_object.dart';
import 'package:flutter/material.dart';

abstract class AnswerPageController {
  bool? get status;
  set status(bool? value);

  late CheckupObject object;

  void toggleStatus(bool from);
  String getLeadingHeaderText(BuildContext context);
  String getTrailingHeaderText(BuildContext context);

  String get objectName;

  void update();
  void next();
  void previous();

  Widget getBody(BuildContext context, Function(Function()) setState);
  Text? getPageTitle();
}
