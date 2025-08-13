import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LanguageCardWidget extends StatelessWidget {
  final Map<String, dynamic> language;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onAudioPlay;

  const LanguageCardWidget({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
    required this.onAudioPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
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
                // Language illustration
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      language['flag'] as String,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Language details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Native script name
                      Text(
                        language['nativeName'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      // English name
                      Text(
                        language['englishName'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Audio play button
                Container(
                  width: 10.w,
                  height: 10.w,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onAudioPlay();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'volume_up',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Selection indicator
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
