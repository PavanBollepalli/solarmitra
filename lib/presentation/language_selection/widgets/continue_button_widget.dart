import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ContinueButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String buttonText;

  const ContinueButtonWidget({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.12),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: isEnabled && !isLoading
              ? () {
                  HapticFeedback.mediumImpact();
                  onPressed?.call();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? AppTheme.lightTheme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            foregroundColor: isEnabled
                ? Colors.white
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(vertical: 4.h),
            elevation: isEnabled ? 2 : 0,
            shadowColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Downloading...',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  buttonText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isEnabled
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
        ),
      ),
    );
  }
}
