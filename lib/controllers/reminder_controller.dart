import '../services/database_service.dart';
import '../models/reminder_model.dart';

/// ReminderController - CONTROLLER layer dalam MVC
/// Mengelola business logic untuk reminder pembayaran
class ReminderController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  /// Load reminders untuk user tertentu
  Future<void> loadReminders(int userId) async {
    _isLoading = true;
    
    try {
      _reminders = await _dbService.getRemindersByUser(userId);
    } catch (e) {
      print('Error loading reminders: $e');
    }
    
    _isLoading = false;
  }

  /// Add new reminder
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

      final id = await _dbService.createReminder(reminder);
      
      // Schedule notification
      if (id > 0) {
        await _scheduleNotification(id, title, description, reminderDate);
      }
      
      await loadReminders(userId);
      return true;
    } catch (e) {
      print('Error adding reminder: $e');
      return false;
    }
  }

  /// Update reminder
  Future<bool> updateReminder(Reminder reminder) async {
    try {
      await _dbService.updateReminder(reminder);
      
      // Reschedule notification if not completed
      if (!reminder.isCompleted && reminder.id != null) {
        await _scheduleNotification(
          reminder.id!,
          reminder.title,
          reminder.description,
          reminder.reminderDate,
        );
      }
      
      await loadReminders(reminder.userId);
      return true;
    } catch (e) {
      print('Error updating reminder: $e');
      return false;
    }
  }

  /// Delete reminder
  Future<bool> deleteReminder(int reminderId, int userId) async {
    try {
      await _dbService.deleteReminder(reminderId);
      await loadReminders(userId);
      return true;
    } catch (e) {
      print('Error deleting reminder: $e');
      return false;
    }
  }

  /// Toggle reminder completion
  Future<bool> toggleCompletion(Reminder reminder) async {
    final updatedReminder = reminder.copyWith(
      isCompleted: !reminder.isCompleted,
    );
    return await updateReminder(updatedReminder);
  }

  /// Schedule notification (placeholder)
  Future<void> _scheduleNotification(
    int id,
    String title,
    String? description,
    DateTime scheduledDate,
  ) async {
    // TODO: Implement with flutter_local_notifications
    print('Scheduling notification for $title at $scheduledDate');
  }

  /// Get upcoming reminders
  List<Reminder> getUpcomingReminders() {
    final now = DateTime.now();
    return _reminders
        .where((r) => !r.isCompleted && r.reminderDate.isAfter(now))
        .toList();
  }

  /// Get overdue reminders
  List<Reminder> getOverdueReminders() {
    final now = DateTime.now();
    return _reminders
        .where((r) => !r.isCompleted && r.reminderDate.isBefore(now))
        .toList();
  }

  /// Get completed reminders
  List<Reminder> getCompletedReminders() {
    return _reminders.where((r) => r.isCompleted).toList();
  }
}
