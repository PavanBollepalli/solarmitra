import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StateSelection extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;
  final VoidCallback? onNext;

  const StateSelection({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.onNext,
  });

  @override
  State<StateSelection> createState() => _StateSelectionState();
}

class _StateSelectionState extends State<StateSelection> {
  String? _selectedState;
  bool _isLocationDetected = false;
  bool _isDetectingLocation = false;

  final List<Map<String, dynamic>> _states = [
    {'name': 'Andhra Pradesh', 'code': 'AP', 'solarPotential': 'High'},
    {'name': 'Arunachal Pradesh', 'code': 'AR', 'solarPotential': 'Medium'},
    {'name': 'Assam', 'code': 'AS', 'solarPotential': 'Medium'},
    {'name': 'Bihar', 'code': 'BR', 'solarPotential': 'High'},
    {'name': 'Chhattisgarh', 'code': 'CG', 'solarPotential': 'High'},
    {'name': 'Delhi', 'code': 'DL', 'solarPotential': 'High'},
    {'name': 'Goa', 'code': 'GA', 'solarPotential': 'High'},
    {'name': 'Gujarat', 'code': 'GJ', 'solarPotential': 'Very High'},
    {'name': 'Haryana', 'code': 'HR', 'solarPotential': 'High'},
    {'name': 'Himachal Pradesh', 'code': 'HP', 'solarPotential': 'High'},
    {'name': 'Jharkhand', 'code': 'JH', 'solarPotential': 'High'},
    {'name': 'Karnataka', 'code': 'KA', 'solarPotential': 'Very High'},
    {'name': 'Kerala', 'code': 'KL', 'solarPotential': 'High'},
    {'name': 'Madhya Pradesh', 'code': 'MP', 'solarPotential': 'Very High'},
    {'name': 'Maharashtra', 'code': 'MH', 'solarPotential': 'High'},
    {'name': 'Manipur', 'code': 'MN', 'solarPotential': 'Medium'},
    {'name': 'Meghalaya', 'code': 'ML', 'solarPotential': 'Medium'},
    {'name': 'Mizoram', 'code': 'MZ', 'solarPotential': 'Medium'},
    {'name': 'Nagaland', 'code': 'NL', 'solarPotential': 'Medium'},
    {'name': 'Odisha', 'code': 'OR', 'solarPotential': 'High'},
    {'name': 'Punjab', 'code': 'PB', 'solarPotential': 'High'},
    {'name': 'Rajasthan', 'code': 'RJ', 'solarPotential': 'Very High'},
    {'name': 'Sikkim', 'code': 'SK', 'solarPotential': 'High'},
    {'name': 'Tamil Nadu', 'code': 'TN', 'solarPotential': 'Very High'},
    {'name': 'Telangana', 'code': 'TG', 'solarPotential': 'High'},
    {'name': 'Tripura', 'code': 'TR', 'solarPotential': 'Medium'},
    {'name': 'Uttar Pradesh', 'code': 'UP', 'solarPotential': 'High'},
    {'name': 'Uttarakhand', 'code': 'UK', 'solarPotential': 'High'},
    {'name': 'West Bengal', 'code': 'WB', 'solarPotential': 'High'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedState = widget.initialValue;
    if (_selectedState == null) {
      _detectCurrentLocation();
    }
  }

  Future<void> _detectCurrentLocation() async {
    setState(() {
      _isDetectingLocation = true;
    });

    // Simulate GPS location detection
    await Future.delayed(Duration(seconds: 2));

    // Mock location detection - in real app, use geolocator package
    final mockDetectedState = 'Karnataka';

    setState(() {
      _selectedState = mockDetectedState;
      _isLocationDetected = true;
      _isDetectingLocation = false;
    });

    widget.onChanged(mockDetectedState);
  }

  Color _getSolarPotentialColor(String potential) {
    switch (potential) {
      case 'Very High':
        return Colors.green;
      case 'High':
        return Colors.lightGreen;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
            'Select Your State',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Text(
            'Solar subsidies and tariffs vary by state. Select your location for accurate calculations.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 3.h),

          // Auto-detect location button
          if (!_isLocationDetected)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 3.h),
              child: OutlinedButton(
                onPressed: _isDetectingLocation ? null : _detectCurrentLocation,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isDetectingLocation
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text('Detecting Location...'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'my_location',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text('Auto-Detect My Location'),
                        ],
                      ),
              ),
            ),

          // Location detected indicator
          if (_isLocationDetected)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              margin: EdgeInsets.only(bottom: 3.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Detected',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'You can change it by selecting from the list below',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // State selection dropdown
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedState != null
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: _selectedState != null ? 2 : 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedState,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Text(
                    'Select your state',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                isExpanded: true,
                icon: Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
                items: _states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state['name'],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state['name'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getSolarPotentialColor(
                                      state['solarPotential'])
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              state['solarPotential'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: _getSolarPotentialColor(
                                    state['solarPotential']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                  if (newValue != null) {
                    widget.onChanged(newValue);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return _states.map((state) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              state['name'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_selectedState != null)
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Solar potential info
          if (_selectedState != null)
            Container(
              width: double.infinity,
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
                  CustomIconWidget(
                    iconName: 'wb_sunny',
                    color: Colors.orange,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solar Potential in $_selectedState',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${_states.firstWhere((s) => s['name'] == _selectedState)['solarPotential']} - Great for solar installation!',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 4.h),

          // Next button
          if (_selectedState != null)
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
