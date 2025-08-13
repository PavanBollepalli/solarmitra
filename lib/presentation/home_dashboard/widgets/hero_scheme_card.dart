import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroSchemeCard extends StatelessWidget {
  final Map<String, dynamic> schemeData;
  final VoidCallback onEligibilityCheck;

  const HeroSchemeCard({
    super.key,
    required this.schemeData,
    required this.onEligibilityCheck,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.15),
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scheme badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      schemeData["category"] as String,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Scheme title
                  Text(
                    schemeData["title"] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Scheme description
                  Text(
                    schemeData["description"] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 3.h),

                  // Benefits row
                  Row(
                    children: [
                      Expanded(
                        child: _buildBenefitItem(
                          context,
                          "Subsidy",
                          schemeData["subsidy"] as String,
                          'percent',
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: _buildBenefitItem(
                          context,
                          "Max Amount",
                          schemeData["maxAmount"] as String,
                          'currency_rupee',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onEligibilityCheck,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Check Eligibility',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
