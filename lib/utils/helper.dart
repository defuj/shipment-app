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
