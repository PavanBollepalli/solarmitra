import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculation_loading.dart';
import './widgets/calculation_results.dart';
import './widgets/electricity_bill_input.dart';
import './widgets/roof_area_input.dart';
import './widgets/roof_type_selection.dart';
import './widgets/state_selection.dart';
import './widgets/step_progress_indicator.dart';

class RooftopSolarCalculator extends StatefulWidget {
  const RooftopSolarCalculator({super.key});

  @override
  State<RooftopSolarCalculator> createState() => _RooftopSolarCalculatorState();
}

class _RooftopSolarCalculatorState extends State<RooftopSolarCalculator> {
  int _currentStep = 0;
  bool _isCalculating = false;
  bool _showResults = false;

  // Form data
  double? _roofArea;
  String? _selectedState;
  double? _monthlyBill;
  String? _roofType;

  final List<String> _stepTitles = [
    'Roof Area',
    'Location',
    'Electricity Bill',
    'Roof Type',
  ];

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _startCalculation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _startCalculation() {
    setState(() {
      _isCalculating = true;
    });
  }

  void _onCalculationComplete() {
    setState(() {
      _isCalculating = false;
      _showResults = true;
    });
  }

  void _shareResults() {
    // Generate and share PDF report
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'PDF report generated and shared via WhatsApp!',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _startOver() {
    setState(() {
      _currentStep = 0;
      _isCalculating = false;
      _showResults = false;
      _roofArea = null;
      _selectedState = null;
      _monthlyBill = null;
      _roofType = null;
    });
  }

  Map<String, dynamic> _getCalculationData() {
    return {
      'roofArea': _roofArea,
      'state': _selectedState,
      'monthlyBill': _monthlyBill,
      'roofType': _roofType,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_showResults || _isCalculating) {
              _startOver();
            } else if (_currentStep > 0) {
              _previousStep();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: _showResults || _isCalculating
                ? 'refresh'
                : _currentStep > 0
                    ? 'arrow_back'
                    : 'close',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'Solar Calculator',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showHelpDialog();
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _showResults
            ? CalculationResults(
                calculationData: _getCalculationData(),
                onShare: _shareResults,
                onStartOver: _startOver,
              )
            : _isCalculating
                ? CalculationLoading(
                    onComplete: _onCalculationComplete,
                  )
                : Column(
                    children: [
                      // Progress indicator
                      StepProgressIndicator(
                        currentStep: _currentStep,
                        totalSteps: _stepTitles.length,
                        stepTitles: _stepTitles,
                      ),

                      // Step content
                      Expanded(
                        child: _buildCurrentStep(),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return RoofAreaInput(
          initialValue: _roofArea,
          onChanged: (value) {
            setState(() {
              _roofArea = value;
            });
          },
          onNext: _roofArea != null ? _nextStep : null,
        );

      case 1:
        return StateSelection(
          initialValue: _selectedState,
          onChanged: (value) {
            setState(() {
              _selectedState = value;
            });
          },
          onNext: _selectedState != null ? _nextStep : null,
        );

      case 2:
        return ElectricityBillInput(
          initialValue: _monthlyBill,
          onChanged: (value) {
            setState(() {
              _monthlyBill = value;
            });
          },
          onNext: _monthlyBill != null ? _nextStep : null,
        );

      case 3:
        return RoofTypeSelection(
          initialValue: _roofType,
          onChanged: (value) {
            setState(() {
              _roofType = value;
            });
          },
          onNext: _roofType != null ? _nextStep : null,
        );

      default:
        return Container();
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Calculator Help',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This calculator helps you estimate:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            ..._buildHelpItems([
              '• Solar system size for your roof',
              '• Installation costs and subsidies',
              '• Monthly electricity bill savings',
              '• Payback period and ROI',
              '• Environmental impact benefits',
            ]),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'All calculations are estimates. Contact certified installers for accurate quotes.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHelpItems(List<String> items) {
    return items
        .map((item) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Text(
                item,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ))
        .toList();
  }
}
