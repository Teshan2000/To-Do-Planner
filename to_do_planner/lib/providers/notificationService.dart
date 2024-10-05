import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notificationservice {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotifications(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Task Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showRepeatingNotifications(
    int id,
    String title,
    String body,
    RepeatInterval repeatInterval,
  ) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'repeat_channel', 
      'Repeating Reminders',
      importance: Importance.max,
      priority: Priority.high
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails
    );

    await _notificationsPlugin.periodicallyShow(
      id, 
      title, 
      body, 
      repeatInterval, 
      platformDetails,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
