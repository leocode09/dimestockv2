import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFBFA600),
        scaffoldBackgroundColor: Colors.grey[900],
        dialogBackgroundColor: Colors.grey[900],
        // appBarTheme: AppBarTheme(
        //   backgroundColor: Colors.blueGrey[900],
        //   elevation: 0,
        // ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFBFA600),
        ),
      ),
      home: ExpenseList(),
    );
  }
}

class Expense {
  final String id;
  DateTime date;
  String spenderName;
  double amountSpent;
  String description;

  Expense({
    required this.id,
    required this.date,
    required this.spenderName,
    required this.amountSpent,
    required this.description,
  });
}

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> with TickerProviderStateMixin {
  List<Expense> expenses = [];
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fabScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      expenses.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void editExpense(Expense oldExpense, Expense newExpense) {
    setState(() {
      int index = expenses.indexOf(oldExpense);
      expenses[index] = newExpense;
      expenses.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void deleteExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Expense>> groupedExpenses = {};
    for (var expense in expenses) {
      String dateString = DateFormat('yyyy-MM-dd').format(expense.date);
      if (!groupedExpenses.containsKey(dateString)) {
        groupedExpenses[dateString] = [];
      }
      groupedExpenses[dateString]!.add(expense);
    }

    return Scaffold(
      appBar: AppBar(
        // foregroundColor: Color.fromARGB(0, 228, 9, 9),
        // surfaceTintColor: Color.fromARGB(0, 228, 9, 9),
        // backgroundColor: Color.fromARGB(0, 228, 9, 9),
        title: Text('Expense Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),

        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 52, 47, 14), Color(0xFFBFA600)],
            ),
          ),
        ),
      ),

      
      
      backgroundColor: Colors.grey[900],
      body: groupedExpenses.isEmpty
          ? Center(
              child: Text(
                'No expenses yet. Tap + to add one!',
                style: TextStyle(fontSize: 18, color: Colors.grey[400]),
              ),
            )
          : ListView.builder(
              itemCount: groupedExpenses.length,
              itemBuilder: (context, index) {
                String date = groupedExpenses.keys.elementAt(index);
                List<Expense> dayExpenses = groupedExpenses[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        DateFormat('MMMM d, yyyy').format(DateTime.parse(date)),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBFA600),
                        ),
                      ),
                    ),
                    ...dayExpenses.map((expense) => _buildExpenseItem(expense)).toList(),
                  ],
                );
              },
            ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: () => _showExpenseDialog(context, null),
          child: Icon(Icons.add),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    return Slidable(
      child: Card(
  color: Color(0xFF151515),
  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  child: ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    title: Text(
      expense.spenderName,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      expense.description,
      style: TextStyle(color: Colors.white70),
    ),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${expense.amountSpent.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFBFA600),
          ),
        ),
        SizedBox(height: 4),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red, size: 20),
          onPressed: () => deleteExpense(expense),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          splashRadius: 20,
        ),
      ],
    ),
    onTap: () => _showExpenseDialog(context, expense),
  ),
)
    );
  }

   void _showExpenseDialog(BuildContext context, Expense? expense) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController spenderNameController = TextEditingController();
    final TextEditingController amountSpentController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    if (expense != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(expense.date);
      spenderNameController.text = expense.spenderName;
      amountSpentController.text = expense.amountSpent.toString();
      descriptionController.text = expense.description;
    } else {
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            expense == null ? 'Add Expense' : 'Edit Expense',
            style: TextStyle(color: Color(0xFFBFA600)),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDatePicker(context, dateController),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: spenderNameController,
                    label: 'Spender Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: amountSpentController,
                    label: 'Amount Spent',
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text(expense == null ? 'Add' : 'Save'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Color(0xFFBFA600),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newExpense = Expense(
                    id: expense?.id ?? DateTime.now().toString(),
                    date: DateFormat('yyyy-MM-dd').parse(dateController.text),
                    spenderName: spenderNameController.text,
                    amountSpent: double.parse(amountSpentController.text),
                    description: descriptionController.text,
                  );

                  if (expense == null) {
                    addExpense(newExpense);
                  } else {
                    editExpense(expense, newExpense);
                  }

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context, TextEditingController controller) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFFBFA600),
                  onPrimary: Colors.black,
                  surface: Colors.white,
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: Colors.grey[900],
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.text),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xf5f5f5),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }


}