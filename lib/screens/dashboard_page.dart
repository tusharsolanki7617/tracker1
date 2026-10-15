import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../widgets/resourse/resourse.dart';

class DashboardPage extends StatelessWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;
  final double budget;
  final Function(int) onNavigateToPage;
  final Function(String) onDeleteTransaction;

  const DashboardPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
    required this.budget,
    required this.onNavigateToPage,
    required this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var item in transactions) {
      if (item.isIncome) {
        totalIncome += item.amount;
      } else {
        totalExpense += item.amount;
      }
    }

    final netBalance = totalIncome - totalExpense;
    final isPositive = netBalance >= 0;

    return Scaffold(
      // Scaffold: root screen container for the dashboard
      body: SafeArea(
        // SafeArea: keeps content clear of notches and system overlays
        child: Column(
          // Column: vertically stacks the main dashboard widgets
          children: [
            // AppBar: top header for the dashboard screen
            AppBar(
              title: const Text(''),
              backgroundColor: AppColors.transparent,
              elevation: 0,
            ),

            // Container: net balance summary card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Balance',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currencySymbol${netBalance.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isPositive ? AppColors.white : AppColors.expense,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Row: income and expense cards side by side
                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          label: 'Income',
                          amount: '$currencySymbol${totalIncome.toStringAsFixed(2)}',
                          color: AppColors.income,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatChip(
                          label: 'Expenses',
                          amount: '$currencySymbol${totalExpense.toStringAsFixed(2)}',
                          color: AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Row: section header for recent activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onNavigateToPage(3),
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Expanded: transaction area fills the remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: transactions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No transactions yet',
                                style: TextStyle(
                                  color: AppColors.textSecondary(context),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        // Container: recent transaction list card
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          // ListView: shows recent transactions in a vertical list
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length > 5 ? 5 : transactions.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: AppColors.border(context),
                          ),
                          itemBuilder: (ctx, index) {
                            final item = transactions[index];
                            return ExpenseTile(
                              item: item,
                              currencySymbol: currencySymbol,
                              onDelete: () => onDeleteTransaction(item.id),
                            );
                          },
                        ),
                      ),
              ),
            ),

            // BottomNavigationBar: bottom menu navigation for the app
            BottomNavigationBar(
              currentIndex: 0,
              onTap: (index) => onNavigateToPage(index),
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

class _StatChip extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _StatChip({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container: summary chip used for income and expense values
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
