import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

//to generate unique id automatically
const uuid = Uuid();

//using intl third party package to format the date
final formatter = DateFormat.yMd();

//in order to categorize the expenses into different fields we carete a enum
enum Category { food, travel, leisure, work }

//to dynamically render the icons according to cateogry, we store then in a const
const categoryIcons = {
  Category.food: Icons.food_bank,
  Category.leisure: Icons.movie_creation_sharp,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work
};

class Expense {
  //here in order to intialize the id variable automatically we have used the Initializer list outside the Expense constructor. such can be used to initialize the class properties like id that are not received as contructor function arguments.
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4(); //Initializer list

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  //getter used to returnt the formatted date
  //getter doesnot use the parenthesis
  //we use the third party package intl's DateFormat.yMd() to format the date
  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (var expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
