import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';
import '../models/expense.dart';

class GoalsPage extends StatefulWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;

  const GoalsPage({
    super.key,
    required this.transactions,
    required this.currencySymbol,
  });

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _Goal {
  String name;
  double targetAmount;
  double savedAmount;
  IconData icon;
  DateTime? deadline;

  _Goal({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.icon,
    this.deadline,
  });

  double get progress => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => savedAmount >= targetAmount;
  int? get daysLeft => deadline?.difference(DateTime.now()).inDays;
}

class _GoalsPageState extends State<GoalsPage> {
  final List<_Goal> _goals = [
    _Goal(
      name: 'Emergency Fund',
      targetAmount: 5000,
      savedAmount: 1200,
      icon: Icons.shield_outlined,
      deadline: DateTime.now().add(const Duration(days: 90)),
    ),
    _Goal(
      name: 'Vacation',
      targetAmount: 2000,
      savedAmount: 750,
      icon: Icons.flight_outlined,
      deadline: DateTime.now().add(const Duration(days: 45)),
    ),
    _Goal(
      name: 'New Laptop',
      targetAmount: 1500,
      savedAmount: 1500,
      icon: Icons.laptop_outlined,
    ),
  ];

  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  double get _totalSavings {
    double sum = 0;
    for (final t in widget.transactions) {
      if (t.isIncome) {
        sum += t.amount;
      } else {
        sum -= t.amount;
      }
    }
    return sum.clamp(0.0, double.infinity);
  }

  void _showAddGoalDialog() {
    _nameCtrl.clear();
    _targetCtrl.clear();
    DateTime? selectedDeadline;
    IconData selectedIcon = Icons.flag_outlined;

    final icons = [
      Icons.flag_outlined,
      Icons.shield_outlined,
      Icons.flight_outlined,
      Icons.laptop_outlined,
      Icons.savings_outlined,
      Icons.home_outlined,
      Icons.directions_car_outlined,
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
              'Add New Goal',
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
                      labelText: 'Goal Name',
                      hintText: 'e.g. Vacation, Camera',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _targetCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Target Amount',
                      prefixText: '${widget.currencySymbol} ',
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
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setD(() => selectedDeadline = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? AppColors.gray700 : AppColors.gray400,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: isDark ? AppColors.gray400 : AppColors.gray600,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedDeadline == null
                                ? 'Target Date (optional)'
                                : '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}',
                            style: TextStyle(
                              color: selectedDeadline == null
                                  ? (isDark ? AppColors.gray500 : AppColors.gray500)
                                  : (AppColors.textPrimary(context)),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
                  final target = double.tryParse(_targetCtrl.text) ?? 0;
                  if (name.isNotEmpty && target > 0) {
                    setState(() {
                      _goals.add(_Goal(
                        name: name,
                        targetAmount: target,
                        savedAmount: 0,
                        icon: selectedIcon,
                        deadline: selectedDeadline,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Goal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteGoal(int index) {
    setState(() => _goals.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completed = _goals.where((g) => g.isCompleted).length;
    final totalTarget = _goals.fold(0.0, (s, g) => s + g.targetAmount);
    final totalSaved = _goals.fold(0.0, (s, g) => s + g.savedAmount);
    final overallProgress = totalTarget > 0 ? ((totalSaved / totalTarget) * 100).toStringAsFixed(0) : '0';

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Minimalist Clean Summary Card ──
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
                    'AVAILABLE SAVINGS',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.currencySymbol}${_totalSavings.toStringAsFixed(2)}',
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
                      Expanded(child: _statItem('Total Goals', '${_goals.length}', isDark)),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      Expanded(child: _statItem('Completed', '$completed', isDark)),
                      Container(
                        height: 28,
                        width: 1,
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                      ),
                      Expanded(child: _statItem('Progress', '$overallProgress%', isDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Section Title ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Goals',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  '$completed of ${_goals.length} completed',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Goals List ──
            if (_goals.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 48,
                        color: isDark ? AppColors.gray700 : AppColors.gray400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No goals yet',
                        style: TextStyle(
                          color: isDark ? AppColors.gray400 : AppColors.gray600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "New Goal" to get started',
                        style: TextStyle(
                          color: isDark ? AppColors.gray600 : AppColors.gray400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate(_goals.length, (i) {
                final g = _goals[i];
                return _GoalCard(
                  goal: g,
                  currencySymbol: widget.currencySymbol,
                  onDelete: () => _deleteGoal(i),
                  onAddSavings: (amount) {
                    setState(() {
                      _goals[i].savedAmount = (_goals[i].savedAmount + amount).clamp(0.0, _goals[i].targetAmount);
                    });
                  },
                );
              }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        backgroundColor: AppColors.textPrimary(context),
        foregroundColor: AppColors.actionForeground(context),
        elevation: 1,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'New Goal',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
            fontSize: 17,
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

class _GoalCard extends StatelessWidget {
  final _Goal goal;
  final String currencySymbol;
  final VoidCallback onDelete;
  final Function(double) onAddSavings;

  const _GoalCard({
    required this.goal,
    required this.currencySymbol,
    required this.onDelete,
    required this.onAddSavings,
  });

  void _showAddSavingsDialog(BuildContext context) {
    final ctrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Add to ${goal.name}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Amount to add',
            prefixText: '$currencySymbol ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              final amount = double.tryParse(ctrl.text) ?? 0;
              if (amount > 0) {
                onAddSavings(amount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = goal.targetAmount - goal.savedAmount;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray900 : AppColors.gray100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? AppColors.gray800 : AppColors.gray200,
                  ),
                ),
                child: Icon(
                  goal.icon,
                  size: 20,
                  color: isDark ? AppColors.gray300 : AppColors.slate700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            goal.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (goal.isCompleted) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.gray800 : AppColors.gray100,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark ? AppColors.gray700 : AppColors.gray300,
                              ),
                            ),
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.gray300 : AppColors.gray700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$currencySymbol${goal.savedAmount.toStringAsFixed(0)} of $currencySymbol${goal.targetAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.gray400 : AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(goal.progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Slim minimalist progress track
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.gray800 : AppColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textPrimary(context),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (!goal.isCompleted) ...[
                Text(
                  '$currencySymbol${remaining.toStringAsFixed(0)} left',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
                if (goal.daysLeft != null) ...[
                  Text(
                    ' · ',
                    style: TextStyle(
                      color: isDark ? AppColors.gray600 : AppColors.gray400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    goal.daysLeft! >= 0 ? '${goal.daysLeft}d left' : 'Overdue',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                    ),
                  ),
                ],
              ] else ...[
                Text(
                  'Goal achieved',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
              ],
              const Spacer(),
              if (!goal.isCompleted)
                InkWell(
                  onTap: () => _showAddSavingsDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? AppColors.gray700 : AppColors.gray300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          size: 14,
                          color: AppColors.textPrimary(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: isDark ? AppColors.gray500 : AppColors.gray400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
