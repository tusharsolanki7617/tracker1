import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../resource/resource.dart' show AppAnimations, AppColors;

class AddExpensePage extends StatefulWidget {
  final String currencySymbol;
  final List<String> categories;
  final Function(TransactionItem) onAddExpense;
  final Function(String) onAddCategory;
  final VoidCallback? onSuccess;

  const AddExpensePage({
    super.key,
    required this.currencySymbol,
    required this.categories,
    required this.onAddExpense,
    required this.onAddCategory,
    this.onSuccess,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _newCategoryController = TextEditingController();

  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.isNotEmpty ? widget.categories.first : 'Food';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    _newCategoryController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Category'),
        content: TextField(
          controller: _newCategoryController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Travel, Subscriptions',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCat = _newCategoryController.text.trim();
              if (newCat.isNotEmpty) {
                widget.onAddCategory(newCat);
                setState(() {
                  _selectedCategory = newCat;
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      final newExpenseItem = TransactionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        isIncome: false,
      );

      widget.onAddExpense(newExpenseItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              AppAnimations.successWidget(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Expense of ${widget.currencySymbol}$amount logged!',
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.expense,
        ),
      );

      _titleController.clear();
      _amountController.clear();
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.categories.contains(_selectedCategory)) {
      _selectedCategory = widget.categories.first;
    }

    // Scaffold, AppBar, and BottomNavigationBar are provided by the parent screen.
    return SafeArea(
      // SafeArea keeps the form clear of system display insets.
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // SingleChildScrollView contains the validated expense form.
        child: Form(
          key: _formKey,
          // Column arranges the expense form controls vertically.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text: Log New Expense.
              const Text(
                'Log New Expense',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // TextField (Expense Title).
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  hintText: 'e.g. Dinner, Bus ticket, Electricity bill',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter an expense title' : null,
              ),
              const SizedBox(height: 16),

              // TextField (Expense Amount).
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Expense Amount',
                  prefixText: widget.currencySymbol,
                  prefixIcon: const Icon(Icons.money_off),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter expense amount';
                  }
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // DropdownButton (Category) and add-category action.
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: widget.categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    tooltip: 'Add Custom Category',
                    onPressed: _showAddCategoryDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // DatePicker (Date) and TextButton (Change Date).
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Change Date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ElevatedButton (Save Expense).
              ElevatedButton.icon(
                onPressed: _submitExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.expenseDark,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Save Expense Entry',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
