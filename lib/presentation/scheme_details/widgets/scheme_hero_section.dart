import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SchemeHeroSection extends StatelessWidget {
  final Map<String, dynamic> schemeData;

  const SchemeHeroSection({
    super.key,
    required this.schemeData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 35.h,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: CustomImageWidget(
              imageUrl: schemeData['bannerImage'] as String? ??
                  'https://images.pexels.com/photos/9875414/pexels-photo-9875414.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              width: double.infinity,
              height: 35.h,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Authority badge
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color:
                          (schemeData['authority'] as String? ?? 'Central') ==
                                  'Central'
                              ? colorScheme.primary
                              : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${schemeData['authority'] ?? 'Central'} Government',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Scheme name
                  Text(
                    schemeData['name'] as String? ?? 'Solar Subsidy Scheme',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Deadline countdown
                  if (schemeData['deadline'] != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Deadline: ${_formatDeadline(schemeData['deadline'])}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDeadline(dynamic deadline) {
    if (deadline is String) {
      try {
        final date = DateTime.parse(deadline);
        final now = DateTime.now();
        final difference = date.difference(now).inDays;

        if (difference > 0) {
          return '$difference days left';
        } else if (difference == 0) {
          return 'Today';
        } else {
          return 'Expired';
        }
      } catch (e) {
        return deadline;
      }
    }
    return deadline?.toString() ?? 'No deadline';
  }
}
