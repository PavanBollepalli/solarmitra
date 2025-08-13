import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class StepIndicatorWidget extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  });

  @override
  State<StepIndicatorWidget> createState() => _StepIndicatorWidgetState();
}

class _StepIndicatorWidgetState extends State<StepIndicatorWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Color?>> _colorAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.totalSteps,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _colorAnimations = _animationControllers.map((controller) {
      return ColorTween(
        begin: Colors.grey.shade300,
        end: Theme.of(context).primaryColor,
      ).animate(controller);
    }).toList();

    // Animate completed and current steps
    for (int i = 0; i <= widget.currentStep; i++) {
      _animationControllers[i].forward();
    }
  }

  @override
  void didUpdateWidget(StepIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      // Animate new current step
      _animationControllers[widget.currentStep].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Step circles and connecting lines
        SizedBox(
          height: 8.h,
          child: Row(
            children: List.generate(widget.totalSteps * 2 - 1, (index) {
              if (index.isEven) {
                // Step circle
                final stepIndex = index ~/ 2;
                return _buildStepCircle(stepIndex, theme);
              } else {
                // Connecting line
                final stepIndex = index ~/ 2;
                return _buildConnectingLine(stepIndex, theme);
              }
            }),
          ),
        ),

        SizedBox(height: 2.h),

        // Step title
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.stepTitles[widget.currentStep],
            key: ValueKey(widget.currentStep),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Step description
        Text(
          'चरण ${widget.currentStep + 1} / ${widget.totalSteps}',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCircle(int stepIndex, ThemeData theme) {
    final isCompleted = stepIndex < widget.currentStep;
    final isCurrent = stepIndex == widget.currentStep;
    final isUpcoming = stepIndex > widget.currentStep;

    return Expanded(
      child: Container(
        height: 8.h,
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _animationControllers[stepIndex],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[stepIndex].value,
              child: Container(
                width: isCurrent ? 12.w : 10.w,
                height: isCurrent ? 12.w : 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? theme.primaryColor
                      : isCurrent
                          ? theme.primaryColor.withAlpha(51)
                          : Colors.grey.shade200,
                  border: Border.all(
                    color: isCompleted || isCurrent
                        ? theme.primaryColor
                        : Colors.grey.shade300,
                    width: isCurrent ? 3 : 2,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: theme.primaryColor.withAlpha(77),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 5.w,
                          key: ValueKey('check_$stepIndex'),
                        )
                      : isCurrent
                          ? Container(
                              width: 4.w,
                              height: 4.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primaryColor,
                              ),
                              key: ValueKey('current_$stepIndex'),
                            )
                          : Text(
                              '${stepIndex + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                              key: ValueKey('number_$stepIndex'),
                            ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildConnectingLine(int stepIndex, ThemeData theme) {
    final isCompleted = stepIndex < widget.currentStep;

    return Expanded(
      flex: 2,
      child: Container(
        height: 0.5.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: isCompleted ? theme.primaryColor : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(1.w),
          ),
        ),
      ),
    );
  }
}
