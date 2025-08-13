import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final ValueChanged<Map<String, dynamic>> onFilterRemoved;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    required this.onFilterRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (activeFilters.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: activeFilters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = activeFilters[index];
          return _buildFilterChip(filter, colorScheme, theme);
        },
      ),
    );
  }

  Widget _buildFilterChip(
    Map<String, dynamic> filter,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${filter['label']}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (filter['count'] != null) ...[
            SizedBox(width: 1.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${filter['count']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () => onFilterRemoved(filter),
            child: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.primary,
              size: 4.w,
            ),
          ),
        ],
      ),
    );
  }
}
