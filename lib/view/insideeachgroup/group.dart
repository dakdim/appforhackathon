import 'package:flutter/material.dart';
import 'schedule.dart';
import 'memberspage.dart';
import 'chat.dart';

class GroupDetailsPage extends StatelessWidget {
  final String groupName;
  final String? groupImage;
  final String otp;
  final List<String> members;

  const GroupDetailsPage({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.otp,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(groupName),
              const SizedBox(width: 8), // Add some spacing
              Text(
                otp,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Differentiate OTP color
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String result) {
                if (result == "members") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembersPage(members: members),
                    ),
                  );
                } else if (result == "leave") {
                  // TODO: Handle Leave Group
                } else if (result == "delete") {
                  // TODO: Handle Delete Group (Admin Only)
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "members",
                  child: ListTile(
                    leading: Icon(Icons.people, color: Colors.blue),
                    title: Text("Members"),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "leave",
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.orange),
                    title: Text("Leave Group"),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: "delete",
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text("Delete Group"),
                  ),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), text: "Chat"),
              Tab(icon: Icon(Icons.calendar_today), text: "Schedule"),
              Tab(icon: Icon(Icons.money), text: "Expenses"),
            ],
          ),
        ),
        body: Column(
          children: [
            if (groupImage != null && groupImage!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  groupImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 100);
                  },
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  const ChatPage(),
                  const SchedulePage(),
                  const Center(
                    child: Text(
                      "Expense Tracking Coming Soon",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
