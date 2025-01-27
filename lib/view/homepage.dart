import 'dart:io'; // For File
import 'dart:math'; // For OTP Generation
import 'package:cleanapp/view/profile/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cleanapp/view/expense.dart';
import 'package:cleanapp/view/insideeachgroup/group.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List to store groups (name, image path, members, and OTP)
  final List<Map<String, String?>> _groups = [];

  final List<Widget> _pages = [
    const Center(child: Text("Home Page", style: TextStyle(fontSize: 20))),
    const ExpensePage(),
    const Center(
        child: Text("Notification Page", style: TextStyle(fontSize: 20))),
  ];

  // Function to generate a random OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

  // Function to display Add Group dialog
  void _showAddGroupDialog() {
    final TextEditingController groupNameController = TextEditingController();
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Group"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Group Name Input
                    TextField(
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        labelText: "Group Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Group Image Selection
                    selectedImage != null
                        ? Image.file(
                            File(selectedImage!.path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(
                            height: 100,
                            width: 100,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Icon(Icons.image, color: Colors.white),
                            ),
                          ),
                    TextButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setDialogState(() {
                          selectedImage = image;
                        });
                      },
                      icon: const Icon(Icons.upload),
                      label: const Text("Upload Image"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (groupNameController.text.isNotEmpty) {
                      String groupName = groupNameController.text;
                      String? imagePath = selectedImage?.path;
                      String otp = generateOTP();

                      // Add the new group to the list
                      setState(() {
                        _groups.add({
                          "name": groupName,
                          "image": imagePath,
                          "otp": otp,
                        });
                      });

                      Navigator.pop(context); // Close dialog

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Group '$groupName' added successfully! OTP: $otp"),
                        ),
                      );
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to join a group using OTP
  void _showJoinGroupDialog() {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Join Group"),
          content: TextField(
            controller: otpController,
            decoration: const InputDecoration(
              labelText: "Enter OTP",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String otp = otpController.text;
                final group = _groups.firstWhere(
                  (group) => group["otp"] == otp,
                  orElse: () => {},
                );

                if (group.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Joined group: ${group['name']}")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid OTP")),
                  );
                }

                Navigator.pop(context); // Close dialog
              },
              child: const Text("Join"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track_It"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            onPressed: _showJoinGroupDialog, // Open Join Group dialog
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_3),
              title: const Text('Edit profile'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text('Account'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LOGOUT'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (_currentIndex == 0)
            ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return Card(
                  child: ListTile(
                    leading: group["image"] != null
                        ? Image.file(
                            File(group["image"]!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.group, size: 50),
                    title: Text(group["name"]!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsPage(
                            groupName: group["name"]!,
                            groupImage: group["image"],
                            otp: group["otp"]!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          _pages[_currentIndex],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGroupDialog, // Open Add Group dialog
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}
