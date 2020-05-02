  
import 'dart:async';
import 'package:flutter/services.dart';

class ScheduleNotifications {

  static const MethodChannel _channel =  const MethodChannel('schedule_notifications');

  // String text: Text to be showed in notification.
  // DateTime when: When notification should be send.
  // If *repeatAt* is empty, the tool will use this value.
  // List<int> repeatAt: A list of weekdays [1..7]. When 1 is Monday (see DateTime weekday).
  static Future<dynamic> schedule(String text, DateTime when, List<int> repeatAt) {
    return _channel.invokeMethod('scheduleNotification', [text, when.toString(), repeatAt]);
  }

  static Future<dynamic> unschedule() {
    return _channel.invokeMethod('unscheduleNotifications');
  }

  // Android only
  static Future<dynamic> setNotificationIcon(int icon) {
    return _channel.invokeMethod('setNotificationIcon', [icon]);
  }

  // iOS only
  static Future<dynamic> requestAuthorization() {
    return _channel.invokeMethod('requestAuthorization');
  }

}