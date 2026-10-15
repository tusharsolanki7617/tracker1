import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../models/expense.dart';

class AddSalaryPage extends StatefulWidget {
  final String currencySymbol;
  final Function(TransactionItem) onAddSalary;
  final VoidCallback? onSuccess;

  const AddSalaryPage({
    super.key,
    required this.currencySymbol,
    required this.onAddSalary,
    this.onSuccess,
  });

  @override
  State<AddSalaryPage> createState() => _AddSalaryPageState();
}

class _AddSalaryPageState extends State<AddSalaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Monthly Salary');
  final _amountController = TextEditingController();

  String _selectedCategory = 'Salary';
  DateTime _selectedDate = DateTime.now();

  final List<String> _incomeCategories = [
    'Salary',
    'Bonus',
    'Investment',
    'Freelance',
    'Other Income',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitSalary() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      final newSalaryItem = TransactionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
        isIncome: true,
      );

      widget.onAddSalary(newSalaryItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salary of ${widget.currencySymbol}$amount added successfully!'),
          backgroundColor: AppColors.incomeDark,
        ),
      );

      _amountController.clear();
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold, AppBar, and BottomNavigationBar are provided by the parent screen.
    return SafeArea(
      // SafeArea keeps the form clear of system display insets.
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // SingleChildScrollView contains the validated salary form.
        child: Form(
          key: _formKey,
          // Column arranges the income form controls vertically.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text: Add Income / Salary.
              const Text(
                'Add Income / Salary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // TextField (Income Source Title).
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Income Source Title',
                  prefixIcon: Icon(Icons.work_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),

              // TextField (Salary / Income Amount).
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Salary / Income Amount',
                  prefixText: widget.currencySymbol,
                  prefixIcon: const Icon(Icons.payments_outlined),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter salary amount';
                  }
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // DropdownButton (Income Category).
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Income Category',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _incomeCategories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
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

              // ElevatedButton (Save Income).
              ElevatedButton.icon(
                onPressed: _submitSalary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.incomeDark,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Save Income Entry',
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
