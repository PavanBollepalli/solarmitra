import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Progress bar
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Row(
                    children: [
                      // Step circle
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted || isCurrent
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          border: Border.all(
                            color: isCurrent
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 4.w,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: isCurrent || isCompleted
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      // Connecting line (except for last step)
                      if (index < totalSteps - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 1.h),

          // Current step title
          Text(
            stepTitles[currentStep],
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          // Step counter
          Text(
            'Step ${currentStep + 1} of $totalSteps',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
