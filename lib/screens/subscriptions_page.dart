import 'package:flutter/material.dart';
import '../widgets/resourse/resourse.dart';

class _Sub {
  String id;
  String name;
  double amount;
  String cycle;
  String category;
  bool isActive;
  DateTime nextBilling;

  _Sub({
    required this.id,
    required this.name,
    required this.amount,
    required this.cycle,
    required this.category,
    required this.isActive,
    required this.nextBilling,
  });

  double get monthly => cycle == 'Yearly' ? amount / 12 : amount;
}

class SubscriptionsPage extends StatefulWidget {
  final String currencySymbol;
  const SubscriptionsPage({super.key, required this.currencySymbol});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  String _filterCategory = 'All';

  final List<_Sub> _subs = [
    _Sub(
      id: '1',
      name: 'Netflix',
      amount: 15,
      cycle: 'Monthly',
      category: 'Entertainment',
      isActive: true,
      nextBilling: DateTime.now().add(const Duration(days: 5)),
    ),
    _Sub(
      id: '2',
      name: 'Spotify',
      amount: 10,
      cycle: 'Monthly',
      category: 'Entertainment',
      isActive: true,
      nextBilling: DateTime.now().add(const Duration(days: 12)),
    ),
    _Sub(
      id: '3',
      name: 'iCloud',
      amount: 3,
      cycle: 'Monthly',
      category: 'Storage',
      isActive: true,
      nextBilling: DateTime.now().add(const Duration(days: 3)),
    ),
    _Sub(
      id: '4',
      name: 'Amazon Prime',
      amount: 139,
      cycle: 'Yearly',
      category: 'Shopping',
      isActive: true,
      nextBilling: DateTime.now().add(const Duration(days: 90)),
    ),
    _Sub(
      id: '5',
      name: 'Microsoft 365',
      amount: 70,
      cycle: 'Yearly',
      category: 'Productivity',
      isActive: false,
      nextBilling: DateTime.now().add(const Duration(days: 45)),
    ),
  ];

  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _cycle = 'Monthly';
  String _category = 'Entertainment';

  final List<String> _categories = [
    'Entertainment',
    'Storage',
    'Shopping',
    'Productivity',
    'Health',
    'Finance',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  List<String> get _allCategories {
    final cats = {'All', ..._subs.map((s) => s.category)}.toList();
    return cats;
  }

  List<_Sub> get _filtered {
    if (_filterCategory == 'All') return _subs;
    return _subs.where((s) => s.category == _filterCategory).toList();
  }

  double get _totalMonthly =>
      _subs.where((s) => s.isActive).fold(0.0, (sum, s) => sum + s.monthly);
  int get _activeCount => _subs.where((s) => s.isActive).length;
  int get _pausedCount => _subs.where((s) => !s.isActive).length;

  String _daysUntil(DateTime dt) {
    final diff = dt.difference(DateTime.now()).inDays;
    if (diff == 0) return 'Today';
    if (diff < 0) return 'Overdue';
    return 'In $diff days';
  }

  void _showAdd() {
    _nameCtrl.clear();
    _amountCtrl.clear();
    _cycle = 'Monthly';
    _category = 'Entertainment';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) {
          final isDark = AppColors.isDark(ctx);
          return AlertDialog(
            backgroundColor:
                isDark ? AppColors.cardDark : AppColors.cardLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Add Subscription',
              style: TextStyle(
                color: AppColors.textPrimary(ctx),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: widget.currencySymbol,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _cycle,
                    decoration: InputDecoration(
                      labelText: 'Billing Cycle',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Monthly', 'Yearly']
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setD(() => _cycle = v!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setD(() => _category = v!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary(ctx)),
                ),
              ),
              TextButton(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  final amount = double.tryParse(_amountCtrl.text) ?? 0;
                  if (name.isNotEmpty && amount > 0) {
                    setState(() {
                      _subs.add(_Sub(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        name: name,
                        amount: amount,
                        cycle: _cycle,
                        category: _category,
                        isActive: true,
                        nextBilling: DateTime.now().add(
                          _cycle == 'Monthly'
                              ? const Duration(days: 30)
                              : const Duration(days: 365),
                        ),
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    // Scaffold hosts the subscription screen; the parent provides the AppBar and bottom navigation.
    return Scaffold(
      backgroundColor: AppColors.background(context),
      // SafeArea keeps the subscription content clear of system display insets.
      body: SafeArea(
        child: Column(
          children: [
            // Column holds the monthly cost summary, filters, and subscription list.
            // Summary and category filters.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  // Container (Monthly Cost).
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 18),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monthly Cost',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.white.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.currencySymbol}${_totalMonthly.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.currencySymbol}${(_totalMonthly * 12).toStringAsFixed(0)}/yr',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white.withValues(alpha: 0.75),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                // Text (Active).
                                _badge('$_activeCount Active', AppColors.income),
                                if (_pausedCount > 0) ...[
                                  const SizedBox(width: 6),
                                  // Text (Paused).
                                  _badge('$_pausedCount Paused',
                                      AppColors.textSecondaryDark),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Horizontal category filter list.
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _allCategories.length,
                      separatorBuilder: (context, i) =>
                          const SizedBox(width: 6),
                      itemBuilder: (context, i) {
                        final cat = _allCategories[i];
                        final sel = _filterCategory == cat;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _filterCategory = cat),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.card(context),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppColors.primary
                                    : AppColors.border(context),
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                color: sel
                                    ? AppColors.white
                                    : AppColors.textSecondary(context),
                                fontWeight: sel
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ListView displays each subscription as a ListTile.
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No subscriptions',
                        style: TextStyle(color: AppColors.textMuted(context)),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: filtered.length,
                      separatorBuilder: (context, i) => Divider(
                        height: 1,
                        color: AppColors.border(context),
                      ),
                      itemBuilder: (context, i) {
                        final subscription = filtered[i];
                        return ListTile(
                          key: ValueKey(subscription.id),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            subscription.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: subscription.isActive
                                  ? AppColors.textPrimary(context)
                                  : AppColors.textMuted(context),
                              decoration: subscription.isActive
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${subscription.cycle} • ${subscription.category}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                              ),
                              if (subscription.isActive) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.dueSoon
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _daysUntil(subscription.nextBilling),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.dueSoon,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.currencySymbol}${subscription.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: subscription.isActive
                                      ? AppColors.textPrimary(context)
                                      : AppColors.textMuted(context),
                                ),
                              ),
                              Switch(
                                value: subscription.isActive,
                                onChanged: (value) => setState(
                                  () => subscription.isActive = value,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeThumbColor: AppColors.income,
                              ),
                              IconButton(
                                tooltip: 'Remove ${subscription.name}',
                                visualDensity: VisualDensity.compact,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () => setState(
                                  () => _subs.removeWhere(
                                    (item) => item.id == subscription.id,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.textMuted(context),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // FloatingActionButton opens the add-subscription form.
      floatingActionButton: FloatingActionButton(
        onPressed: _showAdd,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
