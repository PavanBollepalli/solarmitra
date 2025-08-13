import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final Map<String, dynamic> scheme;
  final VoidCallback onShareDetails;
  final VoidCallback onMarkFavorite;
  final VoidCallback onSetReminder;
  final VoidCallback onGetAudioSummary;
  final VoidCallback onDismiss;

  const QuickActionsWidget({
    super.key,
    required this.scheme,
    required this.onShareDetails,
    required this.onMarkFavorite,
    required this.onSetReminder,
    required this.onGetAudioSummary,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scheme title
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              scheme['name'] as String,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                _buildActionButton(
                  icon: 'share',
                  label: 'Share Details',
                  onTap: onShareDetails,
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                SizedBox(height: 2.h),
                _buildActionButton(
                  icon: 'favorite_border',
                  label: 'Mark Favorite',
                  onTap: onMarkFavorite,
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                SizedBox(height: 2.h),
                _buildActionButton(
                  icon: 'notifications',
                  label: 'Set Reminder',
                  onTap: onSetReminder,
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                SizedBox(height: 2.h),
                _buildActionButton(
                  icon: 'volume_up',
                  label: 'Get Audio Summary',
                  onTap: onGetAudioSummary,
                  colorScheme: colorScheme,
                  theme: theme,
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),

          // Cancel button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                elevation: 0,
                side: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: colorScheme.primary,
                size: 5.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
