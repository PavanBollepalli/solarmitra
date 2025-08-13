import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom BottomNavigationBar widget implementing Accessible Solar Minimalism design
/// with large touch targets and high contrast visuals for rural users.
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomBarVariant variant;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomBarVariant.primary,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define navigation items with routes
    final items = _getNavigationItems();

    // Determine colors based on variant
    Color backgroundColor;
    Color selectedItemColor;
    Color unselectedItemColor;

    switch (variant) {
      case BottomBarVariant.primary:
        backgroundColor = colorScheme.surface;
        selectedItemColor = colorScheme.primary;
        unselectedItemColor = colorScheme.onSurface.withValues(alpha: 0.6);
        break;
      case BottomBarVariant.elevated:
        backgroundColor = colorScheme.surface;
        selectedItemColor = colorScheme.primary;
        unselectedItemColor = colorScheme.onSurface.withValues(alpha: 0.6);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: variant == BottomBarVariant.elevated
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  offset: Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Container(
          height: 72, // Increased height for better touch targets
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return Expanded(
                child: _BottomBarItem(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  label: item.label,
                  isSelected: isSelected,
                  selectedColor: selectedItemColor,
                  unselectedColor: unselectedItemColor,
                  showLabel: showLabels,
                  onTap: () => _handleTap(context, index, item.route),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<_BottomBarItemData> _getNavigationItems() {
    return [
      _BottomBarItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        route: '/home-dashboard',
      ),
      _BottomBarItemData(
        icon: Icons.calculate_outlined,
        activeIcon: Icons.calculate,
        label: 'Calculator',
        route: '/rooftop-solar-calculator',
      ),
      _BottomBarItemData(
        icon: Icons.account_balance_outlined,
        activeIcon: Icons.account_balance,
        label: 'Schemes',
        route: '/government-schemes-list',
      ),
      _BottomBarItemData(
        icon: Icons.language_outlined,
        activeIcon: Icons.language,
        label: 'Language',
        route: '/language-selection',
      ),
    ];
  }

  void _handleTap(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the corresponding route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false, // Remove all previous routes
      );
    }
  }
}

/// Individual bottom bar item widget with enhanced touch targets
class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final bool showLabel;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.showLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final iconData = isSelected && activeIcon != null ? activeIcon! : icon;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with enhanced size for better touch targets
            Container(
              padding: EdgeInsets.all(4),
              child: Icon(
                iconData,
                size: 28, // Larger icons for better visibility
                color: color,
              ),
            ),

            // Label with conditional visibility
            if (showLabel) ...[
              SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Data class for bottom bar navigation items
class _BottomBarItemData {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const _BottomBarItemData({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Enum defining different BottomBar variants
enum BottomBarVariant {
  /// Standard bottom bar with surface background
  primary,

  /// Elevated bottom bar with shadow
  elevated,
}
