import 'dart:collection';

class Task {
  String name;
  String assignedMember;
  bool isCompleted;

  Task(this.name, {this.assignedMember = '', this.isCompleted = false});

  @override
  String toString() {
    return 'Task: $name, Assigned to: $assignedMember, Completed: $isCompleted';
  }
}

class Scheduler {
  List<String> members;
  Queue<Task> tasks;
  int currentMemberIndex;

  Scheduler(this.members, List<Task> taskList)
      : tasks = Queue.from(taskList),
        currentMemberIndex = 0;

  void assignTasks() {
    while (tasks.any((task) => !task.isCompleted)) {
      for (var task in tasks) {
        if (!task.isCompleted) {
          task.assignedMember = members[currentMemberIndex];
          print('Assigned "${task.name}" to ${members[currentMemberIndex]}');
          currentMemberIndex = (currentMemberIndex + 1) % members.length;
        }
      }
    }
  }

  void completeTask(String taskName) {
    for (var task in tasks) {
      if (task.name == taskName && !task.isCompleted) {
        task.isCompleted = true;
        print(
            'Task "${task.name}" marked as completed by ${task.assignedMember}');
        return;
      }
    }
    print('Task "$taskName" not found or already completed.');
  }

  void reassignTasks() {
    for (var task in tasks) {
      if (!task.isCompleted) {
        assignTasks();
      }
    }
  }

  void printStatus() {
    print('\nCurrent Task Status:');
    for (var task in tasks) {
      print(task);
    }
    print('');
  }
}

void main() {
  // Members
  List<String> members = ['Alice', 'Bob', 'Charlie'];

  // Task List
  List<Task> tasks = [
    Task('Clean the room'),
    Task('Write a report'),
    Task('Prepare presentation'),
  ];

  // Create Scheduler
  Scheduler scheduler = Scheduler(members, tasks);

  // Assign Tasks
  print('Initial Task Assignment:');
  scheduler.assignTasks();

  // Show Status
  scheduler.printStatus();

  // Complete a Task
  scheduler.completeTask('Write a report');

  // Show Updated Status
  scheduler.printStatus();

  // Reassign Remaining Tasks
  print('Reassigning Remaining Tasks:');
  scheduler.reassignTasks();

  // Show Final Status
  scheduler.printStatus();
}
