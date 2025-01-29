import 'package:flutter/material.dart';

class MembersPage extends StatelessWidget {
  final List<String> members; // List of group members

  const MembersPage({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Members"),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(members[index]),
          );
        },
      ),
    );
  }
}
