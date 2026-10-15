import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../models/expense.dart';

class CategoriesPage extends StatefulWidget {
  final List<TransactionItem>? transactions;
  final String currencySymbol;
  final List<String>? categories;
  final Function(String)? onAddCategory;

  const CategoriesPage({
    super.key,
    this.transactions,
    required this.currencySymbol,
    this.categories,
    this.onAddCategory,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _categoryController = TextEditingController();

  final List<String> _defaultCategories = const [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    _categoryController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Custom Category'),
        content: TextField(
          controller: _categoryController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Travel, Gym, Education, Subscriptions',
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
              final newCat = _categoryController.text.trim();
              if (newCat.isNotEmpty) {
                if (widget.onAddCategory != null) {
                  widget.onAddCategory!(newCat);
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Category "$newCat" created successfully!')),
                );
              }
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeTransactions = widget.transactions ?? [];
    final safeCategories = (widget.categories != null && widget.categories!.isNotEmpty)
        ? widget.categories!
        : _defaultCategories;

    final Map<String, double> categoryTotals = {};
    double totalExpense = 0.0;

    for (var item in safeTransactions) {
      if (!item.isIncome) {
        categoryTotals[item.category] = (categoryTotals[item.category] ?? 0.0) + item.amount;
        totalExpense += item.amount;
      }
    }

    return Scaffold(
      // Scaffold: root screen container for the categories view
      body: SafeArea(
        // SafeArea: keeps the content away from device notches and status bars
        child: Column(
          // Column: stacks the screen header, summary, list, and bottom navigation
          children: [
            // AppBar: top header for the categories screen
            AppBar(
              title: const Text('Expense Categories'),
              backgroundColor: AppColors.transparent,
              elevation: 0,
            ),

            // Text: section title for category breakdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Expense Categories Breakdown',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Row: header actions with total and add button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Expenses: ${widget.currencySymbol}${totalExpense.toStringAsFixed(2)} • ${safeCategories.length} Total Categories',
                    style: const TextStyle(fontSize: 13, color: AppColors.gray500),
                  ),
                  FilledButton.icon(
                    // FilledButton.icon: opens the add category dialog
                    onPressed: _showAddCategoryDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Expanded: category list fills the remaining space
            Expanded(
              child: ListView.builder(
                // ListView: shows each category in a scrollable vertical list
                itemCount: safeCategories.length,
                itemBuilder: (ctx, index) {
                  final category = safeCategories[index];
                  final amount = categoryTotals[category] ?? 0.0;
                  final percentage = totalExpense > 0 ? (amount / totalExpense * 100) : 0.0;

                  return Card(
                    // Card: wraps each category item in a bordered panel
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.category, color: AppColors.accent, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${widget.currencySymbol}${amount.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: amount > 0 ? AppColors.accent : AppColors.gray500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            // LinearProgressIndicator: visual progress bar for category share
                            value: totalExpense > 0 ? amount / totalExpense : 0,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            color: AppColors.accentLight,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // BottomNavigationBar: bottom app navigation
            BottomNavigationBar(
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  label: 'Analytics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.wallet_outlined),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
