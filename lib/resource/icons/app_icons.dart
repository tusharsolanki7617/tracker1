/// ============================================================================
/// APP ICONS — Named path registry for all custom PNG icon assets.
/// ============================================================================
class AppIcons {
  AppIcons._();

  static const String _base = 'lib/resource/icons';

  // ── Navigation ─────────────────────────────────────────────────────────────
  static const String dashboard     = '$_base/ic_dashboard.png';
  static const String add           = '$_base/ic_add.png';
  static const String budget        = '$_base/ic_budget.png';
  static const String reports       = '$_base/ic_reports.png';
  static const String goals         = '$_base/ic_goals.png';
  static const String bills         = '$_base/ic_bills.png';
  static const String notes         = '$_base/ic_notes.png';
  static const String subscriptions = '$_base/ic_subscriptions.png';
  static const String loans         = '$_base/ic_loans.png';
  static const String tax           = '$_base/ic_tax.png';
  static const String export        = '$_base/ic_export.png';
  static const String profile       = '$_base/ic_profile.png';
  static const String settings      = '$_base/ic_settings.png';
  static const String search        = '$_base/ic_search.png';
  static const String analytics     = '$_base/ic_analytics.png';
  static const String netWorth      = '$_base/ic_net_worth.png';

  // ── Categories ─────────────────────────────────────────────────────────────
  static const String food          = '$_base/ic_food.png';
  static const String transport     = '$_base/ic_transport.png';
  static const String shopping      = '$_base/ic_shopping.png';
  static const String entertainment = '$_base/ic_entertainment.png';
  static const String health        = '$_base/ic_health.png';
  static const String education     = '$_base/ic_education.png';
  static const String salary        = '$_base/ic_salary.png';
  static const String investments   = '$_base/ic_investments.png';
  static const String other         = '$_base/ic_other.png';

  /// Returns the icon path for a given category string.
  static String forCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':          return food;
      case 'transport':     return transport;
      case 'bills':         return bills;
      case 'shopping':      return shopping;
      case 'entertainment': return entertainment;
      case 'health':        return health;
      case 'education':     return education;
      case 'salary':        return salary;
      case 'investments':   return investments;
      default:              return other;
    }
  }
}
