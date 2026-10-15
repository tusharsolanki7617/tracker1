import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final TransactionItem item;
  final String currencySymbol;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.item,
    required this.currencySymbol,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'salary':
      case 'income':
        return Icons.account_balance_wallet;
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_bus;
      case 'bills':
        return Icons.receipt_long;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.medical_services;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category, bool isIncome) {
    if (isIncome) return AppColors.income;
    switch (category.toLowerCase()) {
      case 'food':
        return AppColors.warning;
      case 'transport':
        return AppColors.info;
      case 'bills':
        return AppColors.expense;
      case 'shopping':
        return AppColors.accent;
      case 'entertainment':
        return AppColors.catEntertainment;
      case 'health':
        return AppColors.catShopping;
      default:
        return AppColors.gray500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${item.date.day}/${item.date.month}/${item.date.year}';
    final categoryColor = _getCategoryColor(item.category, item.isIncome);
    final sign = item.isIncome ? '+' : '-';
    final amountColor = item.isIncome ? AppColors.incomeDark : AppColors.expenseDark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading icon
            CircleAvatar(
              backgroundColor: categoryColor.withValues(alpha: 0.15),
              child: Icon(
                _getCategoryIcon(item.category),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$sign$currencySymbol${item.amount.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Transaction'),
                        content: Text('Delete "${item.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              onDelete();
                            },
                            child: const Text('Delete', style: TextStyle(color: AppColors.expense)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.delete_outline, color: AppColors.gray500, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
