import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ResultsSummaryWidget extends StatelessWidget {
  final double area;
  final int photoCount;
  final int annotationCount;
  final VoidCallback onGenerateReport;

  const ResultsSummaryWidget({
    super.key,
    required this.area,
    required this.photoCount,
    required this.annotationCount,
    required this.onGenerateReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(217),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentLight.withAlpha(128),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.summarize,
                color: AppTheme.accentLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Survey Results',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Area measurement
          _buildResultRow(
            'Roof Area',
            '${area.toStringAsFixed(1)} sq m',
            Icons.straighten,
            AppTheme.primaryLight,
          ),

          // Estimated capacity
          _buildResultRow(
            'Est. Capacity',
            '${_calculateEstimatedCapacity(area).toStringAsFixed(1)} kW',
            Icons.electrical_services,
            AppTheme.secondaryLight,
          ),

          // Photos captured
          _buildResultRow(
            'Photos',
            '$photoCount captured',
            Icons.photo_camera,
            Colors.blue,
          ),

          // Annotations
          if (annotationCount > 0)
            _buildResultRow(
              'Annotations',
              '$annotationCount added',
              Icons.note,
              Colors.orange,
            ),

          // Estimated savings
          _buildResultRow(
            'Est. Savings',
            '₹${_calculateEstimatedSavings(area).toStringAsFixed(0)}/month',
            Icons.savings,
            Colors.green,
          ),

          const SizedBox(height: 16),

          // Generate report button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onGenerateReport,
              icon: const Icon(
                Icons.file_download,
                size: 16,
                color: Colors.white,
              ),
              label: Text(
                'Generate Report',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Confidence indicator
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: _getConfidenceColor(),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                '${_getConfidenceLevel()}% Confidence',
                style: GoogleFonts.inter(
                  color: _getConfidenceColor(),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateEstimatedCapacity(double area) {
    // Assuming 150W per square meter (typical solar panel efficiency)
    return (area * 0.15).clamp(0.0, 999.0);
  }

  double _calculateEstimatedSavings(double area) {
    // Rough calculation: ₹6 per kWh, 4 hours average sunlight, 30 days
    final capacity = _calculateEstimatedCapacity(area);
    return capacity * 4 * 30 * 6;
  }

  int _getConfidenceLevel() {
    // Confidence based on data quality
    int confidence = 60; // Base confidence

    if (area > 10) confidence += 20; // Reasonable area measured
    if (photoCount > 2) confidence += 10; // Multiple photos
    if (annotationCount > 0) confidence += 10; // Has annotations

    return confidence.clamp(0, 100);
  }

  Color _getConfidenceColor() {
    final confidence = _getConfidenceLevel();
    if (confidence >= 80) return Colors.green;
    if (confidence >= 60) return Colors.orange;
    return Colors.red;
  }
}