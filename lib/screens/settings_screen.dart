import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fittrack/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();
  final Box settingsBox = Hive.box('settings_box');

  bool _remindersEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    // Request permission as soon as the settings page is opened
    _notificationService.requestPermission();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _remindersEnabled = settingsBox.get('remindersEnabled', defaultValue: false);
      final storedHour = settingsBox.get('reminderHour', defaultValue: 17);
      final storedMinute = settingsBox.get('reminderMinute', defaultValue: 0);
      _selectedTime = TimeOfDay(hour: storedHour, minute: storedMinute);
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      _saveAndSchedule();
    }
  }

  void _onReminderSwitchChanged(bool value) {
    setState(() {
      _remindersEnabled = value;
    });
    // If enabling for the first time, make sure we have permission
    if (value) {
      _notificationService.requestPermission();
    }
    _saveAndSchedule();
  }
  
  void _saveAndSchedule() {
    settingsBox.put('remindersEnabled', _remindersEnabled);
    settingsBox.put('reminderHour', _selectedTime.hour);
    settingsBox.put('reminderMinute', _selectedTime.minute);

    if (_remindersEnabled) {
      _notificationService.scheduleDailyWorkoutReminder(_selectedTime);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminders set for ${_selectedTime.format(context)} daily.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _notificationService.cancelAllNotifications();
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminders have been turned off.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Reminders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile.adaptive(
            title: const Text('Enable Daily Reminders'),
            value: _remindersEnabled,
            onChanged: _onReminderSwitchChanged,
            secondary: const Icon(Icons.notifications_active_outlined),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const Divider(),
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(_selectedTime.format(context)),
            trailing: const Icon(Icons.edit_outlined),
            onTap: _remindersEnabled ? () => _selectTime(context) : null,
            enabled: _remindersEnabled,
          ),
        ],
      ),
    );
  }
}
