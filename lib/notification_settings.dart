import 'package:flutter/material.dart';
import 'package:scheduled_notifications/scheduled_notifications.dart';

import 'time_picker.dart';
import 'schedule_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class NoteSetStateful extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => NoteSet();
}

class NoteSet extends State<NoteSetStateful> {
  _scheduleNotification() async {
    int notificationId = await ScheduledNotifications.scheduleNotification(
        _selectedTime.millisecondsSinceEpoch,
        "Ticker text",
        "Content title",
        "Content");
  }

  static const _platform = const MethodChannel('schedule_notifications_app');

  DateTime _selectedTime = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
          appBar: AppBar(
            title: Text('Saved Quotes'),
          ),
          body: new Column(
            children: [
                    new DateTimeItem(
                    dateTime: _selectedTime,
                        onChanged: (value) {
                         setState(() {
                            _selectedTime = value;
                          });
                        }
                    ),
                    new RaisedButton(
                      child: const Text('SCHEDULE'),
                      onPressed: _scheduleNotification,
                    ),
                    const SizedBox(height: 20.0),
                    new RaisedButton(
                      child: const Text('UNSCHEDULE'),
                      //TODO figure out unscheduling
                      onPressed: null,
                    ),
                  ],
          ));
    }
  }

 
}
