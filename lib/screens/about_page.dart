import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

class AboutPage extends StatelessWidget {
  final VoidCallback onClearAllData;

  const AboutPage({
    super.key,
    required this.onClearAllData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'App Info',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // App Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.accent,
                    child: Icon(Icons.account_balance_wallet, size: 40, color: AppColors.white),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Expense Tracker',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Version 1.0.0', style: TextStyle(color: AppColors.gray500)),
                  SizedBox(height: 12),
                  Text(
                    'A simple Flutter app to track your income and spending. All data is saved safely on your device using local storage.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Data Security & Storage Card
          const Card(
            child: ListTile(
              leading: Icon(Icons.security, color: AppColors.income),
              title: Text('Local Data Storage'),
              subtitle: Text('Your transactions and budget settings are saved locally on this device. No registration or cloud login required.'),
            ),
          ),
          const SizedBox(height: 12),

          // Clear Data Option
          Card(
            color: AppColors.errorSurface,
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: AppColors.expense),
              title: const Text('Reset App Data', style: TextStyle(color: AppColors.expense, fontWeight: FontWeight.bold)),
              subtitle: const Text('Delete all transactions and reset budget settings.'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset All Data?'),
                    content: const Text('Are you sure you want to clear all transactions and reset your budget? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.expense),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          onClearAllData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All data has been reset.')),
                          );
                        },
                        child: const Text('Reset', style: TextStyle(color: AppColors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
