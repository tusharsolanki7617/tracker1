import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

class CurrencySettingsPage extends StatelessWidget {
  final String currentCurrency;
  final Function(String) onSelectCurrency;

  const CurrencySettingsPage({
    super.key,
    required this.currentCurrency,
    required this.onSelectCurrency,
  });

  final List<Map<String, String>> _currencyList = const [
    {'symbol': '\$', 'name': 'US Dollar (\$)'},
    {'symbol': '₹', 'name': 'Indian Rupee (₹)'},
    {'symbol': '€', 'name': 'Euro (€)'},
    {'symbol': '£', 'name': 'British Pound (£)'},
    {'symbol': '¥', 'name': 'Japanese Yen (¥)'},
    {'symbol': 'A\$', 'name': 'Australian Dollar (A\$)'},
    {'symbol': 'C\$', 'name': 'Canadian Dollar (C\$)'},
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold, AppBar, and BottomNavigationBar are provided by the parent screen.
    return SafeArea(
      // SafeArea protects the settings content from system display insets.
      child: Padding(
        padding: const EdgeInsets.all(16),
        // Column arranges the heading, description, and currency list vertically.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text (Currency Settings).
            const Text(
              'Currency Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // Text (Select Currency).
            const Text(
              'Select your preferred currency symbol to display throughout the app.',
              style: TextStyle(color: AppColors.gray500),
            ),
            const SizedBox(height: 16),

            // ListView displays each available currency as a radio option.
            Expanded(
              child: RadioGroup<String>(
                groupValue: currentCurrency,
                onChanged: (value) {
                  if (value == null) return;
                  onSelectCurrency(value);
                  final selectedCurrency = _currencyList.firstWhere(
                    (currency) => currency['symbol'] == value,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Currency updated to ${selectedCurrency['name']}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: ListView.builder(
                  itemCount: _currencyList.length,
                  itemBuilder: (ctx, index) {
                    final currency = _currencyList[index];
                    final symbol = currency['symbol']!;
                    final name = currency['name']!;

                    // RadioListTile represents one selectable currency.
                    return RadioListTile<String>(
                      value: symbol,
                      activeColor: AppColors.accent,
                      selected: symbol == currentCurrency,
                      title: Text('$symbol $name'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
