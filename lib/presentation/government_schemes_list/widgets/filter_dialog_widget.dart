import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterDialogWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterDialogWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterDialogWidget> createState() => _FilterDialogWidgetState();
}

class _FilterDialogWidgetState extends State<FilterDialogWidget> {
  late Map<String, dynamic> _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 80.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'filter_list',
                    color: colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Filter Schemes',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                ],
              ),
            ),

            // Filter options
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSchemeTypeFilter(theme, colorScheme),
                    SizedBox(height: 3.h),
                    _buildSubsidyRangeFilter(theme, colorScheme),
                    SizedBox(height: 3.h),
                    _buildEligibilityFilter(theme, colorScheme),
                    SizedBox(height: 3.h),
                    _buildStateFilter(theme, colorScheme),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAllFilters,
                      child: Text('Clear All'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeTypeFilter(ThemeData theme, ColorScheme colorScheme) {
    final schemeTypes = [
      'Central Government',
      'State Government',
      'Private',
      'NGO'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scheme Type',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...schemeTypes.map((type) => CheckboxListTile(
              title: Text(type),
              value: (_tempFilters['schemeTypes'] as List<String>? ?? [])
                  .contains(type),
              onChanged: (value) {
                setState(() {
                  final types = (_tempFilters['schemeTypes'] as List<String>? ??
                          <String>[])
                      .toList();
                  if (value == true) {
                    types.add(type);
                  } else {
                    types.remove(type);
                  }
                  _tempFilters['schemeTypes'] = types;
                });
              },
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }

  Widget _buildSubsidyRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    final subsidyRanges = [
      'Up to ₹50,000',
      '₹50,000 - ₹1,00,000',
      '₹1,00,000 - ₹2,00,000',
      'Above ₹2,00,000'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subsidy Amount',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...subsidyRanges.map((range) => RadioListTile<String>(
              title: Text(range),
              value: range,
              groupValue: _tempFilters['subsidyRange'] as String?,
              onChanged: (value) {
                setState(() {
                  _tempFilters['subsidyRange'] = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }

  Widget _buildEligibilityFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Eligibility Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        SwitchListTile(
          title: Text('Show only eligible schemes'),
          value: _tempFilters['onlyEligible'] as bool? ?? false,
          onChanged: (value) {
            setState(() {
              _tempFilters['onlyEligible'] = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildStateFilter(ThemeData theme, ColorScheme colorScheme) {
    final states = [
      'All India',
      'Andhra Pradesh',
      'Karnataka',
      'Tamil Nadu',
      'Telangana',
      'Maharashtra',
      'Gujarat',
      'Rajasthan'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'State/Region',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _tempFilters['selectedState'] as String? ?? 'All India',
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          ),
          items: states
              .map((state) => DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _tempFilters['selectedState'] = value;
            });
          },
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _tempFilters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_tempFilters);
    Navigator.of(context).pop();
  }
}
