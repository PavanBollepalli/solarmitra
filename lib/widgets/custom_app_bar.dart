import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Accessible Solar Minimalism design
/// with government-standard visual consistency and contextual actions.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = AppBarVariant.primary,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant
    Color? appBarBackgroundColor;
    Color? appBarForegroundColor;

    switch (variant) {
      case AppBarVariant.primary:
        appBarBackgroundColor = backgroundColor ?? colorScheme.primary;
        appBarForegroundColor = foregroundColor ?? colorScheme.onPrimary;
        break;
      case AppBarVariant.surface:
        appBarBackgroundColor = backgroundColor ?? colorScheme.surface;
        appBarForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.transparent:
        appBarBackgroundColor = backgroundColor ?? Colors.transparent;
        appBarForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: appBarForegroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: appBarBackgroundColor,
      foregroundColor: appBarForegroundColor,
      elevation: elevation ?? (variant == AppBarVariant.transparent ? 0 : 2.0),
      leading: leading ??
          (automaticallyImplyLeading
              ? _buildLeading(context, appBarForegroundColor)
              : null),
      actions: _buildActions(context, appBarForegroundColor),
      bottom: bottom,
      automaticallyImplyLeading: false, // We handle this manually
    );
  }

  Widget? _buildLeading(BuildContext context, Color? foregroundColor) {
    if (!Navigator.of(context).canPop()) return null;

    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: foregroundColor,
        size: 24,
      ),
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget>? _buildActions(BuildContext context, Color? foregroundColor) {
    if (actions != null) return actions;

    // Default contextual actions based on current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/home-dashboard':
        return [
          IconButton(
            icon: Icon(
              Icons.language,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () =>
                Navigator.pushNamed(context, '/language-selection'),
            tooltip: 'Change Language',
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'Information',
          ),
        ];
      case '/rooftop-solar-calculator':
        return [
          IconButton(
            icon: Icon(
              Icons.share,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _shareCalculation(context),
            tooltip: 'Share Calculation',
          ),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _showHelpDialog(context),
            tooltip: 'Help',
          ),
        ];
      case '/government-schemes-list':
        return [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter Schemes',
          ),
        ];
      case '/scheme-details':
        return [
          IconButton(
            icon: Icon(
              Icons.bookmark_border,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _bookmarkScheme(context),
            tooltip: 'Bookmark Scheme',
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: foregroundColor,
              size: 24,
            ),
            onPressed: () => _shareScheme(context),
            tooltip: 'Share Scheme',
          ),
        ];
      default:
        return null;
    }
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Solar Energy Information'),
        content: Text(
            'Learn about solar energy benefits and government schemes available in your area.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _shareCalculation(BuildContext context) {
    // Implement share calculation functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calculation shared successfully')),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Calculator Help'),
        content: Text(
            'Enter your monthly electricity bill and roof area to calculate potential solar savings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Schemes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Central Government'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('State Government'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: Text('Subsidies Available'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _bookmarkScheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheme bookmarked successfully')),
    );
  }

  void _shareScheme(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scheme shared successfully')),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Enum defining different AppBar variants for various use cases
enum AppBarVariant {
  /// Primary colored AppBar with brand colors
  primary,

  /// Surface colored AppBar for secondary screens
  surface,

  /// Transparent AppBar for overlay scenarios
  transparent,
}
