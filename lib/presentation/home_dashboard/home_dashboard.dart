import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/floating_call_button.dart';
import './widgets/hero_scheme_card.dart';
import './widgets/personalized_header.dart';
import './widgets/quick_stats_banner.dart';
import './widgets/service_grid.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  int _currentBottomIndex = 0;
  bool _isRefreshing = false;

  // Mock data for the dashboard
  final Map<String, dynamic> _userData = {
    "name": "राम कुमार",
    "location": "Jaipur, Rajasthan",
    "language": "Hindi",
    "hasProgress": true,
  };

  final Map<String, dynamic> _weatherData = {
    "temperature": "32°C",
    "icon": "wb_sunny",
    "condition": "Sunny",
    "solarIrradiance": "850 W/m²",
  };

  final Map<String, dynamic> _featuredScheme = {
    "title": "PM-KUSUM Yojana",
    "description":
        "Get up to 60% subsidy on solar pump installation for farmers",
    "category": "Central Scheme",
    "subsidy": "60%",
    "maxAmount": "₹3,00,000",
    "isEligible": true,
  };

  final Map<String, dynamic> _quickStats = {
    "potentialSavings": "₹15,000/year",
    "co2Reduction": "2.5 tons/year",
  };

  final List<Map<String, dynamic>> _services = [
    {
      "title": "Rooftop Solar Calculator",
      "description": "Calculate savings & system size",
      "icon": "calculate",
      "route": "/rooftop-solar-calculator",
      "isNew": false,
    },
    {
      "title": "KUSUM Pump Wizard",
      "description": "Solar pump sizing & subsidy",
      "icon": "water_drop",
      "route": "/kusum-pump-wizard",
      "isNew": true,
    },
    {
      "title": "Government Schemes",
      "description": "Find eligible schemes",
      "icon": "account_balance",
      "route": "/government-schemes-list",
      "isNew": false,
    },
    {
      "title": "Installer Marketplace",
      "description": "Connect with installers",
      "icon": "engineering",
      "route": "/installer-marketplace",
      "isNew": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.lightTheme.colorScheme.primary,
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                // Custom app bar
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      CustomImageWidget(
                        imageUrl:
                            "https://images.pexels.com/photos/9875416/pexels-photo-9875416.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                        width: 8.w,
                        height: 8.w,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'SolarMitra',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/language-selection');
                      },
                      icon: CustomIconWidget(
                        iconName: 'language',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                    IconButton(
                      onPressed: _showInfoDialog,
                      icon: CustomIconWidget(
                        iconName: 'info_outline',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),

                // Content
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Personalized header
                    PersonalizedHeader(
                      userData: _userData,
                      weatherData: _weatherData,
                    ),

                    // Featured scheme card
                    HeroSchemeCard(
                      schemeData: _featuredScheme,
                      onEligibilityCheck: () {
                        Navigator.pushNamed(context, '/scheme-details');
                      },
                    ),

                    // Quick stats banner
                    QuickStatsBanner(
                      statsData: _quickStats,
                    ),

                    // Section header
                    Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'dashboard',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Solar Services',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Service grid
                    ServiceGrid(
                      services: _services,
                      onServiceTap: _handleServiceTap,
                    ),

                    // Bottom spacing for floating button
                    SizedBox(height: 15.h),
                  ]),
                ),
              ],
            ),
          ),

          // Floating call button
          FloatingCallButton(
            onPressed: _showCallMitraDialog,
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              offset: Offset(0, -2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 8.h,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(0, 'home', 'Home', '/home-dashboard'),
                _buildBottomNavItem(1, 'account_balance', 'Schemes',
                    '/government-schemes-list'),
                _buildBottomNavItem(
                    2, 'calculate', 'Calculator', '/rooftop-solar-calculator'),
                _buildBottomNavItem(
                    3, 'engineering', 'Installers', '/installer-marketplace'),
                _buildBottomNavItem(4, 'person', 'Profile', '/profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
      int index, String iconName, String label, String route) {
    final theme = Theme.of(context);
    final isSelected = _currentBottomIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _handleBottomNavTap(index, route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index, String route) {
    setState(() {
      _currentBottomIndex = index;
    });

    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route && route != '/home-dashboard') {
      Navigator.pushNamed(context, route);
    }
  }

  void _handleServiceTap(String route) {
    Navigator.pushNamed(context, route);
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate network request
    await Future.delayed(Duration(seconds: 2));

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text('Schemes updated successfully'),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text('About SolarMitra'),
          ],
        ),
        content: Text(
          'SolarMitra helps rural communities access solar energy solutions through government schemes, calculators, and installer connections.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCallMitraDialog() {
    showDialog(
      context: context,
      builder: (context) => CallMitraDialog(),
    );
  }
}
