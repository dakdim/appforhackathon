import 'dart:io'; // For File
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

  // List to store groups (name and image path)
  final List<Map<String, String?>> _groups = [];

  final List<Widget> _pages = [
    const Center(child: Text("Home Page", style: TextStyle(fontSize: 20))),
    const ExpensePage(),
    const Center(
        child: Text("Notification Page", style: TextStyle(fontSize: 20))),
  ];

  // Function to display Add Group dialog
  void _showAddGroupDialog() {
    final TextEditingController groupNameController = TextEditingController();
    XFile? selectedImage;
    List<TextEditingController> memberControllers = [TextEditingController()];

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
                    const SizedBox(height: 20),

                    // Add Members Section
                    const Text(
                      "Add Members",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(
                        memberControllers.length,
                        (index) => Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: memberControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Member ${index + 1}",
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () {
                                if (memberControllers.length > 1) {
                                  setDialogState(() {
                                    memberControllers.removeAt(index);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            memberControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Member"),
                      ),
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

                      // Collect member names
                      List<String> members = memberControllers
                          .map((controller) => controller.text)
                          .where((name) => name.isNotEmpty)
                          .toList();

                      // Add the new group to the list
                      setState(() {
                        _groups.add({
                          "name": groupName,
                          "image": imagePath,
                          "members": members
                              .join(", "), // Store members as comma-separated
                        });
                      });

                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Group '$groupName' added successfully!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Home Page"),
        backgroundColor: Colors.blue,
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
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Expense'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Display groups on Home Page
          // Display groups on Home Page
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
                    subtitle:
                        Text("Members: ${group["members"] ?? 'No members'}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetailsPage(
                            groupName: group["name"]!,
                            groupImage: group["image"],
                            members: (group["members"] ?? '').split(", "),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

          _pages[_currentIndex],
          if (_currentIndex == 0)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _showAddGroupDialog,
                child: const Icon(Icons.add),
              ),
            ),
        ],
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
