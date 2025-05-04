import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatDate({required String date, required String format}) {
  try {
    final dateTime = DateTime.parse(date).toLocal();
    final formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  } catch (e) {
    return 'Invalid date';
  }
}

void copyText({
  required BuildContext context,
  required String text,
}) {
  if (text.isNotEmpty) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tracking number copied to clipboard'),
      ),
    );
  }
}

bool isValidUrl(String url) {
  final RegExp regex = RegExp(
    r'^(https?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,}(:\d+)?(\/[^\s]*)?$',
    caseSensitive: false,
  );
  return regex.hasMatch(url);
}
