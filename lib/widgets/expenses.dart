import "package:expense_tracker/widgets/chart/chart.dart";
import "package:expense_tracker/widgets/expenses_list/expenses_list.dart";
import "package:expense_tracker/models/expense.dart";
import "package:expense_tracker/widgets/new_expense.dart";
import "package:flutter/material.dart";

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(title: "Flutter course", amount: 19.99, date: DateTime.now(), category: Category.work),
    Expense(title: "Cinema", amount: 15.99, date: DateTime.now(), category: Category.leisure),
  ];

  void _addToRegisteredExpenses(Expense item) {
    setState(() {
          _registeredExpenses.add(item);
    });

  }

  void _removeFromRegisteredExpenses(Expense item) {
    final expenseIndex = _registeredExpenses.indexOf(item);
    setState(() {
      _registeredExpenses.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        persist: false,
        content: const Text("Expense deleted"),
        action: SnackBarAction(
          label: "Undo", 
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, item);
            });
          }
        ),
      )
    );
  }

  void _openAddExpenseOverlay() {
    
    showModalBottomSheet(
      isScrollControlled: true, 
      context: context, 
      builder: (ctx) => NewExpense(_addToRegisteredExpenses),
      useSafeArea: true
    );
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(child: Text("No expenses found"),);
    if(_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeFromRegisteredExpenses);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter expense tracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent,)
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent,)
        ],
      )
    );
  }
}