import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FormProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const FormProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              
              return Expanded(
                child: Row(
                  children: [
                    // Step circle
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? theme.primaryColor
                                : Colors.grey.shade300,
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 4.w,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                      ),
                    ),
                    
                    // Connecting line (except for last step)
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < currentStep
                              ? Colors.green
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 2.h),

          // Current step title
          Text(
            stepTitles[currentStep],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
            ),
          ),

          SizedBox(height: 1.h),

          // Progress bar
          LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ],
      ),
    );
  }
}