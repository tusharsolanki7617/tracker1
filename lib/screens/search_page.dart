import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';

class SearchPage extends StatefulWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;
  final Function(String) onDeleteTransaction;

  const SearchPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
    required this.onDeleteTransaction,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  String _selectedCategory = 'All';
  String _typeFilter = 'All'; // All, Income, Expense

  final List<String> _categories = [
    'All',
    'Salary',
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.transactions.where((item) {
      final matchesQuery = item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.category.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesType = _typeFilter == 'All' ||
          (_typeFilter == 'Income' && item.isIncome) ||
          (_typeFilter == 'Expense' && !item.isIncome);
      return matchesQuery && matchesCategory && matchesType;
    }).toList();

    // Scaffold, AppBar, and BottomNavigationBar are provided by the parent screen.
    return SafeArea(
      // SafeArea protects the search content from system display insets.
      child: Padding(
        padding: const EdgeInsets.all(16),
        // Column arranges the search field, match count, and results vertically.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField (Search).
            TextField(
              onChanged: (val) => setState(() => _query = val),
              decoration: InputDecoration(
                hintText: 'Search transaction title or category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Text (Matching Transactions).
            Text(
              'Found ${filteredList.length} matching transactions',
              style: const TextStyle(color: AppColors.gray500, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ListView renders matching transactions as reusable expense tiles.
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching transactions found.',
                        style: TextStyle(color: AppColors.gray500, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (ctx, index) {
                        final item = filteredList[index];
                        return ExpenseTile(
                          item: item,
                          currencySymbol: widget.currencySymbol,
                          onDelete: () => widget.onDeleteTransaction(item.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
