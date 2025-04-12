// Text processing

class TextUtils {
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String formatPageNumber(int page) {
    return 'Page $page';
  }

  static String formatProgress(int current, int total) {
    final percentage = (current / total * 100).toStringAsFixed(1);
    return '$percentage%';
  }

  static String formatReadingTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return remainingMinutes > 0 ? '$hours h $remainingMinutes min' : '$hours h';
    }
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  static String formatBookStats(int pages, int minutes) {
    return '${pages} pages • ${formatReadingTime(minutes)}';
  }

  static String formatStreak(int days) {
    return '$days ${days == 1 ? 'day' : 'days'}';
  }

  static String formatBookCount(int count) {
    return '$count ${count == 1 ? 'book' : 'books'}';
  }
}