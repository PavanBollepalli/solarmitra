import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SchemeActionButtons extends StatelessWidget {
  final Map<String, dynamic> schemeData;
  final VoidCallback onEligibilityCheck;
  final VoidCallback onDownloadPDF;
  final VoidCallback onShareWhatsApp;
  final VoidCallback onSetReminder;

  const SchemeActionButtons({
    super.key,
    required this.schemeData,
    required this.onEligibilityCheck,
    required this.onDownloadPDF,
    required this.onShareWhatsApp,
    required this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action button
            ElevatedButton(
              onPressed: onEligibilityCheck,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 7.h),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'fact_check',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Check My Eligibility',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary action buttons
            Row(
              children: [
                // Download PDF button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDownloadPDF,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 6.h),
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'PDF Guide',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Share WhatsApp button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onShareWhatsApp,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 6.h),
                      side: BorderSide(
                        color: Colors.green,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'share',
                          color: Colors.green,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'WhatsApp',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 2.w),

                // Set reminder button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSetReminder,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 6.h),
                      side: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Reminder',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
