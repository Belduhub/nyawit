import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  NotificationService._init();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permissions for Android 13+
    await _requestPermissions();

    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  /// Schedule all 4 notifications for a reminder
  /// - H-1 hari (24 jam sebelum)
  /// - H-12 jam (12 jam sebelum)
  /// - H-6 jam (6 jam sebelum)
  /// - H-1 jam (1 jam sebelum)
  Future<void> scheduleReminderNotifications({
    required int reminderId,
    required String title,
    required String? description,
    required DateTime reminderDate,
  }) async {
    await initialize();

    final now = DateTime.now();
    
    // Calculate notification times
    final notification24h = reminderDate.subtract(const Duration(hours: 24));
    final notification12h = reminderDate.subtract(const Duration(hours: 12));
    final notification6h = reminderDate.subtract(const Duration(hours: 6));
    final notification1h = reminderDate.subtract(const Duration(hours: 1));

    // Schedule each notification if it's in the future
    if (notification24h.isAfter(now)) {
      await _scheduleNotification(
        id: reminderId * 100 + 1, // Unique ID: reminderId * 100 + offset
        title: '🔔 Reminder: $title',
        body: 'Besok pada ${_formatTime(reminderDate)}. ${description ?? ''}',
        scheduledDate: notification24h,
      );
    }

    if (notification12h.isAfter(now)) {
      await _scheduleNotification(
        id: reminderId * 100 + 2,
        title: '🔔 Reminder: $title',
        body: '12 jam lagi pada ${_formatTime(reminderDate)}. ${description ?? ''}',
        scheduledDate: notification12h,
      );
    }

    if (notification6h.isAfter(now)) {
      await _scheduleNotification(
        id: reminderId * 100 + 3,
        title: '🔔 Reminder: $title',
        body: '6 jam lagi pada ${_formatTime(reminderDate)}. ${description ?? ''}',
        scheduledDate: notification6h,
      );
    }

    if (notification1h.isAfter(now)) {
      await _scheduleNotification(
        id: reminderId * 100 + 4,
        title: '⏰ Reminder: $title',
        body: '1 jam lagi pada ${_formatTime(reminderDate)}! ${description ?? ''}',
        scheduledDate: notification1h,
      );
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Notifikasi untuk reminder pembayaran',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('✅ Scheduled notification $id at $scheduledDate');
    } catch (e) {
      print('❌ Error scheduling notification $id: $e');
    }
  }

  /// Cancel all 4 notifications for a reminder
  Future<void> cancelReminderNotifications(int reminderId) async {
    await _notifications.cancel(reminderId * 100 + 1);
    await _notifications.cancel(reminderId * 100 + 2);
    await _notifications.cancel(reminderId * 100 + 3);
    await _notifications.cancel(reminderId * 100 + 4);
    print('🗑️ Cancelled all notifications for reminder $reminderId');
  }

  /// Show immediate notification (for testing)
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Notifikasi test',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details);
  }

  /// Get all pending notifications (for debugging)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
