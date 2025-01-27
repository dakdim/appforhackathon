import 'package:flutter/material.dart';

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
            if (groupImage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  groupImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
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
                  Center(
                    child: Text(
                      "Chat Functionality Coming Soon",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Schedule Functionality Coming Soon",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Center(
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
