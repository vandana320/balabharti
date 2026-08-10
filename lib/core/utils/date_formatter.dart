import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String format(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";

    try {
      final date = DateTime.parse(isoDate).toLocal();

      return DateFormat("dd/MM/yyyy HH:mm").format(date);
    } catch (_) {
      return isoDate;
    }
  }
}
