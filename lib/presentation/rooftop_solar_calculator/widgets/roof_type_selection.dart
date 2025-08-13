import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoofTypeSelection extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final VoidCallback? onNext;

  const RoofTypeSelection({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<RoofTypeSelection> createState() => _RoofTypeSelectionState();
}

class _RoofTypeSelectionState extends State<RoofTypeSelection> {
  String? _selectedRoofType;

  final List<Map<String, dynamic>> _roofTypes = [
    {
      'type': 'Flat Roof',
      'description': 'Concrete flat roof with easy access',
      'efficiency': '95%',
      'installationCost': 'Standard',
      'image':
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400&h=300&fit=crop',
      'advantages': [
        'Easy installation',
        'Optimal panel angle',
        'Easy maintenance'
      ],
      'icon': 'home',
    },
    {
      'type': 'Sloped Roof',
      'description': 'Angled roof with tiles or metal sheets',
      'efficiency': '90%',
      'installationCost': 'Slightly Higher',
      'image':
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=400&h=300&fit=crop',
      'advantages': [
        'Natural drainage',
        'Good ventilation',
        'Aesthetic appeal'
      ],
      'icon': 'roofing',
    },
    {
      'type': 'Mixed Roof',
      'description': 'Combination of flat and sloped sections',
      'efficiency': '85%',
      'installationCost': 'Variable',
      'image':
          'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=400&h=300&fit=crop',
      'advantages': [
        'Flexible design',
        'Multiple orientations',
        'Maximized space'
      ],
      'icon': 'architecture',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedRoofType = widget.initialValue;
  }

  void _selectRoofType(String roofType) {
    setState(() {
      _selectedRoofType = roofType;
    });
    widget.onChanged(roofType);
  }

  Color _getEfficiencyColor(String efficiency) {
    final value = int.parse(efficiency.replaceAll('%', ''));
    if (value >= 95) return Colors.green;
    if (value >= 90) return Colors.lightGreen;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Select Your Roof Type',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Different roof types affect installation cost and solar panel efficiency',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Roof type cards
          ...(_roofTypes.map((roofType) {
            final isSelected = _selectedRoofType == roofType['type'];

            return Container(
              margin: EdgeInsets.only(bottom: 3.h),
              child: InkWell(
                onTap: () => _selectRoofType(roofType['type']),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          // Roof image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CustomImageWidget(
                              imageUrl: roofType['image'],
                              width: 25.w,
                              height: 20.w,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(width: 4.w),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: roofType['icon'],
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                      size: 6.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        roofType['type'],
                                        style: AppTheme
                                            .lightTheme.textTheme.titleLarge
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.all(1.w),
                                        decoration: BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: CustomIconWidget(
                                          iconName: 'check',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onPrimary,
                                          size: 4.w,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  roofType['description'],
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Efficiency and cost info
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color:
                                    _getEfficiencyColor(roofType['efficiency'])
                                        .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getEfficiencyColor(
                                          roofType['efficiency'])
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    roofType['efficiency'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleLarge
                                        ?.copyWith(
                                      color: _getEfficiencyColor(
                                          roofType['efficiency']),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Efficiency',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    roofType['installationCost'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Cost',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Advantages
                      Text(
                        'Advantages:',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      ...((roofType['advantages'] as List<String>).map(
                        (advantage) => Padding(
                          padding: EdgeInsets.only(bottom: 0.5.h),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: Colors.green,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  advantage,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            );
          })),

          SizedBox(height: 2.h),

          // Next button
          if (_selectedRoofType != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Calculate Solar Potential',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'calculate',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 5.w,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
