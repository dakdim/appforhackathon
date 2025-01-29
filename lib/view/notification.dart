import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint('Notification payload: ${response.payload}');
        }
      },
    );

    tz.initializeTimeZones();
  }

  Future<void> _scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Notifications for scheduled tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _addTask() {
    final memberNameController = TextEditingController();
    final taskController = TextEditingController();
    DateTime? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: memberNameController,
                      decoration: const InputDecoration(
                        labelText: 'Member Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: 'Task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          final now = DateTime.now();
                          setState(() {
                            selectedTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                      child: Text(
                        selectedTime == null
                            ? 'Select Time'
                            : 'Selected: ${selectedTime!.hour}:${selectedTime!.minute}',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (memberNameController.text.isNotEmpty &&
                        taskController.text.isNotEmpty &&
                        selectedTime != null) {
                      _scheduleNotification(
                        title: 'Task Reminder',
                        body:
                            '${memberNameController.text}: ${taskController.text}',
                        scheduledTime: selectedTime!,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please fill all fields and select a time.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _addTask,
          child: const Text('Add Task & Schedule Notification'),
        ),
      ),
    );
  }
}
