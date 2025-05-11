import 'package:flutter/material.dart';

Widget buildButton({
  required String title,
  Function? onPressed,
  Color? color = Colors.blue,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () => onPressed?.call(),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}
