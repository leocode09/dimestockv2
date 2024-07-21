import 'package:flutter/material.dart';

class ExpenseFormData {
  final String spenderName;
  final double amountSpent;
  final String description;

  ExpenseFormData({
    required this.spenderName,
    required this.amountSpent,
    required this.description,
  });
}

class ExpenseDisplay extends StatefulWidget {
  final List<ExpenseFormData> expenses;
  final Function(int) onDelete;
  final Function(int, ExpenseFormData) onEdit;

  ExpenseDisplay({
    required this.expenses,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _ExpenseDisplayState createState() => _ExpenseDisplayState();
}

class _ExpenseDisplayState extends State<ExpenseDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) {
        final expense = widget.expenses[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(expense.spenderName),
            subtitle: Text(expense.description),
            trailing: Text('\$${expense.amountSpent.toStringAsFixed(2)}'),
            onTap: () => _showEditDialog(context, index, expense),
            onLongPress: () => _showDeleteDialog(context, index),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index, ExpenseFormData expense) {
    final nameController = TextEditingController(text: expense.spenderName);
    final amountController = TextEditingController(text: expense.amountSpent.toString());
    final descriptionController = TextEditingController(text: expense.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Spender Name'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount Spent'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              final updatedExpense = ExpenseFormData(
                spenderName: nameController.text,
                amountSpent: double.tryParse(amountController.text) ?? 0,
                description: descriptionController.text,
              );
              widget.onEdit(index, updatedExpense);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              widget.onDelete(index);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}