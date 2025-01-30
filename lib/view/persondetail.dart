import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat

class PersonDetailsPage extends StatefulWidget {
  final String name;
  final double balance;

  const PersonDetailsPage(
      {required this.name, required this.balance, super.key});

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _particularController = TextEditingController();
  String _selectedType = 'Credit';

  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    // Add the initial balance as a credit transaction
    _transactions.add({
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'particular': 'Initial Balance',
      'type': 'Credit',
      'amount': widget.balance,
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _particularController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    DateTime selectedDate = DateTime.now(); // Default to the current date

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Field with Date Picker
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      // Open Date Picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                readOnly: true, // Prevent manual editing
                onTap: () async {
                  // Open Date Picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _particularController,
                decoration: InputDecoration(
                  labelText: 'Particular',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                  DropdownMenuItem(value: 'Debit', child: Text('Debit')),
                ],
                onChanged: (value) {
                  _selectedType = value!;
                },
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
                if (_dateController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  setState(() {
                    _transactions.add({
                      'date': _dateController.text,
                      'particular': _particularController.text,
                      'type': _selectedType,
                      'amount': double.parse(_amountController.text),
                    });
                  });
                  _dateController.clear();
                  _amountController.clear();
                  _particularController.clear();
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

  void _editTransaction(int index) {
    final transaction = _transactions[index];
    _dateController.text = transaction['date'];
    _amountController.text = transaction['amount'].toString();
    _particularController.text = transaction['particular'];
    _selectedType = transaction['type'];

    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(transaction['date']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Edit Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Field with Date Picker
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      // Open Date Picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                readOnly: true, // Prevent manual editing
                onTap: () async {
                  // Open Date Picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _particularController,
                decoration: InputDecoration(
                  labelText: 'Particular',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                  DropdownMenuItem(value: 'Debit', child: Text('Debit')),
                ],
                onChanged: (value) {
                  _selectedType = value!;
                },
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
                if (_dateController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  setState(() {
                    _transactions[index] = {
                      'date': _dateController.text,
                      'particular': _particularController.text,
                      'type': _selectedType,
                      'amount': double.parse(_amountController.text),
                    };
                  });
                  _dateController.clear();
                  _amountController.clear();
                  _particularController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  void _showEditDeleteOptions(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Options'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editTransaction(index);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTransaction(index);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double creditSum = _transactions
        .where((t) => t['type'] == 'Credit')
        .fold(0.0, (sum, t) => sum + t['amount']);
    double debitSum = _transactions
        .where((t) => t['type'] == 'Debit')
        .fold(0.0, (sum, t) => sum + t['amount']);
    double balance = creditSum - debitSum;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Text(widget.name),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: _addTransaction,
                icon: const Icon(Icons.add, color: Colors.blueAccent),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return GestureDetector(
                  onLongPress: () {
                    _showEditDeleteOptions(index);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(
                        transaction['particular'],
                        style: TextStyle(
                          color: transaction['type'] == 'Credit'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(transaction['date']),
                      trailing: Text(
                        transaction['type'] == 'Credit'
                            ? '+${transaction['amount']}'
                            : '-${transaction['amount']}',
                        style: TextStyle(
                          color: transaction['type'] == 'Credit'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credit(↑): Rs ${creditSum.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Debit(↓): Rs ${debitSum.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Rs ${balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
