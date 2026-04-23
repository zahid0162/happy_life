import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';

class UrlLauncher{
  static Future<void> openCalendar() async {
    // Define URLs for different platforms
    const androidCalendarUrl = 'content://com.android.calendar/time'; // Android's calendar intent
    const iosCalendarUrl = 'calshow://'; // iOS calendar URL scheme

    try {
      if (Platform.isAndroid) {
        // Open Android calendar
        final uri = Uri.parse(androidCalendarUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not open the Android calendar app.';
        }
      } else if (Platform.isIOS) {
        // Open iOS calendar
        final uri = Uri.parse(iosCalendarUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not open the iOS calendar app.';
        }
      } else {
        throw 'Unsupported platform.';
      }
    } catch (e) {
      debugPrint('Error opening calendar: $e');
    }
  }

  static void openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Opens in a browser or app
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}