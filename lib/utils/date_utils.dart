// Date formatting

class DateUtils {
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays < 7;
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime getEndOfWeek(DateTime date) {
    return date.add(Duration(days: 7 - date.weekday));
  }

  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static int getDaysInMonth(DateTime date) {
    return getEndOfMonth(date).day;
  }

  static bool isStreakActive(DateTime lastReadDate) {
    final now = DateTime.now();
    return now.difference(lastReadDate).inDays == 1;
  }

  static int calculateStreak(List<DateTime> readingDates) {
    if (readingDates.isEmpty) return 0;

    readingDates.sort((a, b) => b.compareTo(a));
    int streak = 1;

    for (int i = 0; i < readingDates.length - 1; i++) {
      final current = readingDates[i];
      final next = readingDates[i + 1];
      final difference = current.difference(next);

      if (difference.inDays == 1) {
        streak++;
      } else if (difference.inDays > 1) {
        break;
      }
    }

    return streak;
  }
}
