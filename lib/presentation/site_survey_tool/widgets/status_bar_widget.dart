import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class StatusBarWidget extends StatefulWidget {
  final Position? position;
  final double heading;
  final bool isLocationEnabled;

  const StatusBarWidget({
    super.key,
    this.position,
    required this.heading,
    required this.isLocationEnabled,
  });

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
      });
    });
  }

  String _getCompassDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'N';
    if (heading >= 22.5 && heading < 67.5) return 'NE';
    if (heading >= 67.5 && heading < 112.5) return 'E';
    if (heading >= 112.5 && heading < 157.5) return 'SE';
    if (heading >= 157.5 && heading < 202.5) return 'S';
    if (heading >= 202.5 && heading < 247.5) return 'SW';
    if (heading >= 247.5 && heading < 292.5) return 'W';
    if (heading >= 292.5 && heading < 337.5) return 'NW';
    return 'N';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(179),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryLight.withAlpha(77),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GPS coordinates
            Expanded(
              child: Row(
                children: [
                  Icon(
                    widget.isLocationEnabled
                        ? Icons.location_on
                        : Icons.location_off,
                    color: widget.isLocationEnabled ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.position != null
                          ? '${widget.position!.latitude.toStringAsFixed(4)}, ${widget.position!.longitude.toStringAsFixed(4)}'
                          : 'Location unavailable',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Compass direction
            Row(
              children: [
                Transform.rotate(
                  angle: (widget.heading * 3.14159) / 180,
                  child: const Icon(
                    Icons.navigation,
                    color: AppTheme.accentLight,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _getCompassDirection(widget.heading),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Network connectivity
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}