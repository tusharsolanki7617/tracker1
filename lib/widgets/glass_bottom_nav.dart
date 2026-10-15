import 'package:flutter/material.dart';
import 'package:tracker1/resource/colors/app_colors.dart';

// ──────────────────────────────────────────────
//  UNIFORM BOTTOM NAVIGATION BAR
//  No selection color change
// ──────────────────────────────────────────────
class GlassBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<GlassNavItem> items;

  const GlassBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.navSurfaceDark : AppColors.navSurfaceLight;
    // Single uniform color for both selected and unselected items
    final itemColor = isDark ? AppColors.navItemDark : AppColors.navItemLight;

    return Container(
      color: bgColor,
      child: SafeArea(
        top: false,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDestinationSelected(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.selectedIcon : item.icon,
                        color: itemColor,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: itemColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const GlassNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
