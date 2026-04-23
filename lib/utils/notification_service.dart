import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_happy_work_place/constants/app_icons.dart';
import 'package:my_happy_work_place/constants/app_routes.dart';
import 'package:my_happy_work_place/utils/app_router.dart';
import 'package:my_happy_work_place/utils/preference_helper.dart';

import '../constants/app_constants.dart';
import '../main.dart';

class NotificationService {
  NotificationService._internal();

  static NotificationService instance = NotificationService._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return instance;
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    ///request permissions
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    initializeLocalNotifications();
    listenForegroundMessages();
    checkBackgroundMessageOnClick();
    checkTerminatedMessageOnClick();
    getToken();
  }

  listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message: message);
    });
  }

  checkBackgroundMessageOnClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
       navigateToNotificationsPage();
    });
  }

  Future<String> getToken() async {
    String? token = await messaging.getToken();
    SharedPreferencesHelper.saveFcmToken(token ?? '');
    return token ?? AppConstants.emptyString;
  }

  Future<void> checkTerminatedMessageOnClick() async {
    RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      navigateToNotificationsPage();
    }
  }

  initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_icon');
    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void onReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {

  }

  void onDidReceiveLocalNotification(NotificationResponse details) {
    if (details.payload != null) {
      navigateToNotificationsPage();
    }
  }

  showLocalNotification({required RemoteMessage message}) async {
    AndroidNotification? android = message.notification?.android;

    if (message.notification != null && android != null) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'default_notification_channel_id',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications',
        icon: '@drawable/app_icon',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
          message.notification!.hashCode,
          message.notification?.title,
          message.notification?.body,
          notificationDetails,
          payload: jsonEncode(message.data));
    }
  }

  navigateToNotificationsPage() async {
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      AppRouter.pushNamed(context: context, route: AppRoutes.notifications);
    }
  }

}
