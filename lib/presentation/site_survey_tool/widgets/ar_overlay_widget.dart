import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AROverlayWidget extends StatefulWidget {
  final bool isActive;
  final List<Offset> measurementPoints;

  const AROverlayWidget({
    super.key,
    required this.isActive,
    required this.measurementPoints,
  });

  @override
  State<AROverlayWidget> createState() => _AROverlayWidgetState();
}

class _AROverlayWidgetState extends State<AROverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return Positioned.fill(
      child: CustomPaint(
        painter: AROverlayPainter(
          measurementPoints: widget.measurementPoints,
          pulseAnimation: _pulseAnimation,
        ),
        child: Stack(
          children: [
            // AR measurement grid
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.accentLight.withAlpha(153),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        painter: MeasurementGridPainter(),
                      ),
                    ),
                  );
                },
              ),
            ),

            // AR instructions
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(179),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    Platform.isIOS
                        ? 'Tap corners to mark roof boundaries'
                        : 'Use measurement mode for roof mapping',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Measurement points display
            ...widget.measurementPoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;

              return Positioned(
                left: point.dx - 12,
                top: point.dy - 12,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryLight.withAlpha(128),
                            blurRadius: _pulseAnimation.value * 8,
                            spreadRadius: _pulseAnimation.value * 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class AROverlayPainter extends CustomPainter {
  final List<Offset> measurementPoints;
  final Animation<double> pulseAnimation;

  AROverlayPainter({
    required this.measurementPoints,
    required this.pulseAnimation,
  }) : super(repaint: pulseAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    if (measurementPoints.length < 2) return;

    final paint = Paint()
      ..color = AppTheme.primaryLight.withAlpha(204)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(measurementPoints.first.dx, measurementPoints.first.dy);

    for (int i = 1; i < measurementPoints.length; i++) {
      path.lineTo(measurementPoints[i].dx, measurementPoints[i].dy);
    }

    // Close polygon if we have 3+ points
    if (measurementPoints.length >= 3) {
      path.close();

      // Fill the polygon with semi-transparent color
      final fillPaint = Paint()
        ..color = AppTheme.accentLight.withAlpha(51)
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MeasurementGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentLight.withAlpha(102)
      ..strokeWidth = 1;

    const divisions = 8;
    final stepX = size.width / divisions;
    final stepY = size.height / divisions;

    // Draw vertical lines
    for (int i = 0; i <= divisions; i++) {
      final x = i * stepX;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= divisions; i++) {
      final y = i * stepY;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw center crosshair
    final centerPaint = Paint()
      ..color = AppTheme.primaryLight
      ..strokeWidth = 2;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const crosshairSize = 10;

    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY),
      Offset(centerX + crosshairSize, centerY),
      centerPaint,
    );

    canvas.drawLine(
      Offset(centerX, centerY - crosshairSize),
      Offset(centerX, centerY + crosshairSize),
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}