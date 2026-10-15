import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const String _transactionsKey = 'tracker_transactions';
  static const String _budgetKey = 'tracker_monthly_budget';
  static const String _currencyKey = 'tracker_currency_symbol';
  static const String _categoriesKey = 'tracker_custom_categories';
  static const String _userNameKey = 'tracker_user_name';
  static const String _userEmailKey = 'tracker_user_email';
  static const String _userPasswordKey = 'tracker_user_password';
  static const String _isLoggedInKey = 'tracker_is_logged_in';
  static const String _userSalaryTargetKey = 'tracker_user_salary_target';
  static const String _darkModeKey = 'tracker_dark_mode';
  static const String _notificationsKey = 'tracker_notifications';

  final List<String> _defaultCategories = const [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];

  // Auth Methods
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setLoggedIn(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isLoggedInKey, status);
    } catch (e) {
      return false;
    }
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userNameKey, name);
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userPasswordKey, password);
      await prefs.setString(_transactionsKey, '[]');
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail =
          prefs.getString(_userEmailKey) ?? 'alex.morgan@example.com';
      final savedPassword = prefs.getString(_userPasswordKey) ?? '123456';

      if (email.trim().toLowerCase() == savedEmail.trim().toLowerCase() &&
          password == savedPassword) {
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Categories Storage
  Future<List<String>> loadCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedList = prefs.getStringList(_categoriesKey);
      if (savedList == null || savedList.isEmpty) {
        return List.from(_defaultCategories);
      }
      return savedList;
    } catch (e) {
      return List.from(_defaultCategories);
    }
  }

  Future<bool> saveCategories(List<String> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(_categoriesKey, categories);
    } catch (e) {
      return false;
    }
  }

  // Load list of transactions
  Future<List<TransactionItem>> loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_transactionsKey);
      if (jsonString == null || jsonString.isEmpty) {
        return _getSampleTransactions();
      }
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((item) => TransactionItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getSampleTransactions();
    }
  }

  // Save list of transactions
  Future<bool> saveTransactions(List<TransactionItem> transactions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = transactions.map((t) => t.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      return await prefs.setString(_transactionsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  // Load monthly budget
  Future<double> loadBudget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_budgetKey) ?? 2000.0;
    } catch (e) {
      return 2000.0;
    }
  }

  // Save monthly budget
  Future<bool> saveBudget(double budget) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(_budgetKey, budget);
    } catch (e) {
      return false;
    }
  }

  // Load currency symbol
  Future<String> loadCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currencyKey) ?? '\$';
    } catch (e) {
      return '\$';
    }
  }

  // Save currency symbol
  Future<bool> saveCurrency(String symbol) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_currencyKey, symbol);
    } catch (e) {
      return false;
    }
  }

  // User Profile Storage
  Future<Map<String, String>> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'name': prefs.getString(_userNameKey) ?? 'Alex Morgan',
        'email': prefs.getString(_userEmailKey) ?? 'alex.morgan@example.com',
        'salaryTarget': prefs.getString(_userSalaryTargetKey) ?? '5000.0',
      };
    } catch (e) {
      return {
        'name': 'Alex Morgan',
        'email': 'alex.morgan@example.com',
        'salaryTarget': '5000.0',
      };
    }
  }

  Future<bool> saveUserProfile(
    String name,
    String email,
    String salaryTarget,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userNameKey, name);
      await prefs.setString(_userEmailKey, email);
      return await prefs.setString(_userSalaryTargetKey, salaryTarget);
    } catch (e) {
      return false;
    }
  }

  // Theme & Settings Storage
  Future<bool> loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_darkModeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_darkModeKey, isDark);
    } catch (e) {
      return false;
    }
  }

  Future<bool> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_notificationsKey) ?? true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> saveNotifications(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_notificationsKey, enabled);
    } catch (e) {
      return false;
    }
  }

  // Clear all data
  Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }

  // Sample transactions for first-time app launch
  List<TransactionItem> _getSampleTransactions() {
    final now = DateTime.now();
    return [
      TransactionItem(
        id: '1',
        title: 'Monthly Salary',
        amount: 3500.0,
        category: 'Salary',
        date: now.subtract(const Duration(days: 5)),
        isIncome: true,
      ),
      TransactionItem(
        id: '2',
        title: 'Grocery Shopping',
        amount: 145.50,
        category: 'Food',
        date: now.subtract(const Duration(days: 3)),
        isIncome: false,
      ),
      TransactionItem(
        id: '3',
        title: 'Electricity Bill',
        amount: 85.00,
        category: 'Bills',
        date: now.subtract(const Duration(days: 2)),
        isIncome: false,
      ),
      TransactionItem(
        id: '4',
        title: 'Bus Pass',
        amount: 45.00,
        category: 'Transport',
        date: now.subtract(const Duration(days: 1)),
        isIncome: false,
      ),
    ];
  }
}
