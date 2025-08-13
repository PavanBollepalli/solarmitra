import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final bool isVisible;
  final String loadingText;
  final double progress;

  const LoadingOverlayWidget({
    super.key,
    required this.isVisible,
    required this.loadingText,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return isVisible
        ? Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                      offset: Offset(0, 4),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Solar-themed loading animation
                    Container(
                      width: 20.w,
                      height: 20.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer rotating ring
                          SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              value: progress > 0 ? progress : null,
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                              backgroundColor: AppTheme
                                  .lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                            ),
                          ),

                          // Sun icon in center
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'wb_sunny',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Loading text
                    Text(
                      loadingText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 2.h),

                    // Progress percentage
                    if (progress > 0) ...[
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
