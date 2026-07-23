import 'dart:io';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  String localTimezoneName = 'UTC';

  static const _fastEndId = 1001;
  static const _dailyStartId = 1002;
  static const _waterStartId = 1100;
  static const _waterCount = 10;

  static const _details = NotificationDetails(
    iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
  );

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      localTimezoneName = zone.identifier;
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (_) {
      localTimezoneName = 'UTC';
      tz.setLocalLocation(tz.UTC);
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  Future<bool> requestPermission() async {
    if (!_ready) await initialize();
    if (!Platform.isIOS) return true;
    return await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  Future<void> scheduleFastEnd(DateTime end) async {
    if (!_ready) await initialize();
    await _plugin.cancel(id: _fastEndId);
    if (!end.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: _fastEndId,
      title: 'Your eating window is open',
      body: 'You reached your fasting goal. End when it feels right.',
      scheduledDate: tz.TZDateTime.from(end, tz.local),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'fast-complete',
    );
  }

  Future<void> scheduleFastNotifications({
    required DateTime start,
    required DateTime end,
    required bool waterEnabled,
  }) async {
    await cancelFastNotifications();
    await scheduleFastEnd(end);
    if (!waterEnabled) return;
    var reminder = start.add(const Duration(hours: 2));
    var index = 0;
    while (reminder.isBefore(end) && index < _waterCount) {
      if (reminder.isAfter(DateTime.now())) {
        await _plugin.zonedSchedule(
          id: _waterStartId + index,
          title: 'A gentle water reminder',
          body:
              'A glass of water can help you feel comfortable during your fast.',
          scheduledDate: tz.TZDateTime.from(reminder, tz.local),
          notificationDetails: _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'water-reminder',
        );
      }
      reminder = reminder.add(const Duration(hours: 2));
      index += 1;
    }
  }

  Future<void> scheduleDailyStartReminder(int startMinuteOfDay) async {
    if (!_ready) await initialize();
    await _plugin.cancel(id: _dailyStartId);
    final reminderMinute = (startMinuteOfDay - 30) % 1440;
    final now = tz.TZDateTime.now(tz.local);
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminderMinute ~/ 60,
      reminderMinute % 60,
    );
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id: _dailyStartId,
      title: 'Your fast starts in 30 minutes',
      body: 'Wrap up gently when it suits your day.',
      scheduledDate: next,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'fast-start-reminder',
    );
  }

  Future<void> cancelDailyStartReminder() => _plugin.cancel(id: _dailyStartId);

  Future<void> scheduleTaskReminder({
    required String taskId,
    required String title,
    required int weekdaysMask,
    required int minuteOfDay,
  }) async {
    if (!_ready) await initialize();
    await cancelTaskReminder(taskId);
    final now = tz.TZDateTime.now(tz.local);
    for (
      var weekday = DateTime.monday;
      weekday <= DateTime.sunday;
      weekday += 1
    ) {
      if (weekdaysMask & (1 << (weekday - 1)) == 0) continue;
      var daysAhead = (weekday - now.weekday + 7) % 7;
      var date = now.add(Duration(days: daysAhead));
      var scheduled = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        minuteOfDay ~/ 60,
        minuteOfDay % 60,
      );
      if (!scheduled.isAfter(now)) {
        daysAhead += 7;
        date = now.add(Duration(days: daysAhead));
        scheduled = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          minuteOfDay ~/ 60,
          minuteOfDay % 60,
        );
      }
      await _plugin.zonedSchedule(
        id: _taskNotificationId(taskId, weekday),
        title: 'Lighter · $title',
        body: 'A small step is enough. Complete it at your own pace.',
        scheduledDate: scheduled,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'custom-task:$taskId',
      );
    }
  }

  Future<void> cancelTaskReminder(String taskId) async {
    for (
      var weekday = DateTime.monday;
      weekday <= DateTime.sunday;
      weekday += 1
    ) {
      await _plugin.cancel(id: _taskNotificationId(taskId, weekday));
    }
  }

  int _taskNotificationId(String taskId, int weekday) {
    var hash = 0x811C9DC5;
    for (final byte in utf8.encode(taskId)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return 0x20000000 | (hash & 0x0FFFFFF8) | (weekday - 1);
  }

  Future<void> cancelFastNotifications() async {
    await _plugin.cancel(id: _fastEndId);
    for (var index = 0; index < _waterCount; index += 1) {
      await _plugin.cancel(id: _waterStartId + index);
    }
  }
}
