import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';

class _Loan {
  String id;
  String person;
  double amount;
  bool isGiven;
  String note;
  bool isSettled;
  DateTime date;
  DateTime? dueDate;

  _Loan({
    required this.id,
    required this.person,
    required this.amount,
    required this.isGiven,
    required this.note,
    required this.isSettled,
    required this.date,
    this.dueDate,
  });

  bool get isOverdue => dueDate != null && !isSettled && dueDate!.isBefore(DateTime.now());
}

class LoansPage extends StatefulWidget {
  final String currencySymbol;
  const LoansPage({super.key, required this.currencySymbol});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final List<_Loan> _loans = [
    _Loan(
      id: '1',
      person: 'John',
      amount: 200,
      isGiven: true,
      note: 'For groceries',
      isSettled: false,
      date: DateTime.now().subtract(const Duration(days: 10)),
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    _Loan(
      id: '2',
      person: 'Sara',
      amount: 500,
      isGiven: true,
      note: 'Emergency',
      isSettled: false,
      date: DateTime.now().subtract(const Duration(days: 20)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _Loan(
      id: '3',
      person: 'Bank',
      amount: 5000,
      isGiven: false,
      note: 'Personal loan',
      isSettled: false,
      date: DateTime.now().subtract(const Duration(days: 30)),
    ),
    _Loan(
      id: '4',
      person: 'Mike',
      amount: 100,
      isGiven: true,
      note: 'Lunch money',
      isSettled: true,
      date: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  final _personCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _isGiven = true;
  bool _showSettled = false;

  @override
  void dispose() {
    _personCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  double get _totalLent => _loans.where((l) => l.isGiven && !l.isSettled).fold(0.0, (s, l) => s + l.amount);
  double get _totalOwed => _loans.where((l) => !l.isGiven && !l.isSettled).fold(0.0, (s, l) => s + l.amount);
  int get _overdueCount => _loans.where((l) => l.isOverdue).length;
  int get _settledCount => _loans.where((l) => l.isSettled).length;

  List<_Loan> get _displayLoans {
    final active = _loans.where((l) => !l.isSettled).toList();
    final settled = _loans.where((l) => l.isSettled).toList();
    return _showSettled ? [...active, ...settled] : active;
  }

  void _showAdd() {
    _personCtrl.clear();
    _amountCtrl.clear();
    _noteCtrl.clear();
    _isGiven = true;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setD) => AlertDialog(
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Add Loan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gray900 : AppColors.gray100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setD(() => _isGiven = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _isGiven
                                    ? (AppColors.textPrimary(context))
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'I Lent',
                                  style: TextStyle(
                                    color: _isGiven
                                        ? (AppColors.actionForeground(context))
                                        : (isDark ? AppColors.gray400 : AppColors.gray600),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setD(() => _isGiven = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !_isGiven
                                    ? (AppColors.textPrimary(context))
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'I Borrowed',
                                  style: TextStyle(
                                    color: !_isGiven
                                        ? (AppColors.actionForeground(context))
                                        : (isDark ? AppColors.gray400 : AppColors.gray600),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _personCtrl,
                    decoration: InputDecoration(
                      labelText: 'Person / Institution',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _amountCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '${widget.currencySymbol} ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(
                      labelText: 'Note (optional)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  final person = _personCtrl.text.trim();
                  final amount = double.tryParse(_amountCtrl.text) ?? 0;
                  if (person.isNotEmpty && amount > 0) {
                    setState(() {
                      _loans.add(_Loan(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        person: person,
                        amount: amount,
                        isGiven: _isGiven,
                        note: _noteCtrl.text.trim(),
                        isSettled: false,
                        date: DateTime.now(),
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Loan'),
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
    final loans = _displayLoans;
    final netBalance = _totalLent - _totalOwed;

    // Scaffold hosts the loans page; the parent screen provides the AppBar and bottom navigation.
    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      // SafeArea protects the loans content from system display insets.
      body: SafeArea(
        // Column holds the three balances, settled filter, and loan list.
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  // Container (You Lent).
                  _summaryCard(
                    'You Lent',
                    '${widget.currencySymbol}${_totalLent.toStringAsFixed(0)}',
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  // Container (You Owe).
                  _summaryCard(
                    'You Owe',
                    '${widget.currencySymbol}${_totalOwed.toStringAsFixed(0)}',
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  // Container (Net).
                  _summaryCard(
                    'Net',
                    '${netBalance < 0 ? '-' : ''}${widget.currencySymbol}${netBalance.abs().toStringAsFixed(2)}',
                    isDark,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (_overdueCount > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.gray800 : AppColors.gray100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? AppColors.gray700 : AppColors.gray300,
                        ),
                      ),
                      child: Text(
                        '$_overdueCount Overdue',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.gray300 : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    '$_settledCount Settled',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  const Spacer(),
                  // Switch (Show Settled).
                  const Text('Show Settled'),
                  Switch(
                    value: _showSettled,
                    onChanged: (value) => setState(() => _showSettled = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // ListView displays active and optionally settled loans as ListTiles.
            Expanded(
              child: loans.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.handshake_outlined,
                              size: 48,
                              color: isDark ? AppColors.gray700 : AppColors.gray400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No loans recorded',
                              style: TextStyle(
                                color: isDark ? AppColors.gray400 : AppColors.gray600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      itemCount: loans.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => _buildLoanCard(loans[index], isDark),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // FloatingActionButton: prompts the add loan dialog
        onPressed: _showAdd,
        backgroundColor: AppColors.textPrimary(context),
        foregroundColor: AppColors.actionForeground(context),
        elevation: 1,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'Add Loan',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String value, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.gray400 : AppColors.gray600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(_Loan l, bool isDark) {
    return Container(
      key: ValueKey(l.id),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.gray800 : AppColors.gray200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: isDark ? AppColors.gray900 : AppColors.gray100,
          child: Text(
            l.person.isNotEmpty ? l.person[0].toUpperCase() : '?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isDark ? AppColors.gray300 : AppColors.slate700,
            ),
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                l.person,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: l.isSettled ? TextDecoration.lineThrough : null,
                  color: l.isSettled
                      ? (isDark ? AppColors.gray600 : AppColors.gray400)
                      : (AppColors.textPrimary(context)),
                ),
              ),
            ),
            if (l.isOverdue && !l.isSettled) ...[
              const SizedBox(width: 6),
              _statusBadge('Overdue', isDark),
            ],
            if (l.isSettled) ...[
              const SizedBox(width: 6),
              _statusBadge('Settled', isDark),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (l.note.isNotEmpty) Text(l.note, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              '${l.isGiven ? 'Lent' : 'Borrowed'} on ${l.date.day}/${l.date.month}/${l.date.year}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.gray500 : AppColors.gray400,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${l.isGiven ? '+' : '-'}${widget.currencySymbol}${l.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: l.isSettled
                    ? (isDark ? AppColors.gray600 : AppColors.gray400)
                    : (AppColors.textPrimary(context)),
              ),
            ),
            IconButton(
              tooltip: l.isSettled ? 'Mark unsettled' : 'Mark settled',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              onPressed: () => setState(() => l.isSettled = !l.isSettled),
              icon: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: l.isSettled
                      ? (AppColors.textPrimary(context))
                      : AppColors.transparent,
                  border: Border.all(
                    color: l.isSettled
                        ? (AppColors.textPrimary(context))
                        : (isDark ? AppColors.gray700 : AppColors.gray400),
                    width: 1.5,
                  ),
                ),
                child: l.isSettled
                    ? Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.actionForeground(context),
                      )
                    : null,
              ),
            ),
            IconButton(
              tooltip: 'Delete loan',
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              onPressed: () => setState(() => _loans.removeWhere((x) => x.id == l.id)),
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
}
