import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';

class TransactionListPage extends StatelessWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;
  final Function(String) onDeleteTransaction;

  const TransactionListPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold: root layout for the transaction screen
      body: SafeArea(
        // SafeArea: keeps the page content away from system UI areas
        child: Column(
          // Column: stacks the header, list, and bottom navigation vertically
          children: [
            // AppBar: top title bar for the transaction screen
            AppBar(
              title: const Text(''),
              backgroundColor: AppColors.transparent,
              elevation: 0,
            ),

            // Text: heading with the total number of transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'All Transactions (${transactions.length})',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // Expanded: list area fills remaining space below the title
            Expanded(
              child: transactions.isEmpty
                  ? const Center(
                      child: Text(
                        'No transactions recorded yet.\nTap "Add Salary" or "Add Expense" to get started!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.gray500, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      // ListView: displays the transaction list vertically
                      itemCount: transactions.length,
                      itemBuilder: (ctx, index) {
                        final item = transactions[index];
                        return ExpenseTile(
                          // ExpenseTile: visual row for each transaction item
                          item: item,
                          currencySymbol: currencySymbol,
                          onDelete: () => onDeleteTransaction(item.id),
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
