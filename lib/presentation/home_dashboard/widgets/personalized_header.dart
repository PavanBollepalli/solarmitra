import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PersonalizedHeader extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> weatherData;

  const PersonalizedHeader({
    super.key,
    required this.userData,
    required this.weatherData,
  });

  @override
  State<PersonalizedHeader> createState() => _PersonalizedHeaderState();
}

class _PersonalizedHeaderState extends State<PersonalizedHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;

    String greeting = _getGreeting(hour);
    String timeIcon = _getTimeIcon(hour);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 3.h),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicators row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusIndicator(
                        context,
                        'wifi',
                        'Online',
                        AppTheme.lightTheme.colorScheme.secondary,
                      ),
                      _buildLocationInfo(context),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Greeting section
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: timeIcon,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontSize: 20.sp,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              widget.userData["name"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Weather and solar info
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildWeatherInfo(context),
                        ),
                        Container(
                          width: 1,
                          height: 5.h,
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: _buildSolarInfo(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getTimeIcon(int hour) {
    if (hour >= 6 && hour < 12) return 'wb_sunny';
    if (hour >= 12 && hour < 18) return 'wb_sunny';
    return 'nights_stay';
  }

  Widget _buildStatusIndicator(
    BuildContext context,
    String iconName,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'location_on',
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          widget.userData["location"] as String,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: widget.weatherData["icon"] as String,
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              widget.weatherData["temperature"] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Weather',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSolarInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'wb_sunny',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              widget.weatherData["solarIrradiance"] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Solar Power',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
