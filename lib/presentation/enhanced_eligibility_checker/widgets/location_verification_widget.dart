import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class LocationVerificationWidget extends StatefulWidget {
  final String location;
  final ValueChanged<String> onLocationChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const LocationVerificationWidget({
    super.key,
    required this.location,
    required this.onLocationChanged,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<LocationVerificationWidget> createState() =>
      _LocationVerificationWidgetState();
}

class _LocationVerificationWidgetState extends State<LocationVerificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  final TextEditingController _locationController = TextEditingController();
  bool _isLoadingLocation = false;
  String _detectedLocation = '';
  String _selectedState = '';
  String _selectedDistrict = '';
  bool _locationPermissionGranted = false;

  final Map<String, List<String>> _stateDistricts = {
    'Uttar Pradesh': [
      'Lucknow',
      'Kanpur',
      'Agra',
      'Varanasi',
      'Meerut',
      'Allahabad'
    ],
    'Maharashtra': [
      'Mumbai',
      'Pune',
      'Nagpur',
      'Thane',
      'Nashik',
      'Aurangabad'
    ],
    'Gujarat': [
      'Ahmedabad',
      'Surat',
      'Vadodara',
      'Rajkot',
      'Bhavnagar',
      'Jamnagar'
    ],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Ajmer', 'Bikaner'],
    'Punjab': [
      'Ludhiana',
      'Amritsar',
      'Jalandhar',
      'Patiala',
      'Bathinda',
      'Mohali'
    ],
    'Haryana': [
      'Gurugram',
      'Faridabad',
      'Panipat',
      'Ambala',
      'Yamunanagar',
      'Rohtak'
    ],
    'Madhya Pradesh': [
      'Bhopal',
      'Indore',
      'Gwalior',
      'Jabalpur',
      'Ujjain',
      'Sagar'
    ],
    'Bihar': [
      'Patna',
      'Gaya',
      'Bhagalpur',
      'Muzaffarpur',
      'Purnia',
      'Darbhanga'
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _locationController.text = widget.location;
    _locationController.addListener(() {
      widget.onLocationChanged(_locationController.text);
    });
    _checkLocationPermission();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutQuart,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    if (kIsWeb) {
      setState(() {
        _locationPermissionGranted = true;
      });
      return;
    }

    final permission = await Permission.location.status;
    setState(() {
      _locationPermissionGranted = permission.isGranted;
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      if (kIsWeb) {
        // Web implementation
        await _getWebLocation();
      } else {
        // Mobile implementation
        await _getMobileLocation();
      }

      HapticFeedback.lightImpact();
    } catch (e) {
      _showLocationError();
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getWebLocation() async {
    // Mock location for web demo
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _detectedLocation = 'New Delhi, Delhi, India';
      _locationController.text = _detectedLocation;
    });
  }

  Future<void> _getMobileLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationPermissionDialog();
      return;
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Mock reverse geocoding for demo
    setState(() {
      _detectedLocation = 'Lat: ${position.latitude.toStringAsFixed(4)}, '
          'Lng: ${position.longitude.toStringAsFixed(4)}';
      _locationController.text = _detectedLocation;
    });
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Service'),
        content: Text('कृपया अपना GPS चालू करें'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('स्थान अनुमति'),
        content: Text('बेहतर सुझाव के लिए स्थान की अनुमति दें'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('बाद में'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('सेटिंग्स खोलें'),
          ),
        ],
      ),
    );
  }

  void _showLocationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('स्थान प्राप्त करने में त्रुटि'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'पुनः प्रयास',
          textColor: Colors.white,
          onPressed: _getCurrentLocation,
        ),
      ),
    );
  }

  bool _canProceed() {
    return _locationController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 2.h),

                  // Header
                  _buildHeader(theme),

                  SizedBox(height: 4.h),

                  // GPS location section
                  _buildGPSLocationSection(theme),

                  SizedBox(height: 4.h),

                  // Manual location input
                  _buildManualLocationSection(theme),

                  SizedBox(height: 4.h),

                  // State and district selection
                  _buildLocationDropdowns(theme),

                  SizedBox(height: 4.h),

                  // Location benefits info
                  _buildLocationBenefitsInfo(theme),

                  SizedBox(height: 4.h),

                  // Navigation buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 6.h,
                          child: OutlinedButton(
                            onPressed: widget.onPrevious,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.primaryColor,
                              side: BorderSide(color: theme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back, size: 5.w),
                                SizedBox(width: 2.w),
                                Text(
                                  'वापस',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: SizedBox(
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _canProceed() ? _handleNext : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                              elevation: _canProceed() ? 2 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'आगे बढ़ें',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(Icons.arrow_forward, size: 5.w),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Icon(
              Icons.location_on,
              color: theme.primaryColor,
              size: 10.w,
            ),
          ),
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            );
          },
        ),
        SizedBox(height: 3.h),
        Text(
          'स्थान सत्यापन',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'सटीक स्थान से बेहतर योजनाएं\nऔर स्थानीय इंस्टॉलर मिलेंगे',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildGPSLocationSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.gps_fixed,
                color: Colors.green.shade600,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'GPS से स्थान पता करें',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'सबसे सटीक परिणामों के लिए अपनी वर्तमान स्थिति का उपयोग करें',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              icon: _isLoadingLocation
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.my_location, size: 5.w),
              label: Text(
                _isLoadingLocation
                    ? 'स्थान पता कर रहे हैं...'
                    : 'मेरा स्थान पता करें',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualLocationSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'या अपना पता मैन्युअल दर्ज करें',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _locationController,
          maxLines: 2,
          style: GoogleFonts.inter(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: 'पूरा पता दर्ज करें...\nजैसे: गांव/शहर, जिला, राज्य',
            prefixIcon: Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
              borderSide: BorderSide(
                color: theme.primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDropdowns(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'राज्य और जिला चुनें',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),

        // State dropdown
        DropdownButtonFormField<String>(
          value: _selectedState.isEmpty ? null : _selectedState,
          decoration: InputDecoration(
            hintText: 'राज्य चुनें',
            prefixIcon: const Icon(Icons.map),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
          ),
          items: _stateDistricts.keys.map((state) {
            return DropdownMenuItem(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedState = value ?? '';
              _selectedDistrict = ''; // Reset district when state changes
            });
          },
        ),

        SizedBox(height: 2.h),

        // District dropdown
        DropdownButtonFormField<String>(
          value: _selectedDistrict.isEmpty ? null : _selectedDistrict,
          decoration: InputDecoration(
            hintText: 'जिला चुनें',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
          ),
          items: _selectedState.isEmpty
              ? []
              : _stateDistricts[_selectedState]!.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
          onChanged: _selectedState.isEmpty
              ? null
              : (value) {
                  setState(() {
                    _selectedDistrict = value ?? '';
                  });
                },
        ),
      ],
    );
  }

  Widget _buildLocationBenefitsInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue.shade600,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'स्थान के फायदे',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '• क्षेत्रीय सरकारी योजनाओं की जानकारी\n• नजदीकी प्रमाणित इंस्टॉलर\n• स्थानीय सब्सिडी दरें\n• मौसम के अनुसार सोलर उत्पादन की गणना',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_selectedState.isNotEmpty && _selectedDistrict.isNotEmpty) {
      final fullLocation = '$_selectedDistrict, $_selectedState';
      _locationController.text = fullLocation;
      widget.onLocationChanged(fullLocation);
    }

    HapticFeedback.mediumImpact();
    widget.onNext();
  }
}