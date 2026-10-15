import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/resourse/resourse.dart';

class AnalyticsPage extends StatelessWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;

  const AnalyticsPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    TransactionItem? highestExpense;

    for (var item in transactions) {
      if (item.isIncome) {
        totalIncome += item.amount;
      } else {
        totalExpense += item.amount;
        if (highestExpense == null || item.amount > highestExpense.amount) {
          highestExpense = item;
        }
      }
    }

    final totalCount = transactions.length;
    final avgExpense = transactions.where((t) => !t.isIncome).isEmpty
        ? 0.0
        : totalExpense / transactions.where((t) => !t.isIncome).length;
    final savingsRatio = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome * 100)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),

          // ── Stats Grid ────────────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatCard(
                title: 'Total Transactions',
                value: '$totalCount',
                icon: Icons.receipt_long_outlined,
                context: context,
              ),
              _StatCard(
                title: 'Avg Expense',
                value: '$currencySymbol${avgExpense.toStringAsFixed(2)}',
                icon: Icons.trending_up_outlined,
                context: context,
              ),
              _StatCard(
                title: 'Savings Ratio',
                value: '${savingsRatio.toStringAsFixed(1)}%',
                icon: Icons.savings_outlined,
                valueColor: savingsRatio >= 0
                    ? AppColors.income
                    : AppColors.expense,
                context: context,
              ),
              _StatCard(
                title: 'Top Category',
                value: highestExpense != null
                    ? highestExpense.category
                    : 'N/A',
                icon: Icons.category_outlined,
                context: context,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Highest Single Expense ────────────────────────────────────────
          if (highestExpense != null) ...[
            Text(
              'Highest Expense',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.expense.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: AppColors.expense,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          highestExpense.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          highestExpense.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$currencySymbol${highestExpense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final BuildContext context;
  final Color? valueColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.context,
    this.valueColor,
  });

  @override
  Widget build(BuildContext buildContext) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.textSecondary(context),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
