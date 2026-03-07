import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final Function addToExpenses;
  const NewExpense(this.addToExpenses, {super.key});
  
  @override
  State<NewExpense> createState() {
    // TODO: implement createState
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDatePicker () async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDait = await showDatePicker(context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDait;
    });
  }

  void _subtimExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty || enteredAmount == null || enteredAmount <= 0 || _selectedDate == null) {
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text("Invalid input"),
        content: const Text("Please make sure a valid title, amount date and category was entered"),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(ctx);
          }, child: const Text("Okay"))
        ],
      ));
      return;
    }
    Expense newExpense = Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory);
      widget.addToExpenses(newExpense);
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Title")
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixText: "\$ ",
                    label: Text("Amount")
                  ),
                ),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null ? "No date selected": formatter.format(_selectedDate!)),
                    IconButton(onPressed: _showDatePicker, icon: Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase())
                )).toList(), 
                onChanged: (value) {
                  if(value == null) {
                      return;
                  } 
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _subtimExpenseData, 
                child: const Text("Save Expense")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); 
                }, 
                child: Text("Cancel")
              )
            ],
          )
        ],
      ),
    );
  }
}