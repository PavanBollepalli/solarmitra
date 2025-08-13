import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguageHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const LanguageHeaderWidget({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button (if navigation is possible)
          if (onBackPressed != null) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBackPressed,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
          ],

          // Title
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Spacer for centering when back button exists
          if (onBackPressed != null) SizedBox(width: 14.w),
        ],
      ),
    );
  }
}
