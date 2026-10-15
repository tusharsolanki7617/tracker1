import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

/// ============================================================================
/// GLOBAL PROJECT IMAGE RESOURCE SYSTEM
/// Edit any image path or asset helper here, and it updates across the project!
/// ============================================================================
class AppImages {
  // ── Asset Directory Path ──────────────────────────────────────────────────
  static const String basePath = 'lib/widgets/resourse';

  // ── Core Image Assets ─────────────────────────────────────────────────────
  static const String placeholder = '$basePath/placeholder.png';
  static const String avatar = '$basePath/avatar_placeholder.png';
  static const String card = '$basePath/card_placeholder.png';
  static const String empty = '$basePath/empty_placeholder.png';
  static const String logo = '$basePath/logo_placeholder.png';

  // SVG equivalents
  static const String placeholderSvg = '$basePath/placeholder.svg';
  static const String avatarSvg = '$basePath/avatar_placeholder.svg';
  static const String cardSvg = '$basePath/card_placeholder.svg';
  static const String emptySvg = '$basePath/empty_placeholder.svg';
  static const String logoSvg = '$basePath/logo_placeholder.svg';

  // ── Widget Builders ───────────────────────────────────────────────────────

  /// Avatar Image with smooth fallback
  static Widget avatarWidget({double radius = 24}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.gray200,
      backgroundImage: const AssetImage(avatar),
      onBackgroundImageError: (_, __) {},
      child: const Icon(Icons.person, color: AppColors.gray500, size: 24),
    );
  }

  /// App Logo Image with fallback
  static Widget logoWidget({double size = 48}) {
    return Image.asset(
      logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.account_balance_wallet, color: AppColors.white),
      ),
    );
  }

  /// Empty State Illustration
  static Widget emptyStateWidget({
    String title = 'No data found',
    String subtitle = 'Items will appear here once added',
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              empty,
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.inbox_outlined,
                size: 64,
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
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Credit Card / Bank Card Placeholder Widget
  static Widget cardWidget({double height = 180}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        card,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.credit_card, color: AppColors.white54, size: 48),
          ),
        ),
      ),
    );
  }

  /// General Image Placeholder Widget
  static Widget placeholderWidget({
    double? width,
    double? height = 160,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      placeholder,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: AppColors.gray100,
        child: const Icon(Icons.image_outlined, color: AppColors.gray500),
      ),
    );
  }
}
