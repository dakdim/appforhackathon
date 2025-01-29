import 'package:flutter/material.dart';
import 'persondetail.dart'; // Import PersonDetailsPage

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Map<String, String>> _people = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addPerson() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Add Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty) {
                  setState(() {
                    _people.add({
                      'name': _nameController.text,
                      'email': _emailController.text,
                    });
                  });
                  _nameController.clear();
                  _emailController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetails(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailsPage(name: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _people.isEmpty
          ? const Center(child: Text("No people added yet!"))
          : ListView.builder(
              itemCount: _people.length,
              itemBuilder: (context, index) {
                final person = _people[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      person['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(person['email']!),
                    onTap: () => _navigateToDetails(person['name']!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPerson,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
