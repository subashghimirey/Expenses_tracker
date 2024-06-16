import 'package:expenses_tracker/widgets/expenses_list/expense_list_item.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    //we may have very long number of items to be displayed in the screen and if we use Column as previous which displays all the items when the screen is active, it can be slow and reduce performance, hence, we can use ListView instead of it whose special .builder method allows to render or create only the items which are about to be visible or which are visible in the screen.
    return ListView.builder(

        //itemcount is used to know how many date items are there in the list
        itemCount: expenses.length,

        //the itembuilder function runs as many times as the itemCount and index is initilized from 0 to the itemCount hence, all the items are accessible in the list
        itemBuilder: (context, index) => Dismissible(
            background: Container(color: Theme.of(context).colorScheme.error.withOpacity(0.8), margin: Theme.of(context).cardTheme.margin),
            
            key: ValueKey(expenses[index]),
            onDismissed: (direction) {

              onRemoveExpense(expenses[index]);
            },
            child: ExpenseListItem(expense: expenses[index]))

        //to make the list dismissisable we wrap the above with Dismissible, to pass the key we use the ValueKey property of flutter and provide the expenses index as the key, but we need to add the onDismissed so that it is not only removed visually but also internally from data
        //
        );
  }
}
