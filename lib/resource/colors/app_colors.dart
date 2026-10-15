import 'package:flutter/material.dart';

/// ============================================================================
/// Single source of truth for app colors. Change a token here to update every
/// widget that uses that role; comments describe the intended UI usage.
/// ============================================================================
class AppColors {
  AppColors._(); // prevent instantiation

    // Brand tokens: app bars, primary actions, selected controls, and highlights.
    static const Color primary      = Color(0xFF0F172A); // Main brand surface and primary action.
    static const Color primaryLight = Color(0xFF1E293B); // Raised brand surface.
    static const Color primaryDark  = Color(0xFF020617); // Deep brand surface.
    static const Color accent       = Color(0xFF6366F1); // Selected controls and links.
    static const Color accentLight  = Color(0xFF818CF8); // Light accent state.
    static const Color accentDark   = Color(0xFF4F46E5); // Pressed or high-contrast accent.

    // Financial tokens: positive, negative, balance, savings, and budget values.
    static const Color income       = Color(0xFF10B981); // Income and success states.
    static const Color incomeDark   = Color(0xFF059669); // Income emphasis and pressed state.
    static const Color expense      = Color(0xFFEF4444); // Expenses, errors, and destructive actions.
    static const Color expenseDark  = Color(0xFFDC2626); // Destructive emphasis and pressed state.
    static const Color netBalance   = Color(0xFF0F172A); // Net balance amount.
    static const Color savings      = Color(0xFF059669); // Savings amount and progress.
    static const Color budget       = Color(0xFF6366F1); // Budget totals and progress.

    // Light theme tokens: page, card, border, divider, and text colors.
    static const Color bgLight            = Color(0xFFF9FAFB); // Main light page background.
    static const Color surfaceLight       = Color(0xFFFFFFFF); // Light panels and menus.
    static const Color cardLight          = Color(0xFFFFFFFF); // Light cards and list items.
    static const Color borderLight        = Color(0xFFE2E8F0); // Light component outlines.
    static const Color borderSubtleLight  = Color(0xFFF1F5F9); // Low-contrast light outlines.
    static const Color dividerLight       = Color(0xFFF1F5F9); // Light list and section dividers.
    static const Color textPrimaryLight   = Color(0xFF0F172A); // Main light-theme text.
    static const Color textSecondaryLight = Color(0xFF64748B); // Supporting light-theme text.
    static const Color textMutedLight     = Color(0xFF94A3B8); // Hints and disabled light-theme text.

    // Dark theme tokens: page, card, border, divider, and text colors.
    static const Color bgDark             = Color(0xFF121212); // Main dark page background.
    static const Color surfaceDark        = Color(0xFF1E1E1E); // Dark panels and menus.
    static const Color cardDark           = Color(0xFF1E1E1E); // Dark cards and list items.
    static const Color borderDark         = Color(0xFF2E2E2E); // Dark component outlines.
    static const Color borderSubtleDark   = Color(0xFF262626); // Low-contrast dark outlines.
    static const Color dividerDark        = Color(0xFF262626); // Dark list and section dividers.
    static const Color textPrimaryDark    = Color(0xFFFFFFFF); // Main dark-theme text.
    static const Color textSecondaryDark  = Color(0xFF94A3B8); // Supporting dark-theme text.
    static const Color textMutedDark      = Color(0xFF64748B); // Hints and disabled dark-theme text.

    // Neutral tokens: reusable greys for subtle fills, borders, and secondary copy.
    static const Color white = Color(0xFFFFFFFF); // Text and icons on dark or colored surfaces.
    static const Color black = Color(0xFF000000); // Scrims and dark image overlays.
    static const Color transparent = Color(0x00000000); // Transparent fills and borders.
    static const Color gray50 = Color(0xFFFAFAFA); // Lightest neutral surface.
    static const Color gray100 = Color(0xFFF5F5F5); // Subtle light surface.
    static const Color gray200 = Color(0xFFEEEEEE); // Light border and divider.
    static const Color gray300 = Color(0xFFE0E0E0); // Stronger light border.
    static const Color gray400 = Color(0xFFBDBDBD); // Muted light icon or text.
    static const Color gray500 = Color(0xFF9E9E9E); // Neutral secondary text.
    static const Color gray600 = Color(0xFF757575); // Stronger secondary text.
    static const Color gray700 = Color(0xFF616161); // Dark neutral text or icon.
    static const Color gray800 = Color(0xFF424242); // Dark border and control fill.
    static const Color gray900 = Color(0xFF212121); // Deep neutral surface.
    static const Color slate700 = Color(0xFF334155); // Dark-theme icon foreground.
    static const Color skyHighlight = Color(0xFF6EC4FF); // Net-savings summary icon.
    static const Color violetHighlight = Color(0xFF9378FF); // Transaction summary icon.
    static const Color editOverlay = Color(0xFF1A1E2B); // Profile avatar edit-button surface.
    static const Color outlineMuted = Color(0xFF707A8C); // Profile action-button outline.
    static const Color logout = Color(0xFFEE5E5E); // Logout action background.

    /// Theme-aware action fill: dark text on light mode, light fill on dark mode.
    static Color actionBackground(BuildContext context) =>
      isDark(context) ? textPrimaryDark : primary;

    /// Foreground paired with [actionBackground].
    static Color actionForeground(BuildContext context) =>
      isDark(context) ? primary : textPrimaryDark;

    /// Theme-aware subtle neutral surface for unselected controls and previews.
    static Color subtleSurface(BuildContext context) =>
      isDark(context) ? gray900 : gray100;

    /// Theme-aware subtle outline for unselected controls.
    static Color subtleOutline(BuildContext context) =>
      isDark(context) ? gray800 : gray200;

      /// Theme-aware supporting text used for descriptions and metadata.
      static Color supportingText(BuildContext context) =>
        isDark(context) ? gray400 : gray600;

      /// Theme-aware quiet text used for timestamps and secondary metadata.
      static Color quietText(BuildContext context) =>
        isDark(context) ? gray500 : gray500;

      /// Theme-aware disabled text and icons.
      static Color disabledContent(BuildContext context) =>
        isDark(context) ? gray600 : gray400;

      /// Theme-aware stronger outline for selected and focused controls.
      static Color strongOutline(BuildContext context) =>
        isDark(context) ? gray700 : gray300;

  // ── Status & Alerts ────────────────────────────────────────────────────────
  static const Color overdue   = Color(0xFFEF4444); // Overdue bills and loans.
  static const Color dueSoon   = Color(0xFFF59E0B); // Upcoming bill and loan reminders.
  static const Color completed = Color(0xFF10B981); // Completed tasks and paid items.
  static const Color pending   = Color(0xFF6366F1); // Pending goals and transactions.
  static const Color settled   = Color(0xFF64748B); // Settled loans and inactive records.
  static const Color warning   = Color(0xFFF59E0B); // Warnings and attention states.
  static const Color info      = Color(0xFF0EA5E9); // Informational icons and metrics.
  static const Color incomeLight = Color(0xFF34D399); // Light income-gradient endpoint.
  static const Color expenseLight = Color(0xFFFB7185); // Light expense-gradient endpoint.
  static const Color errorSurface = Color(0xFFFFEBEE); // Destructive-action confirmation surface.
  static const Color black87 = Color(0xDD000000); // High-contrast text on light previews.
  static const Color white70 = Color(0xB3FFFFFF); // Secondary text on dark brand surfaces.
  static const Color white80 = Color(0xCCFFFFFF); // Higher-contrast secondary glass text.
  static const Color white54 = Color(0x8AFFFFFF); // Muted icons on dark brand surfaces.

  // Navigation tokens: background and inactive destination colors.
  static const Color navSurfaceLight = Color(0xFFF3EDF7); // Light bottom navigation surface.
  static const Color navSurfaceDark = Color(0xFF1D1B20); // Dark bottom navigation surface.
  static const Color navItemLight = Color(0xFF1D192B); // Light navigation labels and icons.
  static const Color navItemDark = Color(0xFFE6E0E9); // Dark navigation labels and icons.

  // Legacy liquid-glass theme tokens, retained as aliases for its existing widgets.
  static const Color indigo900 = primaryDark; // Deep glass-theme background.
  static const Color indigo700 = primary; // Main glass-theme background.
  static const Color violet600 = accentDark; // Glass-theme accent.
  static const Color violet400 = accentLight; // Soft glass-theme accent.
  static const Color rose500 = expense; // Glass-theme negative accent.
  static const Color rose300 = expenseLight; // Soft negative accent.
  static const Color cyan400 = info; // Glass-theme informational accent.
  static const Color emerald400 = incomeLight; // Glass-theme positive accent.
  static const Color amber400 = warning; // Glass-theme warning accent.

  // ── Health Indicators ─────────────────────────────────────────────────────
  static const Color healthGood = Color(0xFF10B981); // Healthy financial status.
  static const Color healthFair = Color(0xFFF59E0B); // Cautionary financial status.
  static const Color healthRisk = Color(0xFFEF4444); // At-risk financial status.

  // ── Category Palette ──────────────────────────────────────────────────────
  static const Color catFood          = Color(0xFFF97316); // Food-category charts and icons.
  static const Color catTransport     = Color(0xFF8B5CF6); // Transport-category charts and icons.
  static const Color catBills         = Color(0xFF3B82F6); // Bills-category charts and icons.
  static const Color catShopping      = Color(0xFF14B8A6); // Shopping-category charts and icons.
  static const Color catEntertainment = Color(0xFFEC4899); // Entertainment-category charts and icons.
  static const Color catHealth        = Color(0xFF10B981); // Health-category charts and icons.
  static const Color catEducation     = Color(0xFF6366F1); // Education-category charts and icons.
  static const Color catSalary        = Color(0xFF059669); // Salary-category charts and icons.
  static const Color catInvestments   = Color(0xFF0284C7); // Investment-category charts and icons.
  static const Color catOther         = Color(0xFF64748B); // Fallback category color.

  /// Return category color by category name.
  static Color forCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':          return catFood;
      case 'transport':     return catTransport;
      case 'bills':         return catBills;
      case 'shopping':      return catShopping;
      case 'entertainment': return catEntertainment;
      case 'health':        return catHealth;
      case 'education':     return catEducation;
      case 'salary':        return catSalary;
      case 'investments':   return catInvestments;
      default:              return catOther;
    }
  }

  // ── Glassmorphism ─────────────────────────────────────────────────────────
  static const Color glassWhite   = Color(0x18FFFFFF); // Translucent glass surface tint.
  static const Color glassBorder  = Color(0x35FFFFFF); // Glass-container outline.
  static const Color glassShimmer = Color(0x60FFFFFF); // Glass shimmer highlight.
  static const Color glassDark    = Color(0x22000000); // Dark glass overlay.

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient incomeGradient = LinearGradient(
    colors: [incomeDark, incomeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [expenseDark, expenseLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentDark, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x22FFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Theme-aware Helpers ────────────────────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? bgDark : bgLight;

  static Color surface(BuildContext context) =>
      isDark(context) ? surfaceDark : surfaceLight;

  static Color card(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;

  static Color border(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  static Color borderSubtle(BuildContext context) =>
      isDark(context) ? borderSubtleDark : borderSubtleLight;

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? textPrimaryDark : textPrimaryLight;

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondaryLight;

  static Color textMuted(BuildContext context) =>
      isDark(context) ? textMutedDark : textMutedLight;

  static Color divider(BuildContext context) =>
      isDark(context) ? dividerDark : dividerLight;
}
