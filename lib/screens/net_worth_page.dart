import 'package:flutter/material.dart';
import '../resource/colors/app_colors.dart';
import '../models/expense.dart';

class NetWorthPage extends StatefulWidget {
  final List<TransactionItem> transactions;
  final String currencySymbol;
  const NetWorthPage({super.key, required this.transactions, required this.currencySymbol});

  @override
  State<NetWorthPage> createState() => _NetWorthPageState();
}

class _Item {
  String id;
  String name;
  double value;
  bool isAsset;
  String category;

  _Item({
    required this.id,
    required this.name,
    required this.value,
    required this.isAsset,
    required this.category,
  });
}

class _NetWorthPageState extends State<NetWorthPage> {
  final List<_Item> _items = [
    _Item(id: '1', name: 'Savings Account', value: 8500, isAsset: true, category: 'Cash'),
    _Item(id: '2', name: 'Investment Portfolio', value: 12000, isAsset: true, category: 'Investments'),
    _Item(id: '3', name: 'Car', value: 15000, isAsset: true, category: 'Property'),
    _Item(id: '4', name: 'Credit Card Debt', value: 2000, isAsset: false, category: 'Debt'),
    _Item(id: '5', name: 'Student Loan', value: 8000, isAsset: false, category: 'Loans'),
  ];

  final _nameCtrl = TextEditingController();
  final _valueCtrl = TextEditingController();
  bool _addAsAsset = true;
  String _category = 'Cash';
  bool _showBreakdown = true;

  final List<String> _assetCategories = ['Cash', 'Investments', 'Property', 'Vehicles', 'Other'];
  final List<String> _liabilityCategories = ['Debt', 'Loans', 'Mortgage', 'Other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  double get _totalAssets => _items.where((i) => i.isAsset).fold(0.0, (s, i) => s + i.value);
  double get _totalLiabilities => _items.where((i) => !i.isAsset).fold(0.0, (s, i) => s + i.value);
  double get _netWorth => _totalAssets - _totalLiabilities;
  double get _debtRatio => _totalAssets > 0 ? (_totalLiabilities / _totalAssets * 100) : 0;

  Map<String, double> get _assetBreakdown {
    final map = <String, double>{};
    for (final i in _items.where((x) => x.isAsset)) {
      map[i.category] = (map[i.category] ?? 0) + i.value;
    }
    return map;
  }

  String _healthLabel() {
    if (_netWorth <= 0) return 'Negative';
    if (_debtRatio < 20) return 'Excellent';
    if (_debtRatio < 40) return 'Good';
    if (_debtRatio < 60) return 'Fair';
    return 'At Risk';
  }

  void _showAdd() {
    _nameCtrl.clear();
    _valueCtrl.clear();
    _addAsAsset = true;
    _category = 'Cash';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setD) => AlertDialog(
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Add Item',
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
                            onTap: () => setD(() {
                              _addAsAsset = true;
                              _category = 'Cash';
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _addAsAsset
                                    ? (AppColors.textPrimary(context))
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Asset',
                                  style: TextStyle(
                                    color: _addAsAsset
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
                            onTap: () => setD(() {
                              _addAsAsset = false;
                              _category = 'Debt';
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !_addAsAsset
                                    ? (AppColors.textPrimary(context))
                                    : AppColors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Liability',
                                  style: TextStyle(
                                    color: !_addAsAsset
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
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'e.g. Savings, Car, Loan',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _valueCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      prefixText: '${widget.currencySymbol} ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_addAsAsset),
                    initialValue: _category,
                    dropdownColor: isDark ? AppColors.surfaceDark : AppColors.white,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: (_addAsAsset ? _assetCategories : _liabilityCategories)
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
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
                  final value = double.tryParse(_valueCtrl.text) ?? 0;
                  if (name.isNotEmpty && value > 0) {
                    setState(() {
                      _items.add(_Item(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        value: value,
                        isAsset: _addAsAsset,
                        category: _category,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Item'),
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
    final assets = _items.where((i) => i.isAsset).toList();
    final liabilities = _items.where((i) => !i.isAsset).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── Minimalist Summary Card ──
          Container(
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
                  'NET WORTH',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_netWorth < 0 ? '-' : ''}${widget.currencySymbol}${_netWorth.abs().toStringAsFixed(0)}',
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
                        'Assets',
                        '${widget.currencySymbol}${_totalAssets.toStringAsFixed(0)}',
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
                        'Liabilities',
                        '${widget.currencySymbol}${_totalLiabilities.toStringAsFixed(0)}',
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
                        'Health',
                        _healthLabel(),
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Debt-to-Asset Ratio ──
          if (_totalAssets > 0) ...[
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Debt-to-Asset Ratio',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.gray400 : AppColors.gray600,
                        ),
                      ),
                      Text(
                        '${_debtRatio.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_debtRatio / 100).clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Asset Breakdown ──
          if (_assetBreakdown.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset Breakdown',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showBreakdown = !_showBreakdown),
                  child: Text(
                    _showBreakdown ? 'Hide' : 'Show',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_showBreakdown)
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
                  children: _assetBreakdown.entries.map((e) {
                    final pct = _totalAssets > 0 ? e.value / _totalAssets : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${widget.currencySymbol}${e.value.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(pct * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.gray400 : AppColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 5,
                              backgroundColor: isDark ? AppColors.gray800 : AppColors.gray100,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
          ],

          // ── Assets Section ──
          _sectionHeader('Assets', assets.length, isDark),
          const SizedBox(height: 10),
          if (assets.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'No assets added',
                style: TextStyle(
                  color: isDark ? AppColors.gray500 : AppColors.gray400,
                  fontSize: 13,
                ),
              ),
            )
          else
            ...assets.map((a) => _buildItemTile(a, isDark)),

          const SizedBox(height: 16),

          // ── Liabilities Section ──
          _sectionHeader('Liabilities', liabilities.length, isDark),
          const SizedBox(height: 10),
          if (liabilities.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'No liabilities added',
                style: TextStyle(
                  color: isDark ? AppColors.gray500 : AppColors.gray400,
                  fontSize: 13,
                ),
              ),
            )
          else
            ...liabilities.map((a) => _buildItemTile(a, isDark)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAdd,
        backgroundColor: AppColors.textPrimary(context),
        foregroundColor: AppColors.actionForeground(context),
        elevation: 1,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'Add Item',
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

  Widget _sectionHeader(String title, int count, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
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
    );
  }

  Widget _buildItemTile(_Item item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.gray400 : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${widget.currencySymbol}${item.value.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => _items.removeWhere((x) => x.id == item.id)),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
                color: isDark ? AppColors.gray600 : AppColors.gray400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
