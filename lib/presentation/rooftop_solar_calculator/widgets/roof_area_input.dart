import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RoofAreaInput extends StatefulWidget {
  final double? initialValue;
  final Function(double) onChanged;
  final VoidCallback? onNext;

  const RoofAreaInput({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<RoofAreaInput> createState() => _RoofAreaInputState();
}

class _RoofAreaInputState extends State<RoofAreaInput> {
  late TextEditingController _controller;
  double? _currentValue;
  bool _isValid = false;

  final List<Map<String, dynamic>> _sizeReferences = [
    {
      'title': 'Small House',
      'subtitle': '100-300 sq ft',
      'range': '100-300',
      'image':
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop',
    },
    {
      'title': 'Medium House',
      'subtitle': '300-600 sq ft',
      'range': '300-600',
      'image':
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop',
    },
    {
      'title': 'Large House',
      'subtitle': '600+ sq ft',
      'range': '600+',
      'image':
          'https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=300&h=200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toString() ?? '',
    );
    _currentValue = widget.initialValue;
    _isValid = widget.initialValue != null && widget.initialValue! > 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndUpdate(String value) {
    final parsedValue = double.tryParse(value);
    setState(() {
      _currentValue = parsedValue;
      _isValid = parsedValue != null && parsedValue > 0 && parsedValue <= 10000;
    });

    if (_isValid && parsedValue != null) {
      widget.onChanged(parsedValue);
    }
  }

  void _selectSizeReference(String range) {
    String value = '';
    switch (range) {
      case '100-300':
        value = '200';
        break;
      case '300-600':
        value = '450';
        break;
      case '600+':
        value = '800';
        break;
    }

    _controller.text = value;
    _validateAndUpdate(value);
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
            'Enter Your Roof Area',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Measure the available roof space where solar panels can be installed',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Input field
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: _isValid ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter area',
                hintStyle:
                    AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                suffixText: 'sq ft',
                suffixStyle: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                suffixIcon: _isValid
                    ? Container(
                        margin: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 5.w,
                        ),
                      )
                    : null,
              ),
              onChanged: _validateAndUpdate,
            ),
          ),

          if (!_isValid && _controller.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 1.h, left: 2.w),
              child: Text(
                'Please enter a valid area between 1-10,000 sq ft',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),

          SizedBox(height: 4.h),

          // Size references
          Text(
            'Not sure? Choose your house size:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          ...(_sizeReferences.map((reference) => Container(
                margin: EdgeInsets.only(bottom: 2.h),
                child: InkWell(
                  onTap: () => _selectSizeReference(reference['range']),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Row(
                      children: [
                        // House illustration
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CustomImageWidget(
                            imageUrl: reference['image'],
                            width: 20.w,
                            height: 15.w,
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reference['title'],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                reference['subtitle'],
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow
                        CustomIconWidget(
                          iconName: 'arrow_forward_ios',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ))),

          SizedBox(height: 4.h),

          // Next button
          if (_isValid)
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
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
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
