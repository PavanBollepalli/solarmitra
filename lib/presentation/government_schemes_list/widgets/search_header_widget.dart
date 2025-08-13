import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final VoidCallback? onVoiceSearch;
  final ValueChanged<String>? onSearchChanged;

  const SearchHeaderWidget({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    this.onVoiceSearch,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Search field
            Expanded(
              child: Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search schemes...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                    ),
                    suffixIcon: onVoiceSearch != null
                        ? GestureDetector(
                            onTap: onVoiceSearch,
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: colorScheme.primary,
                                size: 5.w,
                              ),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Filter button
            Container(
              height: 6.h,
              width: 6.h,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(25),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'filter_list',
                    color: colorScheme.onPrimary,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
