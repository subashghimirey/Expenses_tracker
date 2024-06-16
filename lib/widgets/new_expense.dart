import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'dart:io';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  DateTime? selectedDate;

  //here we use async and wait in Future type cause when we want to store the some value in variable which of type Future then, we cannot assign until it is executed, hence, we use await which tells the Flutter that the value will be available in future and must be assigned to pickedDate when available.
  void _showDatePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1);
    var pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);

    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Invalid Data !!",
                style: Theme.of(context).textTheme.titleLarge),
            content: Text(
                "Please enter valid title, amount, date and category..",
                style: Theme.of(context).textTheme.titleLarge),
            actions: [
              TextButton(
                  onPressed: () {
                    //closes the current overlay of the Dialogue Box
                    Navigator.pop(context);
                  },
                  child: const Text("Okayy"))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text("Invalid Data !!",
                style: Theme.of(context).textTheme.titleLarge),
            content: Text(
                "Please enter valid title, amount, date and category..",
                style: Theme.of(context).textTheme.titleLarge),
            actions: [
              TextButton(
                  onPressed: () {
                    //closes the current overlay of the Dialogue Box
                    Navigator.pop(ctx);
                  },
                  child: const Text("Okayy"))
            ],
          );
        },
      );
    }
  }

  void submitExpense() {
    var selectedAmount = double.tryParse(_amountController.text);

    var invalidSelectedAmount = (selectedAmount == null || selectedAmount <= 0);

    if (_titleController.text.trim().isEmpty ||
        selectedDate == null ||
        invalidSelectedAmount) {
      _showDialog();

      return;
    }
    widget.addExpense(Expense(
      title: _titleController.text,
      amount: selectedAmount,
      category: _selectedCategory,
      date: selectedDate!,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //viewInsets gives info about the overlapping UI elements here we want to get the space overlapped by the keyboard which comes from bottom
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    //this below is one of the approach to handle the user input, instead of manually handling user inputs, flutter provides a way to handle the inputs more easily, hence we use that above this
    // var _enteredTitle = '';

    // void saveTitle(String inputValue) {
    //   _enteredTitle = inputValue;
    // }

    //Layoutbuilder is used to get the actual available space which can be used to design the UI accrodingly for all devices
    //constraints helps to know the actual space available
    return LayoutBuilder(
      builder: (ctx, constraints) {
        var width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            //using the input controller of flutter instead of manual
                            controller: _titleController,
                            maxLength: 50,
                            // keyboardType: TextInputType.name,
                            decoration:
                                const InputDecoration(label: Text("Title")),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: ("\$"),
                              label: Text("Amount: "),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      //using the input controller of flutter instead of manual
                      controller: _titleController,
                      maxLength: 50,
                      // keyboardType: TextInputType.name,
                      decoration: const InputDecoration(label: Text("Title")),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate == null
                                    ? "No Date Selected"
                                    : formatter.format(selectedDate!),
                                style: const TextStyle(color: Colors.white),
                              ),

                              //the exclamation sign tells the Flutter that it wont be null since we cannot provide null value to format

                              IconButton(
                                onPressed: _showDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        //Here we need to wrap the textfield with the Expanded cause the TextField tries to get maximum width as possible and the Row doesnot limit the amount of width, it causes te TextField to go beyond the width of screen. Hence we must use Expanded to limit the width
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: ("\$"),
                              label: Text("Amount: "),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate == null
                                    ? "No Date Selected"
                                    : formatter.format(selectedDate!),
                                style: const TextStyle(color: Colors.white),
                              ),

                              //the exclamation sign tells the Flutter that it wont be null since we cannot provide null value to format

                              IconButton(
                                onPressed: _showDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (width >= 600)
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: submitExpense,
                            child: const Text("Submit")),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: submitExpense,
                            child: const Text("Submit")),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
