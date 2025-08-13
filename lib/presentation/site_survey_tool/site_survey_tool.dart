import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/annotation_tools_widget.dart';
import './widgets/ar_overlay_widget.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/measurement_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/results_summary_widget.dart';
import './widgets/shadow_analysis_widget.dart';
import './widgets/status_bar_widget.dart';
import 'widgets/annotation_tools_widget.dart';
import 'widgets/ar_overlay_widget.dart';
import 'widgets/camera_controls_widget.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/measurement_widget.dart';
import 'widgets/photo_gallery_widget.dart';
import 'widgets/results_summary_widget.dart';
import 'widgets/shadow_analysis_widget.dart';
import 'widgets/status_bar_widget.dart';

class SiteSurveyTool extends StatefulWidget {
  const SiteSurveyTool({super.key});

  @override
  State<SiteSurveyTool> createState() => _SiteSurveyToolState();
}

class _SiteSurveyToolState extends State<SiteSurveyTool>
    with TickerProviderStateMixin {
  // Camera and AR
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isGridVisible = true;

  // Location and compass
  Position? _currentPosition;
  double _heading = 0.0;
  bool _isLocationServiceEnabled = false;

  // AR and measurement
  bool _isARModeActive = false;
  bool _isMeasurementMode = false;
  List<Offset> _measurementPoints = [];
  double _calculatedArea = 0.0;

  // Photos and annotations
  List<Map<String, dynamic>> _capturedPhotos = [];
  List<Map<String, dynamic>> _annotations = [];

  // OCR
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  // Survey data
  Map<String, dynamic> _surveyData = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
    _initializeLocation();
    _initializeCompass();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }

  Future<void> _initializeCamera() async {
    try {
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applyPlatformSpecificSettings();

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applyPlatformSpecificSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _initializeLocation() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestedPermission = await Geolocator.requestPermission();
        if (requestedPermission == LocationPermission.denied) return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {});
    } catch (e) {
      debugPrint('Location initialization error: $e');
    }
  }

  void _initializeCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading ?? 0.0;
      });
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    try {
      HapticFeedback.mediumImpact();
      _scaleController.forward().then((_) => _scaleController.reverse());

      final XFile photo = await _cameraController!.takePicture();

      final photoData = {
        'path': photo.path,
        'timestamp': DateTime.now().toIso8601String(),
        'location': _currentPosition != null
            ? {
                'latitude': _currentPosition!.latitude,
                'longitude': _currentPosition!.longitude,
              }
            : null,
        'heading': _heading,
        'measurements': List.from(_measurementPoints.map((p) => {
              'x': p.dx,
              'y': p.dy,
            })),
        'area': _calculatedArea,
      };

      setState(() {
        _capturedPhotos.add(photoData);
      });

      // Perform OCR on the captured image if needed
      await _performOCR(photo.path);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _performOCR(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Store OCR results for electricity meter readings
      if (recognizedText.text.isNotEmpty) {
        _surveyData['ocrResults'] = recognizedText.text;
      }
    } catch (e) {
      debugPrint('OCR error: $e');
    }
  }

  void _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final flashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(flashMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  void _toggleGrid() {
    setState(() {
      _isGridVisible = !_isGridVisible;
    });
  }

  void _toggleARMode() {
    setState(() {
      _isARModeActive = !_isARModeActive;
    });
  }

  void _toggleMeasurementMode() {
    setState(() {
      _isMeasurementMode = !_isMeasurementMode;
      if (!_isMeasurementMode) {
        _measurementPoints.clear();
        _calculatedArea = 0.0;
      }
    });
  }

  void _onTapMeasurement(Offset position) {
    if (!_isMeasurementMode) return;

    setState(() {
      _measurementPoints.add(position);
      if (_measurementPoints.length >= 3) {
        _calculatedArea = _calculatePolygonArea(_measurementPoints);
      }
    });
  }

  double _calculatePolygonArea(List<Offset> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      final j = (i + 1) % points.length;
      area += points[i].dx * points[j].dy;
      area -= points[j].dx * points[i].dy;
    }
    return (area.abs() / 2.0) * 0.01; // Convert to approximate square meters
  }

  void _addAnnotation(String type, String description, Offset position) {
    final annotation = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': type,
      'description': description,
      'position': {'x': position.dx, 'y': position.dy},
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _annotations.add(annotation);
    });
  }

  Future<void> _generateSurveyReport() async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Solar Site Survey Report'),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Survey Date: ${now.day}/${now.month}/${now.year}'),
                pw.Text('Survey Time: ${now.hour}:${now.minute}'),
                if (_currentPosition != null) ...[
                  pw.SizedBox(height: 10),
                  pw.Text('Location:'),
                  pw.Text(
                      'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
                  pw.Text(
                      'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                ],
                pw.SizedBox(height: 20),
                pw.Text('Measurements:'),
                pw.Text(
                    'Total usable roof area: ${_calculatedArea.toStringAsFixed(2)} sq m'),
                pw.Text('Photos captured: ${_capturedPhotos.length}'),
                pw.Text('Annotations: ${_annotations.length}'),
                if (_surveyData['ocrResults'] != null) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Electricity Meter Reading:'),
                  pw.Text(_surveyData['ocrResults']),
                ],
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/site_survey_${now.millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Survey report saved to ${file.path}')),
        );
      }
    } catch (e) {
      debugPrint('Report generation error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeController,
        child: Stack(
          children: [
            // Camera preview
            if (_isCameraInitialized)
              CameraPreviewWidget(
                controller: _cameraController!,
                onTap: _onTapMeasurement,
              ),

            // Status bar
            StatusBarWidget(
              position: _currentPosition,
              heading: _heading,
              isLocationEnabled: _isLocationServiceEnabled,
            ),

            // AR overlay
            if (_isARModeActive)
              AROverlayWidget(
                isActive: _isARModeActive,
                measurementPoints: _measurementPoints,
              ),

            // Grid overlay
            if (_isGridVisible)
              Positioned.fill(
                child: CustomPaint(
                  painter: GridPainter(),
                ),
              ),

            // Measurement overlay
            if (_isMeasurementMode)
              MeasurementWidget(
                points: _measurementPoints,
                calculatedArea: _calculatedArea,
              ),

            // Annotations overlay
            ...(_annotations.map((annotation) => AnnotationToolsWidget(
                  annotation: annotation,
                  onRemove: () {
                    setState(() {
                      _annotations.remove(annotation);
                    });
                  },
                ))),

            // Bottom camera controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CameraControlsWidget(
                isFlashOn: _isFlashOn,
                isGridVisible: _isGridVisible,
                isARModeActive: _isARModeActive,
                isMeasurementMode: _isMeasurementMode,
                onFlashToggle: _toggleFlash,
                onGridToggle: _toggleGrid,
                onARToggle: _toggleARMode,
                onMeasurementToggle: _toggleMeasurementMode,
                onCapture: _capturePhoto,
                scaleAnimation: _scaleController,
                canUseFlash: !kIsWeb,
              ),
            ),

            // Photo gallery
            if (_capturedPhotos.isNotEmpty)
              Positioned(
                left: 16,
                bottom: 120,
                child: PhotoGalleryWidget(
                  photos: _capturedPhotos,
                  onPhotoTap: (photo) {
                    // Show photo details
                  },
                ),
              ),

            // Shadow analysis (simplified visualization)
            if (_isARModeActive)
              ShadowAnalysisWidget(
                sunPosition: _calculateSunPosition(),
                roofPoints: _measurementPoints,
              ),

            // Results summary
            if (_calculatedArea > 0)
              Positioned(
                top: 100,
                right: 16,
                child: ResultsSummaryWidget(
                  area: _calculatedArea,
                  photoCount: _capturedPhotos.length,
                  annotationCount: _annotations.length,
                  onGenerateReport: _generateSurveyReport,
                ),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(128),
        title: Text(
          'Site Survey Tool',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Show help dialog
              _showHelpDialog();
            },
          ),
        ],
      ),
    );
  }

  Offset _calculateSunPosition() {
    // Simplified sun position calculation based on time and location
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    // Approximate sun position (this would be more complex in real implementation)
    final sunAngle = ((hour + minute / 60.0) - 6) * 15; // Degrees from east
    final x = (sunAngle / 180) * MediaQuery.of(context).size.width;
    final y =
        MediaQuery.of(context).size.height * 0.3; // Fixed height for simplicity

    return Offset(x, y);
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Site Survey Tool Help', style: GoogleFonts.poppins()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('📷', 'Tap capture button to take photos'),
              _buildHelpItem(
                  '📐', 'Enable measurement mode to mark roof corners'),
              _buildHelpItem('🔍', 'Use AR mode for enhanced visualization'),
              _buildHelpItem('📍', 'Allow location access for GPS coordinates'),
              _buildHelpItem('💡', 'Use flash in low light conditions'),
              _buildHelpItem(
                  '📊', 'View results summary for area calculations'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.inter(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 0.5;

    const gridSpacing = 40.0;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}