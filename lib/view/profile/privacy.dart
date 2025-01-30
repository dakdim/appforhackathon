import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String name = "Shailesh Devkota";
  String username = "shailesh_dev19";
  String birthday = "14/04/2001";
  String mobileNumber = "986 583 8960";
  String email = "devkotashailesh76@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView(
        children: [
          _buildSettingItem("Name", name, Icons.person, () {
            _showEditDialog("Name", name, (newValue) {
              setState(() {
                name = newValue;
              });
            });
          }),
          _buildSettingItem("Username", username, Icons.alternate_email, () {
            _showEditDialog("Username", username, (newValue) {
              setState(() {
                username = newValue;
              });
            });
          }),
          _buildSettingItem("Birthday", birthday, Icons.cake, () {
            _showEditDialog("Birthday", birthday, (newValue) {
              setState(() {
                birthday = newValue;
              });
            });
          }),
          _buildSettingItem("Mobile Number", mobileNumber, Icons.phone, () {
            _showEditDialog("Mobile Number", mobileNumber, (newValue) {
              setState(() {
                mobileNumber = newValue;
              });
            });
          }),
          _buildSettingItem("Email", email, Icons.email, () {
            _showEditDialog("Email", email, (newValue) {
              setState(() {
                email = newValue;
              });
            });
          }),

          const SizedBox(height: 20),

          // Delete Account Button
          Center(
            child: TextButton(
              onPressed: () {
                _showDeleteAccountDialog();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete Account"),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build a single ListTile for settings items
  Widget _buildSettingItem(
      String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      leading: Icon(icon, color: Colors.grey),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Function to show a dialog for editing text fields
  void _showEditDialog(
      String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Function to show a confirmation dialog for deleting the account
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Simply close the dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Your account has been deleted.")),
                );
                // Here, you can add logic to delete the account from the backend.
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(" Delete"),
            ),
          ],
        );
      },
    );
  }
}
