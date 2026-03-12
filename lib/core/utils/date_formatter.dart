import 'package:intl/intl.dart';

class DateFormatter {
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, y').format(date);
  }

  static String fullDate(DateTime date) =>
      DateFormat('MMMM d, yyyy • h:mm a').format(date);

  static String shortDate(DateTime date) =>
      DateFormat('MMM d, yyyy').format(date);
}
