import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

class TaxPage extends StatefulWidget {
  final String currencySymbol;
  const TaxPage({super.key, required this.currencySymbol});

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  final _incomeCtrl = TextEditingController();
  final _deductionCtrl = TextEditingController();
  String _taxRegion = 'Standard (25%)';
  double _taxableIncome = 0;
  double _taxOwed = 0;
  double _effectiveRate = 0;
  bool _calculated = false;

  final Map<String, List<Map<String, dynamic>>> _brackets = {
    'Standard (25%)': [
      {'min': 0, 'max': 50000, 'rate': 0.10},
      {'min': 50000, 'max': 100000, 'rate': 0.20},
      {'min': 100000, 'max': double.infinity, 'rate': 0.25},
    ],
    'Low Tax (15%)': [
      {'min': 0, 'max': 30000, 'rate': 0.05},
      {'min': 30000, 'max': 80000, 'rate': 0.10},
      {'min': 80000, 'max': double.infinity, 'rate': 0.15},
    ],
    'High Tax (35%)': [
      {'min': 0, 'max': 20000, 'rate': 0.10},
      {'min': 20000, 'max': 50000, 'rate': 0.20},
      {'min': 50000, 'max': 100000, 'rate': 0.30},
      {'min': 100000, 'max': double.infinity, 'rate': 0.35},
    ],
  };

  final List<Map<String, String>> _taxTips = [
    {'title': 'Max your deductions', 'body': 'Claim all eligible deductions — home office, education, medical, and charitable donations.'},
    {'title': 'Invest in tax-advantaged accounts', 'body': 'Contributions to retirement funds or health savings accounts can reduce your taxable income.'},
    {'title': 'Track business expenses', 'body': 'If self-employed, all legitimate business costs are deductible. Keep all receipts.'},
    {'title': 'Consider tax-loss harvesting', 'body': 'Sell loss-making investments to offset capital gains and reduce your overall tax bill.'},
  ];

  @override
  void dispose() {
    _incomeCtrl.dispose();
    _deductionCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    final income = double.tryParse(_incomeCtrl.text) ?? 0;
    final deductions = double.tryParse(_deductionCtrl.text) ?? 0;
    final taxable = (income - deductions).clamp(0.0, double.infinity);
    final brackets = _brackets[_taxRegion] ?? [];

    double tax = 0;
    for (final bracket in brackets) {
      final min = (bracket['min'] as num).toDouble();
      final max = (bracket['max'] as num).toDouble();
      final rate = (bracket['rate'] as num).toDouble();
      if (taxable <= min) { break; }
      final applicable = (taxable < max ? taxable : max) - min;
      tax += applicable * rate;
    }

    setState(() {
      _taxableIncome = taxable;
      _taxOwed = tax;
      _effectiveRate = taxable > 0 ? (tax / taxable * 100) : 0;
      _calculated = true;
    });
  }

  double get _income => double.tryParse(_incomeCtrl.text) ?? 0;
  double get _takeHome => _income - _taxOwed;
  double get _monthlyTax => _taxOwed / 12;
  double get _weeklyTakeHome => _takeHome / 52;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brackets = _brackets[_taxRegion] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tax Estimator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Estimate your annual income tax', style: TextStyle(fontSize: 12, color: AppColors.gray500)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _incomeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Annual Gross Income',
                      prefixText: widget.currencySymbol,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    onChanged: (_) => setState(() => _calculated = false),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _deductionCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Deductions / Allowances',
                      prefixText: widget.currencySymbol,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.remove_circle_outline),
                    ),
                    onChanged: (_) => setState(() => _calculated = false),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _taxRegion,
                    decoration: const InputDecoration(labelText: 'Tax Bracket Model', border: OutlineInputBorder()),
                    items: _brackets.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                    onChanged: (v) => setState(() { _taxRegion = v!; _calculated = false; }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate_outlined),
                      label: const Text('Calculate Tax'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Results section
          if (_calculated) ...[
            const SizedBox(height: 20),
            const Text('Results', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 4 result chips
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: [
                _resultCard('Taxable Income', '${widget.currencySymbol}${_taxableIncome.toStringAsFixed(0)}', AppColors.info),
                _resultCard('Tax Owed', '${widget.currencySymbol}${_taxOwed.toStringAsFixed(0)}', AppColors.expense),
                _resultCard('Effective Rate', '${_effectiveRate.toStringAsFixed(1)}%', AppColors.warning),
                _resultCard('Monthly Tax', '${widget.currencySymbol}${_monthlyTax.toStringAsFixed(0)}/mo', AppColors.accent),
              ],
            ),
            const SizedBox(height: 12),

            // Take-home banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.income.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.income.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home_outlined, color: AppColors.income, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Annual Take-Home', style: TextStyle(fontSize: 12, color: AppColors.income)),
                        Text('${widget.currencySymbol}${_takeHome.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.income)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Monthly', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                      Text('${widget.currencySymbol}${(_takeHome / 12).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.income)),
                      const SizedBox(height: 4),
                      Text('Weekly', style: TextStyle(fontSize: 11, color: AppColors.gray500)),
                      Text('${widget.currencySymbol}${_weeklyTakeHome.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.income)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tax distribution bar
            const Text('Income Distribution', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_income > 0) ...[
              _distributionBar('Tax Paid', _taxOwed, _income, AppColors.expense),
              const SizedBox(height: 6),
              _distributionBar('Take-Home', _takeHome, _income, AppColors.income),
            ],
            const SizedBox(height: 20),
          ],

          // Bracket table
          const Text('Tax Brackets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(child: Text('Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                      Text('Rate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const Divider(),
                  ...brackets.map((b) {
                    final min = (b['min'] as num).toDouble();
                    final max = (b['max'] as num).toDouble();
                    final rate = (b['rate'] as num).toDouble();
                    final maxStr = max == double.infinity ? 'Above' : '${widget.currencySymbol}${max.toStringAsFixed(0)}';
                    final minStr = '${widget.currencySymbol}${min.toStringAsFixed(0)}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text('$minStr – $maxStr', style: const TextStyle(fontSize: 13))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text('${(rate * 100).toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 13)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Tax Saving Tips
          const Text('Tax Saving Tips', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._taxTips.map((tip) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tip['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 3),
                        Text(tip['body']!, style: TextStyle(fontSize: 12, color: AppColors.gray600, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _resultCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.gray600)),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _distributionBar(String label, double value, double total, Color color) {
    final pct = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.gray200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(pct * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
