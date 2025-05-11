import 'package:flutter/material.dart';

Widget buildFloatingButton({
  required String title,
  required Widget icon,
  Function? onPressed,
  Color? color = Colors.red,
}) {
  return FloatingActionButton(
    backgroundColor: color,
    onPressed: () {
      onPressed?.call();
    },
    tooltip: title,
    child: icon,
  );
}
