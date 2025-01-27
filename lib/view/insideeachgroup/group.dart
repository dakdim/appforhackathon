import 'package:flutter/material.dart';

class GroupDetailsPage extends StatelessWidget {
  final String groupName;
  final String? groupImage;
  final List<String> members;

  const GroupDetailsPage({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(groupName),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: "Chat"),
              Tab(icon: Icon(Icons.calendar_today), text: "Schedule"),
              Tab(icon: Icon(Icons.money), text: "Expenses"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Chat Tab
            Center(
              child: Text(
                "Chat Functionality Coming Soon",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Schedule Tab
            Center(
              child: Text(
                "Schedule Functionality Coming Soon",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Group Expenses Tab
            Center(
              child: Text(
                "Expense Tracking Coming Soon",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
