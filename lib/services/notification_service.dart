import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();
    return granted ?? false;
  }

  // Immediate notifications
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Immediate notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Scheduled notifications
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Recurring notifications
  Future<void> scheduleRecurringNotification({
    required int id,
    required String title,
    required String body,
    required RepeatInterval repeatInterval,
    String? payload,
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'recurring_channel',
        'Recurring Notifications',
        channelDescription: 'Recurring notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      details,
      payload: payload,
    );
  }

  // Task deadline notifications
  Future<void> scheduleTaskDeadlineNotification({
    required String taskId,
    required String taskTitle,
    required DateTime deadline,
  }) async {
    final int notificationId = taskId.hashCode;
    
    // Schedule notification 1 hour before deadline
    final DateTime reminderTime = deadline.subtract(const Duration(hours: 1));
    
    if (reminderTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: notificationId,
        title: 'Task Deadline Reminder',
        body: 'Task "$taskTitle" is due in 1 hour',
        scheduledTime: reminderTime,
        payload: 'task_deadline:$taskId',
      );
    }
  }

  // Streak reminder notifications
  Future<void> scheduleStreakReminder({
    required String streakType,
    required DateTime reminderTime,
  }) async {
    final int notificationId = 'streak_$streakType'.hashCode;
    
    await scheduleNotification(
      id: notificationId,
      title: 'Keep Your Streak Going! 🔥',
      body: 'Don\'t forget to maintain your $streakType streak today',
      scheduledTime: reminderTime,
      payload: 'streak_reminder:$streakType',
    );
  }

  // Daily motivation notifications
  Future<void> scheduleDailyMotivation() async {
    const List<String> motivationalMessages = [
      'Start your day with purpose! 💪',
      'Every small step counts towards your goals 🎯',
      'You\'re making great progress! Keep going 🚀',
      'Today is a new opportunity to grow 🌱',
      'Believe in yourself and your abilities ⭐',
    ];

    final DateTime now = DateTime.now();
    final DateTime tomorrow = DateTime(now.year, now.month, now.day + 1, 9, 0); // 9 AM tomorrow
    
    final String randomMessage = motivationalMessages[now.millisecond % motivationalMessages.length];
    
    await scheduleNotification(
      id: 'daily_motivation'.hashCode,
      title: 'Good Morning!',
      body: randomMessage,
      scheduledTime: tomorrow,
      payload: 'daily_motivation',
    );
  }

  // Pomodoro notifications
  Future<void> schedulePomodoroNotifications({
    required String sessionId,
    required int workMinutes,
    required int breakMinutes,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime workEndTime = now.add(Duration(minutes: workMinutes));
    final DateTime breakEndTime = workEndTime.add(Duration(minutes: breakMinutes));
    
    // Work session end notification
    await scheduleNotification(
      id: 'pomodoro_work_$sessionId'.hashCode,
      title: 'Work Session Complete! 🍅',
      body: 'Time for a $breakMinutes minute break',
      scheduledTime: workEndTime,
      payload: 'pomodoro_break:$sessionId',
    );
    
    // Break end notification
    await scheduleNotification(
      id: 'pomodoro_break_$sessionId'.hashCode,
      title: 'Break Time Over! ⏰',
      body: 'Ready to start your next work session?',
      scheduledTime: breakEndTime,
      payload: 'pomodoro_work:$sessionId',
    );
  }

  // Cancel notifications
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelTaskNotifications(String taskId) async {
    await cancelNotification(taskId.hashCode);
  }

  Future<void> cancelPomodoroNotifications(String sessionId) async {
    await cancelNotification('pomodoro_work_$sessionId'.hashCode);
    await cancelNotification('pomodoro_break_$sessionId'.hashCode);
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Notification tap handler
  void _onNotificationTapped(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    }
  }

  void _handleNotificationPayload(String payload) {
    final List<String> parts = payload.split(':');
    final String type = parts[0];
    
    switch (type) {
      case 'task_deadline':
        // Navigate to task details
        break;
      case 'streak_reminder':
        // Navigate to streak screen
        break;
      case 'daily_motivation':
        // Navigate to home screen
        break;
      case 'pomodoro_break':
      case 'pomodoro_work':
        // Navigate to pomodoro screen
        break;
      default:
        // Handle unknown payload
        break;
    }
  }
}
