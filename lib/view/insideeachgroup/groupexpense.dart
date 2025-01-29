import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupExpensePage extends StatefulWidget {
  @override
  _GroupExpensePageState createState() => _GroupExpensePageState();
}

class _GroupExpensePageState extends State<GroupExpensePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _particularController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Member> members = [
    Member(name: "Alice"),
    Member(name: "Bob"),
    Member(name: "Charlie"),
  ];
  late String payer;

  @override
  void initState() {
    super.initState();
    payer = members.first.name; // Set the first member as the default payer
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _splitExpense() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0 || members.isEmpty) return;

    double share = amount / members.length;

    setState(() {
      for (var member in members) {
        if (member.name == payer) {
          member.balance += (amount - share);
        } else {
          member.balance -= share;
        }
      }
    });

    _amountController.clear();
    _particularController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _particularController,
              decoration: InputDecoration(
                labelText: "Enter Particular",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _selectDate(context),
                  child: Text("Select Date"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: _splitExpense,
              child: Text("Split Expense"),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class Member {
  final String name;
  double balance;

  Member({required this.name, this.balance = 0});
}
