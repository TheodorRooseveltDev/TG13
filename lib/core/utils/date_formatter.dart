import 'package:intl/intl.dart';

/// Date and time formatting utilities for Big Boss Fishing
class DateFormatter {
  // Date Formats
  static final DateFormat _shortDate = DateFormat('MM/dd/yy');
  static final DateFormat _mediumDate = DateFormat('MMM dd, yyyy');
  static final DateFormat _longDate = DateFormat('MMMM dd, yyyy');
  static final DateFormat _fullDate = DateFormat('EEEE, MMMM dd, yyyy');
  
  // Time Formats
  static final DateFormat _shortTime = DateFormat('h:mm a');
  static final DateFormat _mediumTime = DateFormat('h:mm:ss a');
  
  // Combined Formats
  static final DateFormat _shortDateTime = DateFormat('MM/dd/yy h:mm a');
  static final DateFormat _mediumDateTime = DateFormat('MMM dd, yyyy h:mm a');
  static final DateFormat _longDateTime = DateFormat('MMMM dd, yyyy h:mm a');
  
  // Database Format (ISO 8601)
  static final DateFormat _databaseFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  
  // Month and Year
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _shortMonthYear = DateFormat('MMM yyyy');
  
  /// Format date as short format (MM/dd/yy)
  static String shortDate(DateTime date) {
    return _shortDate.format(date);
  }
  
  /// Format date as medium format (MMM dd, yyyy)
  static String mediumDate(DateTime date) {
    return _mediumDate.format(date);
  }
  
  /// Format date as long format (MMMM dd, yyyy)
  static String longDate(DateTime date) {
    return _longDate.format(date);
  }
  
  /// Format date as full format (EEEE, MMMM dd, yyyy)
  static String fullDate(DateTime date) {
    return _fullDate.format(date);
  }
  
  /// Format time as short format (h:mm a)
  static String shortTime(DateTime date) {
    return _shortTime.format(date);
  }
  
  /// Format time as medium format (h:mm:ss a)
  static String mediumTime(DateTime date) {
    return _mediumTime.format(date);
  }
  
  /// Format datetime as short format (MM/dd/yy h:mm a)
  static String shortDateTime(DateTime date) {
    return _shortDateTime.format(date);
  }
  
  /// Format datetime as medium format (MMM dd, yyyy h:mm a)
  static String mediumDateTime(DateTime date) {
    return _mediumDateTime.format(date);
  }
  
  /// Format datetime as long format (MMMM dd, yyyy h:mm a)
  static String longDateTime(DateTime date) {
    return _longDateTime.format(date);
  }
  
  /// Format date for database storage (ISO 8601)
  static String databaseFormat(DateTime date) {
    return _databaseFormat.format(date);
  }
  
  /// Parse date from database format
  static DateTime parseDatabaseFormat(String dateString) {
    return _databaseFormat.parse(dateString);
  }
  
  /// Format month and year (MMMM yyyy)
  static String monthYear(DateTime date) {
    return _monthYear.format(date);
  }
  
  /// Format month and year short (MMM yyyy)
  static String shortMonthYear(DateTime date) {
    return _shortMonthYear.format(date);
  }
  
  /// Get relative time string (e.g., "2 days ago", "Just now")
  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  /// Get time of day category (Early Morning, Morning, etc.)
  static String timeOfDayCategory(DateTime date) {
    final hour = date.hour;
    
    if (hour >= 5 && hour < 8) {
      return 'Early Morning';
    } else if (hour >= 8 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 15) {
      return 'Midday';
    } else if (hour >= 15 && hour < 18) {
      return 'Afternoon';
    } else if (hour >= 18 && hour < 21) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }
  
  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }
  
  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek) && date.isBefore(endOfWeek);
  }
  
  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
  
  /// Get smart date string (Today, Yesterday, or formatted date)
  static String smartDate(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isThisWeek(date)) {
      return DateFormat('EEEE').format(date); // Day of week
    } else if (isThisMonth(date)) {
      return mediumDate(date);
    } else {
      return mediumDate(date);
    }
  }
  
  /// Get countdown string (e.g., "In 2 days", "Tomorrow")
  static String countdown(DateTime futureDate) {
    final now = DateTime.now();
    final difference = futureDate.difference(now);
    
    if (difference.isNegative) {
      return 'Past';
    } else if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'In ${difference.inMinutes} minutes';
      }
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'In $weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'In $months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'In $years ${years == 1 ? 'year' : 'years'}';
    }
  }
  
  /// Get season from date
  static String season(DateTime date) {
    final month = date.month;
    
    if (month >= 3 && month <= 5) {
      return 'Spring';
    } else if (month >= 6 && month <= 8) {
      return 'Summer';
    } else if (month >= 9 && month <= 11) {
      return 'Fall';
    } else {
      return 'Winter';
    }
  }
  
  /// Format duration (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'Good Morning, Captain';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon, Captain';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening, Captain';
    } else {
      return 'Still Fishing, Captain?';
    }
  }

  /// Format date (alias for mediumDate)
  static String formatDate(DateTime date) {
    return mediumDate(date);
  }

  /// Format relative time (alias for relativeTime)
  static String formatRelative(DateTime date) {
    return relativeTime(date);
  }
}
