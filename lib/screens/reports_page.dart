import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';
import '../models/expense.dart';

class ReportsPage extends StatefulWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;

  const ReportsPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
  });

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Week', 'This Month', 'Last Month', 'Last 3 Months', 'This Year'];

  List<TransactionItem> get _filtered {
    final now = DateTime.now();
    return widget.transactions.where((t) {
      switch (_selectedPeriod) {
        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          return t.date.isAfter(weekStart.subtract(const Duration(days: 1)));
        case 'This Month':
          return t.date.year == now.year && t.date.month == now.month;
        case 'Last Month':
          final lm = DateTime(now.year, now.month - 1);
          return t.date.year == lm.year && t.date.month == lm.month;
        case 'Last 3 Months':
          return t.date.isAfter(now.subtract(const Duration(days: 90)));
        case 'This Year':
          return t.date.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filtered;

    double totalIncome = 0;
    double totalExpense = 0;
    final Map<String, double> categoryBreakdown = {};

    for (final t in filtered) {
      if (t.isIncome) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
        categoryBreakdown[t.category] = (categoryBreakdown[t.category] ?? 0) + t.amount;
      }
    }

    final netBalance = totalIncome - totalExpense;
    final savingsRate = totalIncome > 0 ? ((netBalance / totalIncome) * 100).clamp(0.0, 100.0) : 0.0;

    // Sort categories by amount
    final sortedCategories = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Clean Minimal Period Filter ──
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _periods.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final isSelected = _periods[i] == _selectedPeriod;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = _periods[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (AppColors.textPrimary(context))
                            : (isDark ? AppColors.surfaceDark : AppColors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? (AppColors.textPrimary(context))
                              : (isDark ? AppColors.gray800 : AppColors.gray200),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _periods[i],
                        style: TextStyle(
                          color: isSelected
                              ? (AppColors.actionForeground(context))
                              : (isDark ? AppColors.gray400 : AppColors.gray600),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Minimalist Summary Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.gray800 : AppColors.gray200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NET BALANCE',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${netBalance < 0 ? '-' : ''}${widget.currencySymbol}${netBalance.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? AppColors.gray800 : AppColors.gray100,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _statItem(
                          'Income',
                          '${widget.currencySymbol}${totalIncome.toStringAsFixed(0)}',
                          isDark,
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      Expanded(
                        child: _statItem(
                          'Expense',
                          '${widget.currencySymbol}${totalExpense.toStringAsFixed(0)}',
                          isDark,
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      Expanded(
                        child: _statItem(
                          'Savings Rate',
                          '${savingsRate.toStringAsFixed(1)}%',
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Category Breakdown ──
            if (sortedCategories.isNotEmpty) ...[
              Text(
                'Expense by Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.gray800 : AppColors.gray200,
                  ),
                ),
                child: Column(
                  children: List.generate(sortedCategories.length, (index) {
                    final entry = sortedCategories[index];
                    final percent = totalExpense > 0 ? (entry.value / totalExpense * 100) : 0.0;
                    final isLast = index == sortedCategories.length - 1;

                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${widget.currencySymbol}${entry.value.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${percent.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percent / 100,
                              minHeight: 6,
                              backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Transactions Section ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions (${filtered.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: isDark ? AppColors.gray700 : AppColors.gray400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No transactions for $_selectedPeriod',
                        style: TextStyle(
                          color: isDark ? AppColors.gray400 : AppColors.gray500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.take(20).map((t) => _TransactionTile(
                    transaction: t,
                    currencySymbol: widget.currencySymbol,
                  )),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.gray400 : AppColors.gray500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionItem transaction;
  final String currencySymbol;

  const _TransactionTile({
    required this.transaction,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray900 : AppColors.gray100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.gray800 : AppColors.gray200,
              ),
            ),
            child: Icon(
              transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isDark ? AppColors.gray300 : AppColors.slate700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.isIncome ? '+' : '-'}$currencySymbol${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
