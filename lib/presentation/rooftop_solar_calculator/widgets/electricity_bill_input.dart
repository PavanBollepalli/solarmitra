import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ElectricityBillInput extends StatefulWidget {
  final double? initialValue;
  final Function(double) onChanged;
  final VoidCallback? onNext;

  const ElectricityBillInput({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<ElectricityBillInput> createState() => _ElectricityBillInputState();
}

class _ElectricityBillInputState extends State<ElectricityBillInput> {
  double _currentValue = 2000;
  late TextEditingController _controller;

  final List<Map<String, dynamic>> _consumptionTiers = [
    {
      'range': '₹500-1500',
      'description': 'Low Usage',
      'units': '50-150 units',
      'color': Colors.green,
    },
    {
      'range': '₹1500-3000',
      'description': 'Medium Usage',
      'units': '150-300 units',
      'color': Colors.orange,
    },
    {
      'range': '₹3000-6000',
      'description': 'High Usage',
      'units': '300-600 units',
      'color': Colors.red,
    },
    {
      'range': '₹6000+',
      'description': 'Very High Usage',
      'units': '600+ units',
      'color': Colors.deepPurple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? 2000;
    _controller = TextEditingController(text: _currentValue.toInt().toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double value) {
    setState(() {
      _currentValue = value;
      _controller.text = value.toInt().toString();
    });
    widget.onChanged(value);
  }

  void _updateFromTextField(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null && parsedValue >= 100 && parsedValue <= 20000) {
      setState(() {
        _currentValue = parsedValue;
      });
      widget.onChanged(parsedValue);
    }
  }

  String _getCurrentTier() {
    if (_currentValue <= 1500) return 'Low Usage';
    if (_currentValue <= 3000) return 'Medium Usage';
    if (_currentValue <= 6000) return 'High Usage';
    return 'Very High Usage';
  }

  Color _getCurrentTierColor() {
    if (_currentValue <= 1500) return Colors.green;
    if (_currentValue <= 3000) return Colors.orange;
    if (_currentValue <= 6000) return Colors.red;
    return Colors.deepPurple;
  }

  double _getEstimatedUnits() {
    // Rough estimation: ₹10 per unit average
    return _currentValue / 10;
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
            'Monthly Electricity Bill',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Enter your average monthly electricity bill amount to calculate potential savings',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Current value display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: _getCurrentTierColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getCurrentTierColor(),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '₹${_currentValue.toInt()}',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: _getCurrentTierColor(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getCurrentTierColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getCurrentTier(),
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Approx. ${_getEstimatedUnits().toInt()} units/month',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Slider
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _getCurrentTierColor(),
                    thumbColor: _getCurrentTierColor(),
                    overlayColor: _getCurrentTierColor().withValues(alpha: 0.2),
                    inactiveTrackColor:
                        _getCurrentTierColor().withValues(alpha: 0.3),
                    trackHeight: 6,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: _currentValue,
                    min: 100,
                    max: 20000,
                    divisions: 199,
                    onChanged: _updateValue,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹100',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '₹20,000',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Manual input
          Text(
            'Or enter exact amount:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 1.h),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                hintText: 'Enter amount',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
              onChanged: _updateFromTextField,
            ),
          ),

          SizedBox(height: 3.h),

          // Consumption tiers info
          Text(
            'Usage Categories:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          ...(_consumptionTiers.map((tier) => Container(
                margin: EdgeInsets.only(bottom: 2.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: tier['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tier['color'].withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: tier['color'],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier['description'],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${tier['range']} • ${tier['units']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),

          SizedBox(height: 4.h),

          // Next button
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
                    'Next Step',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'arrow_forward',
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
