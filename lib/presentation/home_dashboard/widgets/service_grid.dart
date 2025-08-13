import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceGrid extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final Function(String route) onServiceTap;

  const ServiceGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.85,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(
            service: service,
            onTap: () => onServiceTap(service["route"] as String),
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) {
              _animationController.reverse();
              widget.onTap();
            },
            onTapCancel: () => _animationController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon container
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: widget.service["icon"] as String,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 8.w,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Service title
                    Text(
                      widget.service["title"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Service description
                    Text(
                      widget.service["description"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Status indicator
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: widget.service["isNew"] == true
                            ? AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.service["isNew"] == true
                          ? Text(
                              'New',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
