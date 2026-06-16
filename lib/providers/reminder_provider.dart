import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../models/reminder_model.dart';

class ReminderProvider with ChangeNotifier {
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  final DatabaseService _dbHelper = DatabaseService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  // Load reminders for a user
  Future<void> loadReminders(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reminders = await _dbHelper.getRemindersByUser(userId);
    } catch (e) {
      print('Error loading reminders: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add new reminder
  Future<bool> addReminder({
    required int userId,
    required String title,
    String? description,
    required DateTime reminderDate,
  }) async {
    try {
      final reminder = Reminder(
        userId: userId,
        title: title,
        description: description,
        reminderDate: reminderDate,
      );

      final id = await _dbHelper.createReminder(reminder);
      
      // Schedule 4 notifications (H-24, H-12, H-6, H-1)
      if (id > 0) {
        await _notificationService.scheduleReminderNotifications(
          reminderId: id,
          title: title,
          description: description,
          reminderDate: reminderDate,
        );
      }
      
      await loadReminders(userId);
      return true;
    } catch (e) {
      print('Error adding reminder: $e');
      return false;
    }
  }

  // Update reminder
  Future<bool> updateReminder(Reminder reminder) async {
    try {
      await _dbHelper.updateReminder(reminder);
      
      // Cancel old notifications and reschedule if not completed
      if (reminder.id != null) {
        await _notificationService.cancelReminderNotifications(reminder.id!);
        
        if (!reminder.isCompleted) {
          await _notificationService.scheduleReminderNotifications(
            reminderId: reminder.id!,
            title: reminder.title,
            description: reminder.description,
            reminderDate: reminder.reminderDate,
          );
        }
      }
      
      await loadReminders(reminder.userId);
      return true;
    } catch (e) {
      print('Error updating reminder: $e');
      return false;
    }
  }

  // Delete reminder
  Future<bool> deleteReminder(int reminderId, int userId) async {
    try {
      // Cancel all notifications for this reminder
      await _notificationService.cancelReminderNotifications(reminderId);
      
      await _dbHelper.deleteReminder(reminderId);
      await loadReminders(userId);
      return true;
    } catch (e) {
      print('Error deleting reminder: $e');
      return false;
    }
  }

  // Toggle reminder completion
  Future<bool> toggleCompletion(Reminder reminder) async {
    final updatedReminder = reminder.copyWith(
      isCompleted: !reminder.isCompleted,
    );
    return await updateReminder(updatedReminder);
  }
}
