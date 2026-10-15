import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';

class Bill {
  String id;
  String name;
  double amount;
  int dueDayOfMonth; // 1-28
  String category;
  bool isPaid;
  IconData icon;

  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.dueDayOfMonth,
    required this.category,
    this.isPaid = false,
    required this.icon,
  });
}

class BillsPage extends StatefulWidget {
  final String currencySymbol;

  const BillsPage({super.key, required this.currencySymbol});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  final List<Bill> _bills = [
    Bill(id: '1', name: 'Internet', amount: 60, dueDayOfMonth: 5, category: 'Bills', icon: Icons.wifi),
    Bill(id: '2', name: 'Electricity', amount: 120, dueDayOfMonth: 10, category: 'Bills', icon: Icons.electric_bolt),
    Bill(id: '3', name: 'Netflix', amount: 15, dueDayOfMonth: 15, category: 'Entertainment', icon: Icons.movie_outlined),
    Bill(id: '4', name: 'Gym Membership', amount: 45, dueDayOfMonth: 1, category: 'Health', icon: Icons.fitness_center),
  ];

  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _dayCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _dayCtrl.dispose();
    super.dispose();
  }

  int get _currentDay => DateTime.now().day;

  bool _isOverdue(Bill b) => !b.isPaid && b.dueDayOfMonth < _currentDay;
  bool _isDueSoon(Bill b) => !b.isPaid && b.dueDayOfMonth >= _currentDay && b.dueDayOfMonth <= _currentDay + 3;

  double get _totalMonthly => _bills.fold(0.0, (s, b) => s + b.amount);
  double get _paidAmount => _bills.where((b) => b.isPaid).fold(0.0, (s, b) => s + b.amount);

  void _showAddBillDialog() {
    _nameCtrl.clear();
    _amountCtrl.clear();
    _dayCtrl.clear();
    IconData selectedIcon = Icons.receipt_long_outlined;

    final icons = [
      Icons.receipt_long_outlined,
      Icons.wifi,
      Icons.electric_bolt,
      Icons.movie_outlined,
      Icons.fitness_center,
      Icons.home_outlined,
      Icons.phone_android_outlined,
      Icons.water_drop_outlined,
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setD) => AlertDialog(
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Add Recurring Bill',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Bill Name',
                      hintText: 'e.g. Rent, Internet',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Monthly Amount',
                      prefixText: '${widget.currencySymbol} ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _dayCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Due Day (1-28)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Select Icon',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: icons.map((icon) {
                        final isSelected = selectedIcon == icon;
                        return GestureDetector(
                          onTap: () => setD(() => selectedIcon = icon),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (AppColors.textPrimary(context))
                                  : (isDark ? AppColors.gray900 : AppColors.gray100),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? (AppColors.textPrimary(context))
                                    : (isDark ? AppColors.gray800 : AppColors.gray300),
                              ),
                            ),
                            child: Icon(
                              icon,
                              size: 20,
                              color: isSelected
                                  ? (AppColors.actionForeground(context))
                                  : (isDark ? AppColors.gray400 : AppColors.gray700),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: isDark ? AppColors.gray400 : AppColors.gray600),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary(context),
                  foregroundColor: AppColors.actionForeground(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  final amount = double.tryParse(_amountCtrl.text) ?? 0;
                  final day = int.tryParse(_dayCtrl.text) ?? 0;
                  if (name.isNotEmpty && amount > 0 && day >= 1 && day <= 28) {
                    setState(() {
                      _bills.add(Bill(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        amount: amount,
                        dueDayOfMonth: day,
                        category: 'Bills',
                        icon: selectedIcon,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Bill'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overdue = _bills.where(_isOverdue).toList();
    final dueSoon = _bills.where(_isDueSoon).toList();
    final upcoming = _bills.where((b) => !b.isPaid && !_isOverdue(b) && !_isDueSoon(b)).toList();
    final paid = _bills.where((b) => b.isPaid).toList();
    final remaining = _totalMonthly - _paidAmount;

    // Scaffold hosts the bill screen; the parent provides the AppBar and bottom navigation.
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      // SafeArea keeps bill content clear of system display insets.
      body: SafeArea(
        // ListView scrolls the summary and all bill sections together.
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Container (Monthly Total).
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
                    'MONTHLY BILLS',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.currencySymbol}${_totalMonthly.toStringAsFixed(2)}',
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
                          'Total Bills',
                          '${_bills.length}',
                          isDark,
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      // Text (Paid).
                      Expanded(
                        child: _statItem(
                          'Paid',
                          '${widget.currencySymbol}${_paidAmount.toStringAsFixed(0)}',
                          isDark,
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      // Text (Remaining).
                      Expanded(
                        child: _statItem(
                          'Remaining',
                          '${widget.currencySymbol}${remaining.toStringAsFixed(0)}',
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            if (overdue.isNotEmpty) ...[
              // Text (Overdue) and the corresponding bill ListTiles.
              _sectionHeader('Overdue', overdue.length, isDark),
              ..._buildBillList(overdue, isDark),
              const SizedBox(height: 16),
            ],

            if (dueSoon.isNotEmpty) ...[
              // Text (Due Soon) and the corresponding bill ListTiles.
              _sectionHeader('Due Soon', dueSoon.length, isDark),
              ..._buildBillList(dueSoon, isDark),
              const SizedBox(height: 16),
            ],

            if (upcoming.isNotEmpty) ...[
              // Upcoming bill ListTiles.
              _sectionHeader('Upcoming', upcoming.length, isDark),
              ..._buildBillList(upcoming, isDark),
              const SizedBox(height: 16),
            ],

            if (paid.isNotEmpty) ...[
              _sectionHeader('Paid This Month', paid.length, isDark),
              ..._buildBillList(paid, isDark),
              const SizedBox(height: 16),
            ],

            if (_bills.isEmpty)
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
                        'No bills tracked yet',
                        style: TextStyle(
                          color: isDark ? AppColors.gray400 : AppColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Bill" to create a recurring reminder',
                        style: TextStyle(
                          color: isDark ? AppColors.gray600 : AppColors.gray400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      // FloatingActionButton (Add Bill).
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBillDialog,
        backgroundColor: AppColors.textPrimary(context),
        foregroundColor: AppColors.actionForeground(context),
        elevation: 1,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'Add Bill',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, int count, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.gray400 : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBillList(List<Bill> bills, bool isDark) {
    return bills
        .map((b) => _BillTile(
              bill: b,
              currencySymbol: widget.currencySymbol,
              isOverdue: _isOverdue(b),
              isDueSoon: _isDueSoon(b),
              onTogglePaid: () => setState(() {
                final idx = _bills.indexWhere((x) => x.id == b.id);
                if (idx >= 0) _bills[idx].isPaid = !_bills[idx].isPaid;
              }),
              onDelete: () => setState(() => _bills.removeWhere((x) => x.id == b.id)),
            ))
        .toList();
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

class _BillTile extends StatelessWidget {
  final Bill bill;
  final String currencySymbol;
  final bool isOverdue;
  final bool isDueSoon;
  final VoidCallback onTogglePaid;
  final VoidCallback onDelete;

  const _BillTile({
    required this.bill,
    required this.currencySymbol,
    required this.isOverdue,
    required this.isDueSoon,
    required this.onTogglePaid,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ListTile displays one bill and its paid/delete actions.
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray900 : AppColors.gray100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.gray800 : AppColors.gray200,
            ),
          ),
          child: Icon(
            bill.icon,
            size: 18,
            color: isDark ? AppColors.gray300 : AppColors.slate700,
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                bill.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: bill.isPaid ? TextDecoration.lineThrough : null,
                  color: bill.isPaid
                      ? (isDark ? AppColors.gray600 : AppColors.gray400)
                      : (AppColors.textPrimary(context)),
                ),
              ),
            ),
            if (isOverdue && !bill.isPaid) ...[
              const SizedBox(width: 6),
              _statusBadge('Overdue', isDark),
            ],
            if (isDueSoon && !bill.isPaid) ...[
              const SizedBox(width: 6),
              _statusBadge('Due soon', isDark),
            ],
          ],
        ),
        subtitle: Text(
          'Due: ${bill.dueDayOfMonth}${_ordinalSuffix(bill.dueDayOfMonth)} of each month',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.gray400 : AppColors.gray500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$currencySymbol${bill.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: bill.isPaid
                    ? (isDark ? AppColors.gray600 : AppColors.gray400)
                    : (AppColors.textPrimary(context)),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              tooltip: bill.isPaid ? 'Mark unpaid' : 'Mark paid',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              onPressed: onTogglePaid,
              icon: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bill.isPaid
                      ? (AppColors.textPrimary(context))
                      : AppColors.transparent,
                  border: Border.all(
                    color: bill.isPaid
                        ? (AppColors.textPrimary(context))
                        : (isDark ? AppColors.gray700 : AppColors.gray400),
                    width: 1.5,
                  ),
                ),
                child: bill.isPaid
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.actionForeground(context),
                      )
                    : null,
              ),
            ),
            IconButton(
              tooltip: 'Delete bill',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              onPressed: onDelete,
              icon: Icon(
                Icons.close,
                size: 16,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.gray300 : AppColors.gray700,
        ),
      ),
    );
  }

  String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
