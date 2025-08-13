import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsBanner extends StatefulWidget {
  final Map<String, dynamic> statsData;

  const QuickStatsBanner({
    super.key,
    required this.statsData,
  });

  @override
  State<QuickStatsBanner> createState() => _QuickStatsBannerState();
}

class _QuickStatsBannerState extends State<QuickStatsBanner>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1.0, curve: Curves.easeOut),
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

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Your Solar Impact',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Stats row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'Potential Savings',
                          widget.statsData["potentialSavings"] as String,
                          'savings',
                          AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 6.h,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          'CO₂ Reduction',
                          widget.statsData["co2Reduction"] as String,
                          'eco',
                          AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/rooftop-solar-calculator');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Calculate Your Savings',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                        ],
                      ),
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Icon
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Value with animation
        TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 1200),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Text(
              widget.statsData[label == 'Potential Savings'
                  ? 'potentialSavings'
                  : 'co2Reduction'] as String,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            );
          },
        ),

        SizedBox(height: 0.5.h),

        // Label
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 11.sp,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
