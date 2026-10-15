import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

/// ============================================================================
/// APP IMAGES — Centralized asset path registry & widget helpers.
/// Usage: AppImages.logo  →  'lib/resource/images/logo.png'
///        AppImages.logoWidget()  →  ready-to-use Widget
/// ============================================================================
class AppImages {
  AppImages._();

  static const String _base      = 'lib/resource';
  static const String _images    = '$_base/images';
  static const String _icons     = '$_base/icons';
  static const String _placehld  = '$_base/placeholders';
  static const String _anims     = '$_base/animations';

  // ── App Images ─────────────────────────────────────────────────────────────
  static const String logo                  = '$_images/logo.png';
  static const String logoSmall             = '$_images/logo_small.png';
  static const String banner                = '$_images/banner.png';
  static const String background            = '$_images/background.png';
  static const String onboarding1           = '$_images/onboarding_1.png';
  static const String onboarding2           = '$_images/onboarding_2.png';
  static const String onboarding3           = '$_images/onboarding_3.png';
  static const String illustrationAnalytics = '$_images/illustration_analytics.png';
  static const String illustrationSavings   = '$_images/illustration_savings.png';

  // ── Category Icons ─────────────────────────────────────────────────────────
  static const String icDashboard     = '$_icons/ic_dashboard.png';
  static const String icAdd           = '$_icons/ic_add.png';
  static const String icBudget        = '$_icons/ic_budget.png';
  static const String icReports       = '$_icons/ic_reports.png';
  static const String icGoals         = '$_icons/ic_goals.png';
  static const String icBills         = '$_icons/ic_bills.png';
  static const String icNotes         = '$_icons/ic_notes.png';
  static const String icSubscriptions = '$_icons/ic_subscriptions.png';
  static const String icLoans         = '$_icons/ic_loans.png';
  static const String icTax           = '$_icons/ic_tax.png';
  static const String icExport        = '$_icons/ic_export.png';
  static const String icProfile       = '$_icons/ic_profile.png';
  static const String icSettings      = '$_icons/ic_settings.png';
  static const String icSearch        = '$_icons/ic_search.png';
  static const String icAnalytics     = '$_icons/ic_analytics.png';
  static const String icNetWorth      = '$_icons/ic_net_worth.png';
  static const String icFood          = '$_icons/ic_food.png';
  static const String icTransport     = '$_icons/ic_transport.png';
  static const String icShopping      = '$_icons/ic_shopping.png';
  static const String icEntertainment = '$_icons/ic_entertainment.png';
  static const String icHealth        = '$_icons/ic_health.png';
  static const String icEducation     = '$_icons/ic_education.png';
  static const String icSalary        = '$_icons/ic_salary.png';
  static const String icInvestments   = '$_icons/ic_investments.png';
  static const String icOther         = '$_icons/ic_other.png';

  // ── Placeholders ───────────────────────────────────────────────────────────
  static const String emptyState       = '$_placehld/empty_state.png';
  static const String noInternet       = '$_placehld/no_internet.png';
  static const String placeholder      = '$_placehld/placeholder.png';
  static const String noData           = '$_placehld/no_data.png';
  static const String avatarPlaceholder= '$_placehld/avatar_placeholder.png';

  // ── Animations (static frames / Lottie placeholders) ──────────────────────
  static const String loading = '$_anims/loading.png';
  static const String success = '$_anims/success.png';

  // ── Widget Helpers ─────────────────────────────────────────────────────────

  /// App logo with graceful fallback
  static Widget logoWidget({double size = 48, BorderRadius? borderRadius}) {
    return Image.asset(
      logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
        child: const Icon(Icons.account_balance_wallet, color: AppColors.white),
      ),
    );
  }

  /// Avatar widget with fallback initial letter or icon
  static Widget avatarWidget({
    double radius = 24,
    String? name,
    String? imageUrl,
  }) {
    final label = (name != null && name.isNotEmpty)
        ? name[0].toUpperCase()
        : null;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: const AssetImage(avatarPlaceholder),
      onBackgroundImageError: (_, __) {},
      child: label != null
          ? Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: radius * 0.8,
                fontWeight: FontWeight.w600,
              ),
            )
          : Icon(Icons.person, color: AppColors.white70, size: radius),
    );
  }

  /// Empty state illustration with title/subtitle
  static Widget emptyStateWidget({
    String title = 'Nothing here yet',
    String subtitle = 'Items will appear here once added.',
    double imageSize = 120,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              emptyState,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.inbox_outlined,
                size: imageSize * 0.55,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      ),
    );
  }

  /// No internet state illustration
  static Widget noInternetWidget({
    String title = 'No Internet',
    String subtitle = 'Check your connection and try again.',
    double imageSize = 120,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              noInternet,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.wifi_off,
                size: imageSize * 0.55,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      ),
    );
  }

  /// Generic image placeholder
  static Widget placeholderWidget({double? width, double? height = 160}) {
    return Image.asset(
      placeholder,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: AppColors.borderSubtleLight,
        child: const Icon(Icons.image_outlined, color: AppColors.gray500),
      ),
    );
  }

  /// Returns the icon asset path for a given category name
  static String iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':          return icFood;
      case 'transport':     return icTransport;
      case 'bills':         return icBills;
      case 'shopping':      return icShopping;
      case 'entertainment': return icEntertainment;
      case 'health':        return icHealth;
      case 'education':     return icEducation;
      case 'salary':        return icSalary;
      case 'investments':   return icInvestments;
      default:              return icOther;
    }
  }
}
