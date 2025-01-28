import 'package:flutter/material.dart';

class TaskSchedulerPage extends StatefulWidget {
  @override
  _TaskSchedulerPageState createState() => _TaskSchedulerPageState();
}

class _TaskSchedulerPageState extends State<TaskSchedulerPage> {
  final List<String> members = ['Alice', 'Bob', 'Charlie', 'Diana'];
  final List<String> tasks = [
    'Clean Kitchen',
    'Take Out Trash',
    'Vacuum',
    'Water Plants'
  ];
  int currentTaskIndex = 0;

  // Map to keep track of each member's current task
  Map<String, String> assignedTasks = {};

  @override
  void initState() {
    super.initState();
    assignTasks();
  }

  void assignTasks() {
    setState(() {
      for (var member in members) {
        assignedTasks[member] = tasks[currentTaskIndex];
        currentTaskIndex = (currentTaskIndex + 1) % tasks.length;
      }
    });
  }

  void completeTask(String member) {
    setState(() {
      assignedTasks[member] = tasks[currentTaskIndex];
      currentTaskIndex = (currentTaskIndex + 1) % tasks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Task Assignments:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                title: Text('$member'),
                subtitle: Text('Task: ${assignedTasks[member]}'),
                trailing: ElevatedButton(
                  onPressed: () => completeTask(member),
                  child: Text('Complete'),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: assignTasks,
              child: Text('Reassign Tasks'),
            ),
          ),
        ),
      ],
    );
  }
}
