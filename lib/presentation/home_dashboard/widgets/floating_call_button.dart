import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingCallButton extends StatefulWidget {
  final VoidCallback onPressed;

  const FloatingCallButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<FloatingCallButton> createState() => _FloatingCallButtonState();
}

class _FloatingCallButtonState extends State<FloatingCallButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 10.h,
      right: 4.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pulse ring
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ),

                // Main button
                GestureDetector(
                  onTapDown: (_) => _scaleController.forward(),
                  onTapUp: (_) {
                    _scaleController.reverse();
                    widget.onPressed();
                  },
                  onTapCancel: () => _scaleController.reverse(),
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CallMitraDialog extends StatelessWidget {
  const CallMitraDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'support_agent',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Call Solar Mitra',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Get instant help from our experts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Contact options
            _buildContactOption(
              context,
              'Call Helpline',
              '1800-XXX-XXXX',
              'phone',
              () {
                Navigator.of(context).pop();
                // Implement phone call
              },
            ),

            SizedBox(height: 2.h),

            _buildContactOption(
              context,
              'WhatsApp Support',
              'Chat with expert',
              'chat',
              () {
                Navigator.of(context).pop();
                // Implement WhatsApp integration
              },
            ),

            SizedBox(height: 4.h),

            // Close button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    String title,
    String subtitle,
    String iconName,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
