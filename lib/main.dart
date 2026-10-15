import 'package:flutter/material.dart';
import 'resource/resource.dart' show AppAnimations, AppColors, AppFonts;
import 'models/expense.dart';
import 'services/storage_service.dart';
import 'widgets/glass_bottom_nav.dart';

// Import all pages
import 'screens/dashboard_page.dart';
import 'screens/add_salary_page.dart';
import 'screens/add_expense_page.dart';
import 'screens/transaction_list_page.dart';
import 'screens/search_page.dart';
import 'screens/categories_page.dart';
import 'screens/budget_page.dart';
import 'screens/currency_settings_page.dart';
import 'screens/about_page.dart';
import 'screens/profile_settings_page.dart';
import 'screens/bills_page.dart';
import 'screens/subscriptions_page.dart';
import 'screens/notes_page.dart';
import 'screens/loans_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  final StorageService _storageService = StorageService();

  bool _isDarkMode = false;
  bool _enableNotifications = true;
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String _authScreenMode = 'login'; // 'login' or 'signup'

  @override
  void initState() {
    super.initState();
    _loadSettingsAndAuth();
  }

  Future<void> _loadSettingsAndAuth() async {
    const dark = true;
    final notif = await _storageService.loadNotifications();
    final loggedIn = await _storageService.isLoggedIn();

    setState(() {
      _isDarkMode = dark;
      _enableNotifications = notif;
      _isLoggedIn = loggedIn;
      _isLoading = false;
    });
  }

  void _toggleDarkMode(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    await _storageService.saveDarkMode(value);
  }

  void _toggleNotifications(bool value) async {
    setState(() {
      _enableNotifications = value;
    });
    await _storageService.saveNotifications(value);
  }

  void _handleLoginSuccess() async {
    await _storageService.setLoggedIn(true);
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLogout() async {
    await _storageService.setLoggedIn(false);
    setState(() {
      _isLoggedIn = false;
      _authScreenMode = 'login';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: Scaffold(
          body: Center(child: AppAnimations.loadingWidget()),
        ),
      );
    }

    final themeData = ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.poppins,
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );

    final darkThemeData = ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.poppins,
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );

    // Auth Guard
    if (!_isLoggedIn) {
      return MaterialApp(
        title: 'Expense Tracker Auth',
        debugShowCheckedModeBanner: false,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: themeData,
        darkTheme: darkThemeData,
        home: _authScreenMode == 'login'
            ? LoginPage(
                onLoginSuccess: _handleLoginSuccess,
                onNavigateToSignup: () => setState(() => _authScreenMode = 'signup'),
              )
            : SignupPage(
                onSignupSuccess: _handleLoginSuccess,
                onNavigateToLogin: () => setState(() => _authScreenMode = 'login'),
              ),
      );
    }

    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: themeData,
      darkTheme: darkThemeData,
      home: MainNavigationScreen(
        isDarkMode: _isDarkMode,
        enableNotifications: _enableNotifications,
        onToggleDarkMode: _toggleDarkMode,
        onToggleNotifications: _toggleNotifications,
        onLogout: _handleLogout,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool enableNotifications;
  final Function(bool) onToggleDarkMode;
  final Function(bool) onToggleNotifications;
  final VoidCallback onLogout;

  const MainNavigationScreen({
    super.key,
    required this.isDarkMode,
    required this.enableNotifications,
    required this.onToggleDarkMode,
    required this.onToggleNotifications,
    required this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StorageService _storageService = StorageService();

  List<TransactionItem> _transactions = [];
  double _budget = 2000.0;
  String _currencySymbol = '\$';
  List<String> _categories = [
    'Food',
    'Transport',
    'Bills',
    'Shopping',
    'Entertainment',
    'Health',
    'Other',
  ];
  Map<String, String> _userProfile = {
    'name': 'Alex Morgan',
    'email': 'alex.morgan@example.com',
    'salaryTarget': '5000.0',
  };
  bool _isLoading = true;
  int _currentPageIndex = 0;

  final List<String> _pageTitles = [
    'Dashboard Overview',
    'Add Salary / Income',
    'Log Expense',
    'All Transactions',
    'Search & Filter',
    'Categories Breakdown',
    'Monthly Budget',
    'Currency Settings',
    'App Info',
    'Profile & Settings',
    'Bills & Reminders',
    'Subscriptions',
    'Notes & Memos',
    'Loan Tracker',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final transactions = await _storageService.loadTransactions();
    final budget = await _storageService.loadBudget();
    final currency = await _storageService.loadCurrency();
    final categories = await _storageService.loadCategories();
    final profile = await _storageService.loadUserProfile();

    setState(() {
      _transactions = transactions;
      _budget = budget;
      _currencySymbol = currency;
      _categories = categories;
      _userProfile = profile;
      _isLoading = false;
    });
  }

  void _addTransaction(TransactionItem item) async {
    setState(() {
      _transactions.insert(0, item);
    });
    await _storageService.saveTransactions(_transactions);
  }

  void _deleteTransaction(String id) async {
    setState(() {
      _transactions.removeWhere((t) => t.id == id);
    });
    await _storageService.saveTransactions(_transactions);
  }

  void _updateBudget(double newBudget) async {
    setState(() {
      _budget = newBudget;
    });
    await _storageService.saveBudget(newBudget);
  }

  void _updateCurrency(String newSymbol) async {
    setState(() {
      _currencySymbol = newSymbol;
    });
    await _storageService.saveCurrency(newSymbol);
  }

  void _addCategory(String newCategory) async {
    if (!_categories.contains(newCategory)) {
      setState(() {
        _categories.add(newCategory);
      });
      await _storageService.saveCategories(_categories);
    }
  }

  void _updateUserProfile(String name, String email, String target) async {
    setState(() {
      _userProfile = {
        'name': name,
        'email': email,
        'salaryTarget': target,
      };
    });
    await _storageService.saveUserProfile(name, email, target);
  }

  void _clearAllData() async {
    await _storageService.clearAll();
    setState(() {
      _transactions = [];
      _budget = 2000.0;
      _currencySymbol = '\$';
    });
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<Widget> pages = [
      DashboardPage(
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        budget: _budget,
        onNavigateToPage: _navigateToPage,
        onDeleteTransaction: _deleteTransaction,
      ),
      AddSalaryPage(
        currencySymbol: _currencySymbol,
        onAddSalary: _addTransaction,
        onSuccess: () => _navigateToPage(0),
      ),
      AddExpensePage(
        currencySymbol: _currencySymbol,
        categories: _categories,
        onAddExpense: _addTransaction,
        onAddCategory: _addCategory,
        onSuccess: () => _navigateToPage(0),
      ),
      TransactionListPage(
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        onDeleteTransaction: _deleteTransaction,
      ),
      SearchPage(
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        onDeleteTransaction: _deleteTransaction,
      ),
      CategoriesPage(
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        categories: _categories,
        onAddCategory: _addCategory,
      ),
      BudgetPage(
        budget: _budget,
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        onUpdateBudget: _updateBudget,
      ),
      CurrencySettingsPage(
        currentCurrency: _currencySymbol,
        onSelectCurrency: _updateCurrency,
      ),
      AboutPage(
        onClearAllData: _clearAllData,
      ),
      ProfileSettingsPage(
        userProfile: _userProfile,
        transactions: _transactions,
        currencySymbol: _currencySymbol,
        budget: _budget,
        categories: _categories,
        isDarkMode: widget.isDarkMode,
        enableNotifications: widget.enableNotifications,
        onUpdateProfile: _updateUserProfile,
        onUpdateBudget: _updateBudget,
        onAddCategory: _addCategory,
        onToggleDarkMode: widget.onToggleDarkMode,
        onToggleNotifications: widget.onToggleNotifications,
        onUpdateCurrency: _updateCurrency,
        onResetData: _clearAllData,
        onLogout: widget.onLogout,
        onOpenMenu: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      BillsPage(
        currencySymbol: _currencySymbol,
      ),
      SubscriptionsPage(
        currencySymbol: _currencySymbol,
      ),
      const NotesPage(),
      LoansPage(
        currencySymbol: _currencySymbol,
      ),
    ];

    const navItems = [
      GlassNavItem(
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view,
        label: 'Dashboard',
      ),
      GlassNavItem(
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet,
        label: '+ Salary',
      ),
      GlassNavItem(
        icon: Icons.add_shopping_cart_outlined,
        selectedIcon: Icons.add_shopping_cart,
        label: '+ Expense',
      ),
      GlassNavItem(
        icon: Icons.search,
        selectedIcon: Icons.search,
        label: 'Search',
      ),
      GlassNavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    int getBottomNavIndex() {
      switch (_currentPageIndex) {
        case 0:
          return 0;
        case 1:
          return 1;
        case 2:
          return 2;
        case 4:
          return 3;
        case 8:
          return 4;
        case 9:
          return 4;
        default:
          return 0;
      }
    }

    final bottomNavPages = [0, 1, 2, 4, 9];

    // Scaffold: hosts the page AppBar, selected screen, and bottom navigation.
    return Scaffold(
      key: _scaffoldKey,
      extendBody: false,
      // AppBar: displays the title for the selected page.
      appBar: _currentPageIndex == 9
          ? null
          : AppBar(
              title: Text(
                _pageTitles[_currentPageIndex < _pageTitles.length ? _currentPageIndex : 0],
              ),
            ),
      drawer: Drawer(
        width: MediaQuery.sizeOf(context).width.clamp(0.0, 260.0).toDouble(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _userProfile['name'] ?? 'Expense Tracker',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(_userProfile['email'] ?? 'alex.morgan@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.white,
                child: Text(
                  (_userProfile['name'] ?? 'A')[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: AppColors.accent),
            ),
            _buildDrawerItem(0, Icons.dashboard, '1. Dashboard Overview'),
            _buildDrawerItem(9, Icons.person, '2. Profile & Settings'),
            _buildDrawerItem(1, Icons.account_balance_wallet, '3. Add Salary / Income'),
            _buildDrawerItem(2, Icons.add_shopping_cart, '4. Log Expense'),
            _buildDrawerItem(3, Icons.receipt_long, '5. All Transactions'),
            _buildDrawerItem(4, Icons.search, '6. Search & Filter'),
            _buildDrawerItem(5, Icons.category, '7. Categories Breakdown'),
            _buildDrawerItem(6, Icons.pie_chart, '8. Monthly Budget'),
            _buildDrawerItem(7, Icons.attach_money, '9. Currency Settings'),
            _buildDrawerItem(10, Icons.receipt_outlined, '10. Bills & Reminders'),
            _buildDrawerItem(11, Icons.subscriptions_outlined, '12. Subscriptions'),
            _buildDrawerItem(12, Icons.note_alt_outlined, '13. Notes & Memos'),
            _buildDrawerItem(13, Icons.handshake_outlined, '14. Loan Tracker'),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.expense),
              title: const Text('Log Out', style: TextStyle(color: AppColors.expense, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                widget.onLogout();
              },
            ),
          ],
        ),
      ),
      // IndexedStack: keeps the selected page, including AddExpensePage, in the body.
      body: IndexedStack(
        index: _currentPageIndex < pages.length ? _currentPageIndex : 0,
        children: pages,
      ),
      // BottomNavigationBar: app-wide navigation is provided by the shared shell.
      bottomNavigationBar: GlassBottomNav(
        selectedIndex: getBottomNavIndex(),
        onDestinationSelected: (tabIndex) {
          if (tabIndex >= 0 && tabIndex < bottomNavPages.length) {
            _navigateToPage(bottomNavPages[tabIndex]);
          }
        },
        items: navItems,
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    final isSelected = _currentPageIndex == index;
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.accent : theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.accent : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        _navigateToPage(index);
      },
    );
  }
}
