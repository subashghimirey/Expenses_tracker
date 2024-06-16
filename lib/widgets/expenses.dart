import 'package:expenses_tracker/widgets/chart/chart.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

//in order to store the Expenses objects in list which is list of Expense objects
List<Expense> _registeredExpenses = [
  Expense(
      title: "Movie",
      amount: 100.0,
      date: DateTime.now(),
      category: Category.leisure),
  Expense(
      title: "Tour to Sydney",
      amount: 500.0,
      date: DateTime.now(),
      category: Category.travel),
];

class _ExpensesState extends State<Expenses> {
  void addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense Deleted"),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: ("Undo"),
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void _openAddExpenseOverlay() {
    //we used this overlay feature provided by material.dart
    showModalBottomSheet(
        //Makes the modalbottom sheet scrollable and takes full screen
        isScrollControlled: true,

        //excludes the camera area 
        useSafeArea: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            addExpense: addExpense,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //in order to get the width of the screen and adjust the UI accordingly, down we use ternary operator to change the Widget type from Column to Row if the screen size width is greater than 600
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    print(height);
    print(width);

    Widget mainContent =
        const Center(child: Text("No expenses added recently, Add some!"));

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expenses Tracker App"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent)
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent)
              ],
            ),
    );
  }
}
