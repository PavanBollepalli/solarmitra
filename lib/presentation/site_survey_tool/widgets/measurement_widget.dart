import 'dart:math' as dart_math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MeasurementWidget extends StatelessWidget {
  final List<Offset> points;
  final double calculatedArea;

  const MeasurementWidget({
    super.key,
    required this.points,
    required this.calculatedArea,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: MeasurementPainter(points: points),
        child: Stack(
          children: [
            // Area display
            if (calculatedArea > 0)
              Positioned(
                top: 200,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryLight.withAlpha(230),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.straighten,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Roof Area',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${calculatedArea.toStringAsFixed(1)} sq m',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (calculatedArea > 0)
                        Text(
                          '~${_estimatePanelCapacity(calculatedArea)} kW',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Point counter
            if (points.isNotEmpty)
              Positioned(
                top: 160,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withAlpha(230),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${points.length} point${points.length != 1 ? 's' : ''}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Clear points button
            if (points.isNotEmpty)
              Positioned(
                top: 160,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    // This would be handled by parent widget
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight.withAlpha(230),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _estimatePanelCapacity(double area) {
    // Assuming 15-20% panel efficiency and typical panel size
    final capacity = (area * 0.15).clamp(0.0, 999.0);
    return capacity.toStringAsFixed(1);
  }
}

class MeasurementPainter extends CustomPainter {
  final List<Offset> points;

  MeasurementPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = AppTheme.primaryLight
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.primaryLight
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(77)
      ..style = PaintingStyle.fill;

    // Draw connecting lines
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      // Close polygon if we have 3+ points
      if (points.length >= 3) {
        path.close();

        // Fill the polygon
        final fillPaint = Paint()
          ..color = AppTheme.accentLight.withAlpha(38)
          ..style = PaintingStyle.fill;
        canvas.drawPath(path, fillPaint);
      }

      canvas.drawPath(path, linePaint);
    }

    // Draw measurement points
    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      // Draw shadow
      canvas.drawCircle(
        Offset(point.dx + 1, point.dy + 1),
        8,
        shadowPaint,
      );

      // Draw outer circle
      canvas.drawCircle(
        point,
        8,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );

      // Draw inner dot
      canvas.drawCircle(point, 6, dotPaint);

      // Draw point number
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }

    // Draw distance measurements between consecutive points
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i];
      final end = points[i + 1];
      final midPoint = Offset(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
      );

      final distance = _calculateDistance(start, end);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${distance.toStringAsFixed(1)}m',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(0.5, 0.5),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      // Background for text
      final textRect = Rect.fromCenter(
        center: midPoint,
        width: textPainter.width + 8,
        height: textPainter.height + 4,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(textRect, const Radius.circular(4)),
        Paint()
          ..color = Colors.black.withAlpha(179)
          ..style = PaintingStyle.fill,
      );

      textPainter.paint(
        canvas,
        Offset(
          midPoint.dx - textPainter.width / 2,
          midPoint.dy - textPainter.height / 2,
        ),
      );
    }
  }

  double _calculateDistance(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    // Convert screen pixels to approximate meters (simplified calculation)
    return (dart_math.sqrt(dx * dx + dy * dy) * 0.05).clamp(0.1, 999.0);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// Import for sqrt function