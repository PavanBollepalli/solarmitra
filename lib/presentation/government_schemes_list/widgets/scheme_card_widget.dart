import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SchemeCardWidget extends StatelessWidget {
  final Map<String, dynamic> scheme;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SchemeCardWidget({
    super.key,
    required this.scheme,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scheme thumbnail
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.primary.withValues(alpha: 0.1),
                      ),
                      child: CustomIconWidget(
                        iconName: 'solar_power',
                        color: colorScheme.primary,
                        size: 8.w,
                      ),
                    ),
                    SizedBox(width: 3.w),

                    // Scheme details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  scheme['name'] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _buildEligibilityIndicator(
                                  scheme['eligibilityStatus'] as String,
                                  colorScheme),
                            ],
                          ),
                          SizedBox(height: 1.h),

                          // Subsidy amount
                          Text(
                            'Max Subsidy: ${scheme['maxSubsidy']}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),

                          // Application deadline
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'schedule',
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Deadline: ${scheme['deadline']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Scheme type and state
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scheme['type'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scheme['state'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEligibilityIndicator(String status, ColorScheme colorScheme) {
    Color indicatorColor;
    IconData iconData;

    switch (status.toLowerCase()) {
      case 'eligible':
        indicatorColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case 'pending':
        indicatorColor = Colors.orange;
        iconData = Icons.pending;
        break;
      case 'ineligible':
        indicatorColor = Colors.red;
        iconData = Icons.cancel;
        break;
      default:
        indicatorColor = Colors.grey;
        iconData = Icons.help;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: CustomIconWidget(
        iconName: iconData.codePoint.toString(),
        color: indicatorColor,
        size: 4.w,
      ),
    );
  }
}
