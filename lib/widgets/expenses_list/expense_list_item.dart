import 'package:expenses_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseListItem extends StatelessWidget {
  const ExpenseListItem({required this.expense, super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {

    //we used card here cause it provides elevated design and is useful for our purpose
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 4),
            Row(
              children: [

                //Here, we have used escape character as \$ to print the dollar sign similarly we can use \\ to print backslash \.
                Text("\$${expense.amount.toStringAsFixed(2)}, ", style: Theme.of(context).textTheme.titleLarge),

                //Spacer takes all the space between two widgets that is left between them.
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 9,),
                    Text(expense.formattedDate, style: Theme.of(context).textTheme.titleLarge)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
