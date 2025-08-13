import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ShadowAnalysisWidget extends StatelessWidget {
  final Offset sunPosition;
  final List<Offset> roofPoints;

  const ShadowAnalysisWidget({
    super.key,
    required this.sunPosition,
    required this.roofPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ShadowAnalysisPainter(
          sunPosition: sunPosition,
          roofPoints: roofPoints,
        ),
        child: Stack(
          children: [
            // Sun position indicator
            Positioned(
              left: sunPosition.dx - 20,
              top: sunPosition.dy - 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow.withAlpha(204),
                      Colors.orange.withAlpha(153),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  color: Colors.yellow,
                  size: 24,
                ),
              ),
            ),

            // Shadow analysis panel
            if (roofPoints.isNotEmpty)
              Positioned(
                bottom: 200,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(204),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.accentLight.withAlpha(77),
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
                            Icons.wb_shade,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Shadow Analysis',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildAnalysisRow(
                        'Optimal Zone',
                        '${_calculateOptimalPercentage()}%',
                        Colors.green,
                      ),
                      _buildAnalysisRow(
                        'Partial Shade',
                        '${_calculatePartialShadePercentage()}%',
                        Colors.orange,
                      ),
                      _buildAnalysisRow(
                        'Heavy Shade',
                        '${_calculateHeavyShadePercentage()}%',
                        Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current: ${_getCurrentTimeLabel()}',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateOptimalPercentage() {
    // Simplified calculation - in real implementation would use sun path analysis
    if (roofPoints.isEmpty) return 0;

    final now = DateTime.now();
    final hour = now.hour;

    // Peak sun hours (10 AM - 4 PM) give better optimal percentage
    if (hour >= 10 && hour <= 16) {
      return 75;
    } else if (hour >= 8 && hour <= 18) {
      return 50;
    } else {
      return 25;
    }
  }

  int _calculatePartialShadePercentage() {
    return (100 -
            _calculateOptimalPercentage() -
            _calculateHeavyShadePercentage())
        .clamp(0, 100);
  }

  int _calculateHeavyShadePercentage() {
    final now = DateTime.now();
    final hour = now.hour;

    // Early morning and evening have more heavy shade
    if (hour < 8 || hour > 18) {
      return 60;
    } else {
      return 15;
    }
  }

  String _getCurrentTimeLabel() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }
}

class ShadowAnalysisPainter extends CustomPainter {
  final Offset sunPosition;
  final List<Offset> roofPoints;

  ShadowAnalysisPainter({
    required this.sunPosition,
    required this.roofPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (roofPoints.length < 3) return;

    // Create shadow zones based on sun position
    final optimalPaint = Paint()
      ..color = Colors.green.withAlpha(51)
      ..style = PaintingStyle.fill;

    final partialShadePaint = Paint()
      ..color = Colors.orange.withAlpha(38)
      ..style = PaintingStyle.fill;

    final heavyShadePaint = Paint()
      ..color = Colors.red.withAlpha(26)
      ..style = PaintingStyle.fill;

    // Calculate zones based on sun position relative to roof
    final roofCenter = _calculateCentroid(roofPoints);
    final sunVector = Offset(
      sunPosition.dx - roofCenter.dx,
      sunPosition.dy - roofCenter.dy,
    );

    // Draw shadow zones (simplified visualization)
    for (int i = 0; i < roofPoints.length; i++) {
      final point = roofPoints[i];
      final nextPoint = roofPoints[(i + 1) % roofPoints.length];

      // Calculate if this edge faces the sun
      final edgeVector = Offset(
        nextPoint.dx - point.dx,
        nextPoint.dy - point.dy,
      );

      final dotProduct =
          sunVector.dx * edgeVector.dx + sunVector.dy * edgeVector.dy;

      Paint zonePaint;
      if (dotProduct > 0.7) {
        zonePaint = optimalPaint;
      } else if (dotProduct > 0.2) {
        zonePaint = partialShadePaint;
      } else {
        zonePaint = heavyShadePaint;
      }

      // Draw zone triangle
      final path = Path()
        ..moveTo(roofCenter.dx, roofCenter.dy)
        ..lineTo(point.dx, point.dy)
        ..lineTo(nextPoint.dx, nextPoint.dy)
        ..close();

      canvas.drawPath(path, zonePaint);
    }

    // Draw sun rays for visualization
    final rayPaint = Paint()
      ..color = Colors.yellow.withAlpha(77)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw rays from sun to roof points
    for (final point in roofPoints) {
      canvas.drawLine(sunPosition, point, rayPaint);
    }
  }

  Offset _calculateCentroid(List<Offset> points) {
    double x = 0, y = 0;
    for (final point in points) {
      x += point.dx;
      y += point.dy;
    }
    return Offset(x / points.length, y / points.length);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}