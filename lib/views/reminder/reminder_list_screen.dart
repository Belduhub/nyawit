import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../utils/constants.dart';
import 'add_reminder_screen.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await Provider.of<ReminderProvider>(context, listen: false)
        .loadReminders(authProvider.currentUser!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Reminder Pembayaran', style: AppTextStyles.heading3),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryGreen),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, _) {
          final reminders = reminderProvider.reminders;

          if (reminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada reminder',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final isPast = reminder.reminderDate.isBefore(DateTime.now());

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: reminder.isCompleted
                          ? AppColors.accentGreen.withValues(alpha: 0.2)
                          : isPast
                              ? AppColors.accentRed.withValues(alpha: 0.2)
                              : AppColors.accentGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      reminder.isCompleted
                          ? Icons.check_circle
                          : Icons.notifications_active,
                      color: reminder.isCompleted
                          ? AppColors.accentGreen
                          : isPast
                              ? AppColors.accentRed
                              : AppColors.accentGreen,
                    ),
                  ),
                  title: Text(
                    reminder.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reminder.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          reminder.description!,
                          style: AppTextStyles.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(reminder.reminderDate),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isPast && !reminder.isCompleted
                              ? AppColors.accentRed
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: reminder.isCompleted,
                        onChanged: (value) async {
                          await reminderProvider.toggleCompletion(reminder);
                        },
                        activeColor: AppColors.accentGreen,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: AppColors.accentRed,
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              title: Text('Hapus Reminder', style: AppTextStyles.heading3),
                              content: Text(
                                'Apakah Anda yakin ingin menghapus reminder ini?',
                                style: AppTextStyles.bodyMedium,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Hapus', style: TextStyle(color: AppColors.accentRed)),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            if (!mounted) return;
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final success = await reminderProvider.deleteReminder(
                              reminder.id!,
                              authProvider.currentUser!.id!,
                            );

                            if (success) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Reminder berhasil dihapus'),
                                  backgroundColor: AppColors.accentGreen,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddReminderScreen()),
          );
          if (result == true) {
            _loadReminders();
          }
        },
        backgroundColor: AppColors.accentGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
