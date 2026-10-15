import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker1/main.dart';
import 'package:tracker1/screens/profile_settings_page.dart';
import 'package:tracker1/services/storage_service.dart';

void main() {
  test('new account starts with no transactions', () async {
    SharedPreferences.setMockInitialValues({
      'tracker_transactions':
          '[{"id":"demo","title":"Demo","amount":10,"category":"Food","date":"2026-10-15T00:00:00.000","isIncome":false}]',
    });
    final storageService = StorageService();

    expect(
      await storageService.registerUser(
        'Taylor',
        'taylor@example.com',
        'password',
      ),
      isTrue,
    );
    expect(await storageService.loadTransactions(), isEmpty);
  });

  testWidgets('Expense tracker app loads successfully', (
    WidgetTester tester,
  ) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(const ExpenseTrackerApp());
    expect(find.byType(ExpenseTrackerApp), findsOneWidget);
  });

  testWidgets('Profile fits narrow screens and shows drawer labels', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() async => tester.binding.setSurfaceSize(null));
    final scaffoldKey = GlobalKey<ScaffoldState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: ListView(
              children: const [
                ListTile(title: Text('1. Dashboard Overview')),
                ListTile(title: Text('14. Loan Tracker')),
                ListTile(title: Text('Log Out')),
              ],
            ),
          ),
          body: ProfileSettingsPage(
            userProfile: const {
              'name': 'Alex Morgan',
              'email': 'alex@example.com',
              'salaryTarget': '5000',
            },
            transactions: const [],
            currencySymbol: '\$',
            budget: 2000,
            categories: const [],
            isDarkMode: true,
            enableNotifications: true,
            onUpdateProfile: (name, email, target) {},
            onUpdateBudget: (budget) {},
            onAddCategory: (category) {},
            onToggleDarkMode: (enabled) {},
            onToggleNotifications: (enabled) {},
            onUpdateCurrency: (currency) {},
            onResetData: () {},
            onLogout: () {},
            onOpenMenu: () => scaffoldKey.currentState!.openDrawer(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('1. Dashboard Overview'), findsOneWidget);
    expect(find.text('14. Loan Tracker'), findsOneWidget);
    expect(find.text('Log Out'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
