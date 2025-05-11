import 'package:flutter/material.dart';

Widget buildFloatingButton({
  required String title,
  required Widget icon,
  Function? onPressed,
  Color? color = Colors.blue,
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
