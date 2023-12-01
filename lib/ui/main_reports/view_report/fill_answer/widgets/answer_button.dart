import 'package:flutter/material.dart';

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
