import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils{
  static DateTime dateTimeFromTimeString(String timeString) {
    if(timeString.isEmpty) return DateTime.now();
    try {
      // Define the time format (e.g., "hh:mm a" for 12-hour format with AM/PM)
      DateFormat timeFormat = DateFormat('hh:mm a');

      // Parse the time string into a DateTime object
      DateTime parsedTime = timeFormat.parse(timeString);

      // Combine the parsed time with today's date
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime? parseDateFromString(String dateString) {
    try {
      // Define the date format to match the input string
      DateFormat dateFormat = DateFormat("dd MMM yyyy");

      // Parse the string into a DateTime object
      return dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  static bool isStartDateLessThanEndDate(DateTime? start, DateTime? end){
    if(start == null || end == null) return false;
    return start.isBefore(end) || start.isAtSameMomentAs(end);
  }

  static bool isStartTimeLessThanEndTime(DateTime start, DateTime end){
    return start.isBefore(end) || start.isAtSameMomentAs(end);
  }

  static List<DateTime> generateDateRange(DateTime start, DateTime end) {
    List<DateTime> range = [];
    DateTime current = DateTime(start.year, start.month, start.day); // Normalize to date only
    DateTime normalizedEnd = DateTime(end.year, end.month, end.day); // Normalize to date only

    while (current.isBefore(normalizedEnd) || current.isAtSameMomentAs(normalizedEnd)) {
      range.add(current);
      current = current.add(Duration(days: 1));
    }
    return range;
  }

  static List<String> extractDaysFromRange(List<DateTime> dateRange) {
    return dateRange.map((date) => DateFormat('EEE').format(date)).toList(); // EEE = Mon, Tue, etc.
  }


  static String timeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return difference.inSeconds <= 1 ? 'just now' : '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return difference.inMinutes == 1 ? '1 min ago' : '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

}