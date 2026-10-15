# Expense Tracker

A simple Flutter app to track your income and spending. Add your salary, log expenses, set a monthly budget, and see where your money goes — all stored locally on your device.

## Features

- 💰 **Add Salary** — record income entries
- 🧾 **Add Expense** — log spending with amount, category, and date
- 📊 **Budget** — set a monthly budget and track how much is left
- 🔍 **Search** — find transactions by name or category
- 🏷️ **Category** — organize expenses (Food, Transport, Bills, etc.)
- 💱 **Currency** — choose your preferred currency symbol

## Platform

- Android
- iOS

## Quick Start

### Requirements
- Flutter SDK (3.x or later)
- Dart (comes with Flutter)
- Android Studio / Xcode (for emulators) or a physical device

### Install

```bash
git clone https://github.com/your-username/expense-tracker.git
cd expense-tracker
flutter pub get
```

### Run

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── expense.dart        # Expense data model
├── screens/
│   ├── home_screen.dart    # Dashboard / transaction list
│   ├── add_expense_screen.dart
│   └── budget_screen.dart
├── widgets/
│   └── expense_tile.dart   # Reusable list item widget
└── services/
    └── storage_service.dart # Local persistence (e.g. shared_preferences / sqflite)
```

## Code Example: Adding an Expense

A minimal example of the `Expense` model and adding a new entry to a local list:

```dart
// models/expense.dart
class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
```

```dart
// Adding a new expense to the list
List<Expense> expenses = [];

void addExpense(String title, double amount, String category) {
  final newExpense = Expense(
    title: title,
    amount: amount,
    category: category,
    date: DateTime.now(),
  );

  expenses.add(newExpense);
}
```

## Usage

1. Open the app and add your salary on the home screen.
2. Tap **Add Expense** to log a purchase with a title, amount, and category.
3. Set a monthly budget under **Budget** to track remaining balance.
4. Use the **Search** bar to quickly find past transactions.
5. Change your currency symbol in **Settings**.

## Known Limitations

- Single-user only, no accounts or login
- Data is stored locally on the device — no cloud backup or sync
- No backend/API integration in this MVP
- Uninstalling the app will erase all saved data

## Future Enhancements

- Cloud sync and multi-device support
- Charts and spending insights
- Recurring expenses / reminders
- Export data to CSV
- Multi-currency conversion