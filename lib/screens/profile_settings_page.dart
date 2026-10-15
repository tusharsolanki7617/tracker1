import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../resource/resource.dart';

class ProfileSettingsPage extends StatefulWidget {
  final Map<String, String> userProfile;
  final List<TransactionItem> transactions;
  final String currencySymbol;
  final double budget;
  final List<String>? categories;
  final bool isDarkMode;
  final bool enableNotifications;
  final Function(String name, String email, String salaryTarget)
  onUpdateProfile;
  final Function(double) onUpdateBudget;
  final Function(String)? onAddCategory;
  final Function(bool) onToggleDarkMode;
  final Function(bool) onToggleNotifications;
  final Function(String) onUpdateCurrency;
  final VoidCallback onResetData;
  final VoidCallback onLogout;
  final VoidCallback onOpenMenu;

  const ProfileSettingsPage({
    super.key,
    required this.userProfile,
    required this.transactions,
    required this.currencySymbol,
    required this.budget,
    required this.categories,
    required this.isDarkMode,
    required this.enableNotifications,
    required this.onUpdateProfile,
    required this.onUpdateBudget,
    required this.onAddCategory,
    required this.onToggleDarkMode,
    required this.onToggleNotifications,
    required this.onUpdateCurrency,
    required this.onResetData,
    required this.onLogout,
    required this.onOpenMenu,
  });

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _targetController;
  late TextEditingController _budgetController;
  final _newCategoryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userProfile['name'] ?? 'Alex Morgan',
    );
    _emailController = TextEditingController(
      text: widget.userProfile['email'] ?? 'alex@example.com',
    );
    _targetController = TextEditingController(
      text: widget.userProfile['salaryTarget'] ?? '5000',
    );
    _budgetController = TextEditingController(
      text: widget.budget.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _targetController.dispose();
    _budgetController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog() {
    _nameController.text = widget.userProfile['name'] ?? '';
    _emailController.text = widget.userProfile['email'] ?? '';
    _targetController.text = widget.userProfile['salaryTarget'] ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit User Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _targetController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Monthly Salary Goal',
                  prefixText: widget.currencySymbol,
                  prefixIcon: const Icon(Icons.flag),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = _nameController.text.trim();
              final newEmail = _emailController.text.trim();
              final newTarget = _targetController.text.trim();
              if (newName.isNotEmpty && newEmail.isNotEmpty) {
                widget.onUpdateProfile(newName, newEmail, newTarget);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                  ),
                );
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showSetBudgetDialog() {
    _budgetController.text = widget.budget.toStringAsFixed(0);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: _budgetController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixText: widget.currencySymbol,
            labelText: 'Monthly Limit',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(_budgetController.text.trim());
              if (newBudget != null && newBudget > 0) {
                widget.onUpdateBudget(newBudget);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Monthly budget updated to ${widget.currencySymbol}$newBudget',
                    ),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    _newCategoryController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Category'),
        content: TextField(
          controller: _newCategoryController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g. Travel, Gym, Education',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newCat = _newCategoryController.text.trim();
              if (newCat.isNotEmpty) {
                if (widget.onAddCategory != null) {
                  widget.onAddCategory!(newCat);
                }
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Category "$newCat" created successfully!'),
                  ),
                );
              }
            },
            child: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Financial metrics
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    final Map<String, double> categoryTotals = {};

    for (var t in widget.transactions) {
      if (t.isIncome) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
        categoryTotals[t.category] =
            (categoryTotals[t.category] ?? 0.0) + t.amount;
      }
    }

    final netSavings = totalIncome - totalExpense;
    final targetSalary =
        double.tryParse(widget.userProfile['salaryTarget'] ?? '5000') ?? 5000.0;
    final goalProgress = targetSalary > 0
        ? (totalIncome / targetSalary).clamp(0.0, 1.0)
        : 0.0;

    // Budget metrics
    final remainingBudget = widget.budget - totalExpense;
    final budgetProgress = widget.budget > 0
        ? (totalExpense / widget.budget).clamp(0.0, 1.0)
        : 0.0;
    final isOverBudget = totalExpense > widget.budget;

    // Sorted category entries
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final darkBackground = AppColors.bgDark;
    final panelColor = AppColors.surfaceDark;
    final panelSoft = AppColors.borderDark;
    final accentPurple = AppColors.accent;
    final accentGreen = AppColors.income;
    final accentRed = AppColors.expense;
    final textPrimary = AppColors.textPrimaryDark;
    final textSecondary = AppColors.textSecondaryDark;

    // Scaffold contains the profile page, drawer, and page-specific AppBar.
    return Scaffold(
      backgroundColor: darkBackground,
      // AppBar replaces the custom header row and opens the profile drawer.
      appBar: AppBar(
        backgroundColor: darkBackground,
        foregroundColor: textPrimary,
        leading: IconButton(
          tooltip: 'Open navigation menu',
          onPressed: widget.onOpenMenu,
          icon: Icon(Icons.menu, color: textPrimary),
        ),
        title: Text(
          'Profile & Settings',
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.poppins,
          ),
        ),
      ),
      // SafeArea keeps profile content clear of system display insets.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
          // SingleChildScrollView allows the full profile to scroll vertically.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Column orders the profile, salary target, summary, and logout sections.
              const SizedBox(height: 10),
              // Container (Profile) groups the avatar, user details, and edit button.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 22.0,
                ),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // CircleAvatar displays the user's initial.
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: accentPurple,
                          child: Text(
                            (widget.userProfile['name'] ?? 'U')[0]
                                .toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.editOverlay,
                            shape: BoxShape.circle,
                            border: Border.all(color: panelColor, width: 2),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: _showEditProfileDialog,
                            icon: const Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Text (User).
                    Text(
                      widget.userProfile['name'] ?? 'User',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text (Email).
                    Text(
                      widget.userProfile['email'] ?? 'User299@rku.ac.in',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 16,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 240,
                      // Button (Edit Profile & Goals).
                      child: OutlinedButton.icon(
                        onPressed: _showEditProfileDialog,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: AppColors.outlineMuted,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.edit_note,
                          color: AppColors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Edit Profile & Goals',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Container (Salary Target).
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Monthly Salary Target',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.poppins,
                          ),
                        ),
                        Text(
                          '${widget.currencySymbol}${totalIncome.toStringAsFixed(0)} / ${widget.currencySymbol}${targetSalary.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: accentGreen,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: goalProgress,
                        minHeight: 12,
                        backgroundColor: panelSoft,
                        valueColor: AlwaysStoppedAnimation<Color>(accentGreen),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Achieved ${(goalProgress * 100).toStringAsFixed(1)}% of your monthly goal.',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 14,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              // Container (Account Summary) groups the financial summary widgets.
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Summary',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.poppins,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                      children: [
                        _buildStatTile(
                          title: 'Total Earned',
                          value:
                              '${widget.currencySymbol}${totalIncome.toStringAsFixed(2)}',
                          icon: Icons.trending_up,
                          color: AppColors.income,
                          bgColor: panelColor,
                          iconColor: accentGreen,
                        ),
                        _buildStatTile(
                          title: 'Total Spent',
                          value:
                              '${widget.currencySymbol}${totalExpense.toStringAsFixed(2)}',
                          icon: Icons.trending_down,
                          color: AppColors.expense,
                          bgColor: panelColor,
                          iconColor: accentRed,
                        ),
                        _buildStatTile(
                          title: 'Net Savings',
                          value:
                              '${widget.currencySymbol}${netSavings.toStringAsFixed(2)}',
                          icon: Icons.account_balance,
                          color: AppColors.info,
                          bgColor: panelColor,
                          iconColor: AppColors.skyHighlight,
                        ),
                        _buildStatTile(
                          title: 'Transactions',
                          value: '${widget.transactions.length} items',
                          icon: Icons.receipt_long,
                          color: AppColors.accent,
                          bgColor: panelColor,
                          iconColor: AppColors.violetHighlight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Button (Log Out).
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.logout,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text(
                          'Are you sure you want to log out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.expense,
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              widget.onLogout();
                            },
                            child: const Text(
                              'Log Out',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
