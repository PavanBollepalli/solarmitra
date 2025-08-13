import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../../core/app_export.dart';

class CalculationLoading extends StatefulWidget {
  final VoidCallback onComplete;

  const CalculationLoading({
    super.key,
    required this.onComplete,
  });

  @override
  State<CalculationLoading> createState() => _CalculationLoadingState();
}

class _CalculationLoadingState extends State<CalculationLoading>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _rotationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _rotationAnimation;

  int _currentStep = 0;
  double _progress = 0.0;

  final List<String> _calculationSteps = [
    'Analyzing roof area and solar potential...',
    'Calculating system size requirements...',
    'Estimating installation costs...',
    'Computing government subsidies...',
    'Calculating monthly savings...',
    'Determining payback period...',
    'Generating environmental impact...',
    'Finalizing recommendations...',
  ];

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _startCalculation();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _startCalculation() {
    _rotationController.repeat();

    // Update progress and steps
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentStep < _calculationSteps.length - 1) {
        setState(() {
          _currentStep++;
          _progress = (_currentStep + 1) / _calculationSteps.length;
        });
        _progressController.animateTo(_progress);
      } else {
        timer.cancel();
        _rotationController.stop();

        // Complete calculation after a brief delay
        Future.delayed(Duration(milliseconds: 500), () {
          widget.onComplete();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Solar panel animation
          Container(
            width: 40.w,
            height: 40.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating sun
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.yellow.shade300,
                              Colors.orange.shade400,
                              Colors.orange.shade600,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'wb_sunny',
                          color: Colors.white,
                          size: 15.w,
                        ),
                      ),
                    );
                  },
                ),

                // Solar panel
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 25.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade800,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // Progress indicator
          Container(
            width: 80.w,
            child: Column(
              children: [
                // Progress bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary,
                                Colors.orange,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 2.h),

                // Progress percentage
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Current step
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'calculate',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Calculating Your Solar Potential',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  _calculationSteps[_currentStep],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Fun facts
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.shade200,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'eco',
                      color: Colors.green,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Did you know?',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Solar panels can reduce your electricity bill by up to 90% and help save the environment by reducing carbon emissions!',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}