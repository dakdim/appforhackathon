import 'package:flutter/material.dart';
import 'schedule.dart'; // Ensure correct spelling in import

class GroupDetailsPage extends StatelessWidget {
  final String groupName;
  final String? groupImage;
  final String otp;

  const GroupDetailsPage({
    super.key,
    required this.groupName,
    required this.groupImage,
    required this.otp,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Group OTP: $otp",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: TabBarView(
                children: [
                  const Center(
                    child: Text(
                      "Chat Functionality Coming Soon",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SchedulePage(), // Ensure SchedulePage is correctly imported
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
