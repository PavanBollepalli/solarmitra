import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraControlsWidget extends StatelessWidget {
  final bool isFlashOn;
  final bool isGridVisible;
  final bool isARModeActive;
  final bool isMeasurementMode;
  final bool canUseFlash;
  final VoidCallback onFlashToggle;
  final VoidCallback onGridToggle;
  final VoidCallback onARToggle;
  final VoidCallback onMeasurementToggle;
  final VoidCallback onCapture;
  final AnimationController scaleAnimation;

  const CameraControlsWidget({
    super.key,
    required this.isFlashOn,
    required this.isGridVisible,
    required this.isARModeActive,
    required this.isMeasurementMode,
    required this.canUseFlash,
    required this.onFlashToggle,
    required this.onGridToggle,
    required this.onARToggle,
    required this.onMeasurementToggle,
    required this.onCapture,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withAlpha(204),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flash control
          _buildControlButton(
            icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
            label: 'Flash',
            isActive: isFlashOn,
            isEnabled: canUseFlash,
            onTap: canUseFlash ? onFlashToggle : null,
          ),

          // Grid control
          _buildControlButton(
            icon: Icons.grid_on,
            label: 'Grid',
            isActive: isGridVisible,
            onTap: onGridToggle,
          ),

          // Capture button
          AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (scaleAnimation.value * 0.1),
                child: GestureDetector(
                  onTap: onCapture,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryLight,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryLight.withAlpha(102),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              );
            },
          ),

          // AR mode control
          _buildControlButton(
            icon: Icons.view_in_ar,
            label: 'AR',
            isActive: isARModeActive,
            onTap: onARToggle,
          ),

          // Measurement control
          _buildControlButton(
            icon: Icons.straighten,
            label: 'Measure',
            isActive: isMeasurementMode,
            onTap: onMeasurementToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    bool isEnabled = true,
    VoidCallback? onTap,
  }) {
    final color = isEnabled
        ? (isActive ? AppTheme.accentLight : Colors.white)
        : Colors.grey;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? AppTheme.accentLight.withAlpha(51)
                  : Colors.black.withAlpha(77),
              border: Border.all(
                color: color,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}