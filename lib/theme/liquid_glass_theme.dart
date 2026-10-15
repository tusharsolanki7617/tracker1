import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

// ──────────────────────────────────────────────
//  LIQUID GLASS DESIGN TOKEN SYSTEM
// ──────────────────────────────────────────────

class LG {
  // ── Palette ──────────────────────────────────
  static const Color indigo900 = AppColors.primaryDark;
  static const Color indigo700 = AppColors.primaryLight;
  static const Color violet600 = AppColors.accentDark;
  static const Color violet400 = AppColors.accentLight;
  static const Color rose500   = AppColors.expense;
  static const Color rose300   = AppColors.expenseLight;
  static const Color cyan400   = AppColors.info;
  static const Color emerald400 = AppColors.incomeLight;
  static const Color amber400  = AppColors.warning;

  // ── Glass Surfaces ────────────────────────────
  static const Color glassWhite   = AppColors.glassWhite;
  static const Color glassBorder  = AppColors.glassBorder;
  static const Color glassShimmer = AppColors.glassShimmer;
  static const Color glassDark    = AppColors.glassDark;

  // ── Text ─────────────────────────────────────
  static const Color textPrimary   = AppColors.white;
  static const Color textSecondary = AppColors.white80;
  static const Color textMuted     = AppColors.white54;

  // ── Gradients ─────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [indigo900, AppColors.primaryLight, AppColors.primary, AppColors.primaryDark],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  static const LinearGradient incomeGradient = AppColors.incomeGradient;

  static const LinearGradient expenseGradient = AppColors.expenseGradient;

  static const LinearGradient balanceGradient = LinearGradient(
    colors: [violet600, AppColors.accentLight, rose500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = AppColors.glassGradient;

  // ── Typography ────────────────────────────────
  static TextStyle display(double size, {FontWeight weight = FontWeight.bold, Color? color}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color ?? textPrimary, letterSpacing: -0.5);

  static TextStyle body(double size, {FontWeight weight = FontWeight.normal, Color? color}) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color ?? textSecondary);

  static TextStyle mono(double size, {Color? color}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color ?? textPrimary);

  // ── Shadows ───────────────────────────────────
  static List<BoxShadow> glassShadow = [
    BoxShadow(color: AppColors.black.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: violet600.withValues(alpha: 0.15), blurRadius: 32, offset: const Offset(0, 0)),
  ];

  static List<BoxShadow> cardGlow(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 4)),
    BoxShadow(color: AppColors.black.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  // ── Border Radii ─────────────────────────────
  static const BorderRadius radiusXL  = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusLG  = BorderRadius.all(Radius.circular(18));
  static const BorderRadius radiusMD  = BorderRadius.all(Radius.circular(14));
  static const BorderRadius radiusSM  = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(100));

  // ── Glass Decoration Builder ──────────────────
  static BoxDecoration glassDecoration({
    BorderRadius? borderRadius,
    Gradient? gradient,
    Color? tint,
    double borderOpacity = 0.3,
  }) =>
      BoxDecoration(
        borderRadius: borderRadius ?? radiusLG,
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (tint ?? AppColors.white).withValues(alpha: 0.15),
                (tint ?? AppColors.white).withValues(alpha: 0.05),
              ],
            ),
        border: Border.all(color: AppColors.white.withValues(alpha: borderOpacity), width: 1.0),
        boxShadow: glassShadow,
      );

  // ── Category Color / Icon mapping ─────────────
  static Color categoryColor(String cat, bool isIncome) {
    if (isIncome) return emerald400;
    switch (cat.toLowerCase()) {
      case 'food':        return amber400;
      case 'transport':   return cyan400;
      case 'bills':       return rose500;
      case 'shopping':    return violet400;
      case 'entertainment': return AppColors.catEntertainment;
      case 'health':      return emerald400;
      default:            return AppColors.textSecondaryDark;
    }
  }

  static IconData categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'salary':
      case 'income':      return Icons.account_balance_wallet_rounded;
      case 'food':        return Icons.restaurant_rounded;
      case 'transport':   return Icons.directions_bus_rounded;
      case 'bills':       return Icons.receipt_long_rounded;
      case 'shopping':    return Icons.shopping_bag_rounded;
      case 'entertainment': return Icons.movie_rounded;
      case 'health':      return Icons.favorite_rounded;
      case 'bonus':       return Icons.star_rounded;
      case 'investment':  return Icons.trending_up_rounded;
      case 'freelance':   return Icons.work_rounded;
      default:            return Icons.category_rounded;
    }
  }
}

// ──────────────────────────────────────────────
//  MATERIAL THEME FACTORY
// ──────────────────────────────────────────────
class LiquidGlassTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: LG.violet600,
        secondary: LG.violet400,
        surface: LG.indigo900,
        onSurface: LG.textPrimary,
        onPrimary: AppColors.white,
        error: LG.rose500,
      ),
      scaffoldBackgroundColor: AppColors.transparent,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: LG.display(18, weight: FontWeight.w600),
        iconTheme: const IconThemeData(color: LG.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white.withValues(alpha: 0.08),
        labelStyle: LG.body(14, color: LG.textSecondary),
        hintStyle: LG.body(14, color: LG.textMuted),
        prefixIconColor: LG.textSecondary,
        suffixIconColor: LG.textSecondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: LG.radiusMD,
          borderSide: BorderSide(color: AppColors.white.withValues(alpha: 0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LG.radiusMD,
          borderSide: const BorderSide(color: LG.violet400, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: LG.radiusMD,
          borderSide: BorderSide(color: LG.rose500, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: LG.radiusMD,
          borderSide: BorderSide(color: LG.rose500, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LG.violet600,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: LG.radiusMD),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          elevation: 0,
          textStyle: LG.body(15, weight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: LG.violet400,
          textStyle: LG.body(14, weight: FontWeight.w600),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.white.withValues(alpha: 0.1), thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: LG.indigo700.withValues(alpha: 0.97),
        shape: RoundedRectangleBorder(borderRadius: LG.radiusXL),
        titleTextStyle: LG.display(18),
        contentTextStyle: LG.body(14),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: LG.indigo700,
        contentTextStyle: LG.body(14),
        shape: RoundedRectangleBorder(borderRadius: LG.radiusMD),
        behavior: SnackBarBehavior.floating,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white.withValues(alpha: 0.08),
        selectedColor: LG.violet600,
        labelStyle: LG.body(12),
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.2), width: 1),
        shape: RoundedRectangleBorder(borderRadius: LG.radiusPill),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}

// ──────────────────────────────────────────────
//  ANIMATED BACKGROUND GRADIENT WIDGET
// ──────────────────────────────────────────────
class LiquidBackground extends StatefulWidget {
  final Widget child;
  const LiquidBackground({super.key, required this.child});

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.lerp(Alignment.topLeft, Alignment.topRight, _anim.value)!,
              end: Alignment.lerp(Alignment.bottomRight, Alignment.bottomLeft, _anim.value)!,
              colors: const [
                LG.indigo900,
                AppColors.primaryLight,
                AppColors.primary,
                AppColors.primaryDark,
              ],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// Orb decoration for ambient glow blobs
class AmbientOrbs extends StatelessWidget {
  const AmbientOrbs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -80,
          child: _orb(220, LG.violet600.withValues(alpha: 0.35)),
        ),
        Positioned(
          top: size.height * 0.25,
          right: -60,
          child: _orb(180, LG.rose500.withValues(alpha: 0.2)),
        ),
        Positioned(
          bottom: size.height * 0.15,
          left: -40,
          child: _orb(160, LG.cyan400.withValues(alpha: 0.15)),
        ),
      ],
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: const SizedBox.expand(),
      ),
    );
  }
}
