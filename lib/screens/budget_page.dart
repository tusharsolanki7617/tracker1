import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/resourse/resourse.dart';

class BudgetPage extends StatefulWidget {
  final double budget;
  final List<TransactionItem> transactions;
  final String currencySymbol;
  final Function(double) onUpdateBudget;

  const BudgetPage({
    super.key,
    required this.budget,
    required this.transactions,
    required this.currencySymbol,
    required this.onUpdateBudget,
  });

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _budgetController.text = widget.budget.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _showSetBudgetDialog() {
    _budgetController.text = widget.budget.toStringAsFixed(0);
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = AppColors.isDark(ctx);
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Set Monthly Budget',
            style: TextStyle(
              color: AppColors.textPrimary(ctx),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: _budgetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixText: widget.currencySymbol,
              labelText: 'Monthly Limit',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border(ctx)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border(ctx)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary(ctx)),
              ),
            ),
            TextButton(
              onPressed: () {
                final newBudget =
                    double.tryParse(_budgetController.text.trim());
                if (newBudget != null && newBudget > 0) {
                  widget.onUpdateBudget(newBudget);
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses =
        widget.transactions.where((t) => !t.isIncome).toList();
    final totalSpent =
        expenses.fold(0.0, (sum, item) => sum + item.amount);
    final remainingBudget = widget.budget - totalSpent;
    final progress = widget.budget > 0
        ? (totalSpent / widget.budget).clamp(0.0, 1.0)
        : 0.0;
    final isOverBudget = totalSpent > widget.budget;

    final progressColor = isOverBudget ? AppColors.expense : AppColors.income;
    final remainingColor =
        isOverBudget ? AppColors.expense : AppColors.income;

    return Scaffold(
      // Scaffold: root layout for the monthly budget screen
      body: SafeArea(
        // SafeArea: keeps the budget content clear of system UI areas
        child: Column(
          // Column: stacks the header, summary cards, and bottom navigation
          children: [
            // AppBar: top title bar for the budget page
            AppBar(
              title: const Text(''),
              backgroundColor: AppColors.transparent,
              elevation: 0,
            ),

            // Text: main heading for the budget tracker section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Monthly Budget Tracker',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Container: budget summary container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: budget limit header and edit action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Budget Limit',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      Text(
                        '${widget.currencySymbol}${widget.budget.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // LinearProgressIndicator: shows how much of the budget has been used
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.border(context),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Row: progress text and remaining/over status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% used',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted(context),
                        ),
                      ),
                      Text(
                        isOverBudget
                            ? '${(progress * 100 - 100).toStringAsFixed(0)}% over'
                            : '${(100 - progress * 100).toStringAsFixed(0)}% left',
                        style: TextStyle(
                          fontSize: 11,
                          color: remainingColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: AppColors.border(context), height: 1),
                  const SizedBox(height: 20),

                  // Row: total spent and remaining / over budget stat blocks
                  Row(
                    children: [
                      Expanded(
                        child: _BudgetStat(
                          label: 'Total Spent',
                          value: '${widget.currencySymbol}${totalSpent.toStringAsFixed(2)}',
                          valueColor: isOverBudget
                              ? AppColors.expense
                              : AppColors.textPrimary(context),
                          context: context,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: AppColors.border(context),
                      ),
                      Expanded(
                        child: _BudgetStat(
                          label: isOverBudget ? 'Over Limit By' : 'Remaining',
                          value: '${widget.currencySymbol}${remainingBudget.abs().toStringAsFixed(2)}',
                          valueColor: remainingColor,
                          context: context,
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Conditionally shown warning when spending exceeds the budget
            if (isOverBudget) ...[
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.expense.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.expense.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.expense, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Spending exceeded your monthly budget limit.',
                        style: TextStyle(
                          color: AppColors.expense,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // BottomNavigationBar: bottom navigation menu
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

class _BudgetStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final BuildContext context;
  final bool alignRight;

  const _BudgetStat({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.context,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: EdgeInsets.only(
        left: alignRight ? 20 : 0,
        right: alignRight ? 0 : 20,
      ),
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
