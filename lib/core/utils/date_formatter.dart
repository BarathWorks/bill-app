import 'package:intl/intl.dart';

/// Date formatting utilities for Tamil and English locales
class DateFormatter {
  DateFormatter._();

  // Tamil month names
  static const List<String> tamilMonths = [
    'ஜனவரி', 'பிப்ரவரி', 'மார்ச்', 'ஏப்ரல்', 'மே', 'ஜூன்',
    'ஜூலை', 'ஆகஸ்ட்', 'செப்டம்பர்', 'அக்டோபர்', 'நவம்பர்', 'டிசம்பர்'
  ];

  // Tamil day names
  static const List<String> tamilDays = [
    'திங்கள்', 'செவ்வாய்', 'புதன்', 'வியாழன்', 
    'வெள்ளி', 'சனி', 'ஞாயிறு'
  ];

  /// Format date as DD/MM/YYYY
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date as DD MMM YYYY (e.g., 15 Jan 2026)
  static String formatDateShort(DateTime date, {bool isTamil = false}) {
    if (isTamil) {
      return '${date.day} ${tamilMonths[date.month - 1].substring(0, 3)} ${date.year}';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format date as full string (e.g., Monday, January 15, 2026)
  static String formatDateFull(DateTime date, {bool isTamil = false}) {
    if (isTamil) {
      final dayName = tamilDays[date.weekday - 1];
      final monthName = tamilMonths[date.month - 1];
      return '$dayName, $monthName ${date.day}, ${date.year}';
    }
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  /// Format time as HH:MM AM/PM
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date and time together
  static String formatDateTime(DateTime date, {bool isTamil = false}) {
    return '${formatDateShort(date, isTamil: isTamil)} ${formatTime(date)}';
  }

  /// Get relative time string (e.g., "2 hours ago", "Yesterday")
  static String getRelativeTime(DateTime date, {bool isTamil = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return isTamil ? 'இப்போது' : 'Just now';
        }
        return isTamil 
            ? '${difference.inMinutes} நிமிடங்கள் முன்' 
            : '${difference.inMinutes} min ago';
      }
      return isTamil 
          ? '${difference.inHours} மணி நேரம் முன்' 
          : '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return isTamil ? 'நேற்று' : 'Yesterday';
    } else if (difference.inDays < 7) {
      return isTamil 
          ? '${difference.inDays} நாட்கள் முன்' 
          : '${difference.inDays} days ago';
    } else {
      return formatDateShort(date, isTamil: isTamil);
    }
  }

  /// Get day name from date
  static String getDayName(DateTime date, {bool isTamil = false, bool short = false}) {
    if (isTamil) {
      final name = tamilDays[date.weekday - 1];
      return short ? name.substring(0, 3) : name;
    }
    return short 
        ? DateFormat('EEE').format(date) 
        : DateFormat('EEEE').format(date);
  }

  /// Get month name from date
  static String getMonthName(DateTime date, {bool isTamil = false, bool short = false}) {
    if (isTamil) {
      final name = tamilMonths[date.month - 1];
      return short ? name.substring(0, 3) : name;
    }
    return short 
        ? DateFormat('MMM').format(date) 
        : DateFormat('MMMM').format(date);
  }
}
