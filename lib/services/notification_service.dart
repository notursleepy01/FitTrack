import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  Future<void> scheduleDailyWorkoutReminder(TimeOfDay time) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10, // A unique ID for this notification
        channelKey: 'daily_workout_reminder_channel',
        title: 'Time to Work Out!',
        body: 'Don\'t forget to log your session in FitTrack today. Let\'s go!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        repeats: true, // This makes it a daily reminder
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  // Request permission from the user to show notifications
  Future<void> requestPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
