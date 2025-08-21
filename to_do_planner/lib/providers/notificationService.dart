import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {}

  static Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNotification({String? title, String? body}) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      'channel_Id',
      'Reminders',
      channelDescription: 'This channel is for task reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(''),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('done_action', 'Done'),
        AndroidNotificationAction('dismiss_action', 'Dismiss'),
        AndroidNotificationAction('postpone_action', 'Postpone'),
      ]
    ));

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  static Future<void> scheduleNotification(
      {String? title,
      String? body,
      IconData? category,
      DateTime? scheduledDate,
      String? repeat}) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      'channel_Id',
      'Reminders',
      channelDescription: 'This channel is for task reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(''),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('done_action', 'Done'),
        AndroidNotificationAction('dismiss_action', 'Dismiss'),
        AndroidNotificationAction('postpone_action', 'Postpone'),
      ]
    ));

    DateTimeComponents? repeatInterval;

    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate!, tz.local);

    if (repeat != null) {
      switch (repeat) {
        case 'Hourly':
          await flutterLocalNotificationsPlugin.periodicallyShow(
            0, title, body, RepeatInterval.everyMinute, 
            platformChannelSpecifics, 
            androidScheduleMode: AndroidScheduleMode.alarmClock
          );
          return;
        case 'Daily':
          await flutterLocalNotificationsPlugin.zonedSchedule(
            0, title, body,
            tzScheduledDate, platformChannelSpecifics, 
            matchDateTimeComponents: DateTimeComponents.time,
            androidScheduleMode: AndroidScheduleMode.alarmClock, 
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          return;
        case 'Weekly':
          await flutterLocalNotificationsPlugin.zonedSchedule(
            0, title, body,
            tzScheduledDate, platformChannelSpecifics,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          return;
        case 'Monthly':
          await flutterLocalNotificationsPlugin.zonedSchedule(
            0, title, body,
            tzScheduledDate, platformChannelSpecifics,
            matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          return;
        case 'Yearly':
          await flutterLocalNotificationsPlugin.zonedSchedule(
            0, title, body,
            tzScheduledDate, platformChannelSpecifics,
            matchDateTimeComponents: DateTimeComponents.dateAndTime, 
            androidScheduleMode: AndroidScheduleMode.alarmClock,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
          return;
      }
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body,
      tzScheduledDate, platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }
}
