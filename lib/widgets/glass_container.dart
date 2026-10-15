import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import '../theme/liquid_glass_theme.dart';

// ──────────────────────────────────────────────
//  CORE GLASS CONTAINER
// ──────────────────────────────────────────────
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blurSigma;
  final Color? tint;
  final double borderOpacity;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blurSigma = 20.0,
    this.tint,
    this.borderOpacity = 0.25,
    this.shadows,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? LG.radiusLG;

    Widget content = ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: br,
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (tint ?? AppColors.white).withValues(alpha: 0.14),
                    (tint ?? AppColors.white).withValues(alpha: 0.04),
                  ],
                ),
            border: Border.all(
              color: AppColors.white.withValues(alpha: borderOpacity),
              width: 1.0,
            ),
            boxShadow: shadows ?? LG.glassShadow,
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}

// ──────────────────────────────────────────────
//  GLASS CARD (with shimmer top-edge highlight)
// ──────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? accentColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.accentColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? LG.radiusLG;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: br,
          boxShadow: LG.glassShadow,
        ),
        child: ClipRRect(
          borderRadius: br,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Stack(
              children: [
                // Glass body
                Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    borderRadius: br,
                    gradient: AppColors.glassGradient,
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.22),
                      width: 1.0,
                    ),
                  ),
                  child: child,
                ),
                // Shimmer top-edge highlight
                Positioned(
                  top: 0,
                  left: 12,
                  right: 12,
                  height: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.transparent,
                          (accentColor ?? AppColors.white).withValues(alpha: 0.5),
                          AppColors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  GLASS PILL BUTTON
// ──────────────────────────────────────────────
class GlassPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final IconData? icon;
  final bool isLoading;
  final Color? textColor;

  const GlassPillButton({
    super.key,
    required this.label,
    this.onTap,
    this.gradient,
    this.icon,
    this.isLoading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: gradient ??
              const LinearGradient(
                colors: [LG.violet600, AppColors.accentLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
          borderRadius: LG.radiusPill,
          boxShadow: [
            BoxShadow(
              color: LG.violet600.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: LG.radiusPill,
          child: Stack(
            children: [
              // Shimmer overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 1,
                child: Container(
                  color: AppColors.white.withValues(alpha: 0.3),
                ),
              ),
              Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (icon != null) ...[
                            Icon(icon, color: textColor ?? AppColors.white, size: 18),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            label,
                            style: LG.body(15,
                                weight: FontWeight.w700,
                                color: textColor ?? AppColors.white),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  GLASS TEXT FIELD
// ──────────────────────────────────────────────
class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? prefixText;
  final int? maxLines;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      maxLines: maxLines,
      style: LG.body(15, color: LG.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  GLASS STAT MINI-CARD
// ──────────────────────────────────────────────
class GlassStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const GlassStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      accentColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: LG.radiusSM,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(label, style: LG.body(11, color: LG.textMuted)),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: LG.display(16, weight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
