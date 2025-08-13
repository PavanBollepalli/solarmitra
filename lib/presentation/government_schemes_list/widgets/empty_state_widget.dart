import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getIconName(),
                  color: colorScheme.primary.withValues(alpha: 0.6),
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              _getTitle(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              _getDescription(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (onAction != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    _getActionText(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getIconName() {
    switch (type) {
      case EmptyStateType.noResults:
        return 'search_off';
      case EmptyStateType.noConnection:
        return 'wifi_off';
      case EmptyStateType.noSchemes:
        return 'inbox';
    }
  }

  String _getTitle() {
    switch (type) {
      case EmptyStateType.noResults:
        return 'No schemes match your criteria';
      case EmptyStateType.noConnection:
        return 'Check internet connection';
      case EmptyStateType.noSchemes:
        return 'No schemes available';
    }
  }

  String _getDescription() {
    switch (type) {
      case EmptyStateType.noResults:
        return 'Try adjusting your search terms or clearing some filters to see more schemes.';
      case EmptyStateType.noConnection:
        return 'Please check your internet connection and try again. Some cached schemes may be available offline.';
      case EmptyStateType.noSchemes:
        return 'There are currently no government schemes available. Please check back later.';
    }
  }

  String _getActionText() {
    switch (type) {
      case EmptyStateType.noResults:
        return 'Clear Filters';
      case EmptyStateType.noConnection:
        return 'Retry';
      case EmptyStateType.noSchemes:
        return 'Refresh';
    }
  }
}

enum EmptyStateType {
  noResults,
  noConnection,
  noSchemes,
}
