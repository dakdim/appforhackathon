import 'package:flutter/material.dart';

class PersonDetailsPage extends StatefulWidget {
  final String name;

  const PersonDetailsPage({required this.name, super.key});

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
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _particularController.dispose();
    super.dispose();
  }

  void _addTransaction() {
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
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
      body: Stack(children: [
        Column(
          children: [
            AppBar(
              title: Text(widget.name),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return Card(
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
        Positioned(
          top: 10,
          right: 20,
          child: SizedBox(
            width: 40, // Adjust the size as needed
            height: 40,
            child: FloatingActionButton(
              onPressed: _addTransaction,
              child: const Icon(Icons.add, size: 20), // Adjust the icon size
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ),
      ]),
    );
  }
}
