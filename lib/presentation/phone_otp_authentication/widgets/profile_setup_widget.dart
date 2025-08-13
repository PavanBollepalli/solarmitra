import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ProfileSetupWidget extends StatefulWidget {
  final String selectedRole;
  final Map<String, String> profileData;
  final ValueChanged<Map<String, String>> onProfileDataChanged;
  final VoidCallback onComplete;

  const ProfileSetupWidget({
    super.key,
    required this.selectedRole,
    required this.profileData,
    required this.onProfileDataChanged,
    required this.onComplete,
  });

  @override
  State<ProfileSetupWidget> createState() => _ProfileSetupWidgetState();
}

class _ProfileSetupWidgetState extends State<ProfileSetupWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String _selectedLanguage = 'hindi';
  String _selectedState = '';
  bool _isLoadingLocation = false;
  bool _locationPermissionGranted = false;

  final List<String> _languages = [
    'hindi',
    'english',
    'gujarati',
    'marathi',
    'bengali',
    'tamil',
    'telugu',
    'punjabi',
  ];

  final Map<String, String> _languageNames = {
    'hindi': 'हिंदी',
    'english': 'English',
    'gujarati': 'ગુજરાતી',
    'marathi': 'मराठी',
    'bengali': 'বাংলা',
    'tamil': 'தமிழ்',
    'telugu': 'తెలుగు',
    'punjabi': 'ਪੰਜਾਬੀ',
  };

  final List<String> _states = [
    'Andhra Pradesh',
    'Assam',
    'Bihar',
    'Gujarat',
    'Haryana',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Tamil Nadu',
    'Telangana',
    'Uttar Pradesh',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    _nameController.text = widget.profileData['name'] ?? '';
    _locationController.text = widget.profileData['location'] ?? '';
    _selectedState = widget.profileData['state'] ?? '';
    _selectedLanguage = widget.profileData['language'] ?? 'hindi';

    _animationController.forward();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
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
      _locationController.text =
          'Lat: ${position.latitude.toStringAsFixed(4)}, '
          'Lng: ${position.longitude.toStringAsFixed(4)}';

      HapticFeedback.lightImpact();
      _updateProfileData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('स्थान प्राप्त करने में त्रुटि'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _updateProfileData() {
    final updatedData = {
      ...widget.profileData,
      'name': _nameController.text,
      'location': _locationController.text,
      'state': _selectedState,
      'language': _selectedLanguage,
      'role': widget.selectedRole,
    };
    widget.onProfileDataChanged(updatedData);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.3),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: FadeTransition(
        opacity: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 2.h),

                // Header
                Text(
                  'अपनी जानकारी दें',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'बेहतर सुझाव के लिए अपनी जानकारी दें',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: 4.h),

                // Name field
                _buildInputField(
                  label: 'आपका नाम *',
                  controller: _nameController,
                  hint: 'पूरा नाम दर्ज करें',
                  icon: Icons.person,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'नाम आवश्यक है';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 3.h),

                // Location field with GPS button
                _buildLocationField(),

                SizedBox(height: 3.h),

                // State dropdown
                _buildStateDropdown(),

                SizedBox(height: 3.h),

                // Language selection
                _buildLanguageSelection(),

                SizedBox(height: 4.h),

                // Complete button
                SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _canComplete() ? _handleComplete : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.w),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'पूरा करें',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Privacy note
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: Colors.green.shade600,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'आपकी जानकारी सुरक्षित है',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade800,
                              ),
                            ),
                            Text(
                              'हम आपकी व्यक्तिगत जानकारी को पूरी सुरक्षा के साथ रखते हैं',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
          onChanged: (_) => _updateProfileData(),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'स्थान',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _locationController,
                style: GoogleFonts.inter(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: 'अपना पूरा पता दर्ज करें',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.w),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (_) => _updateProfileData(),
              ),
            ),
            SizedBox(width: 2.w),
            SizedBox(
              width: 12.w,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: _isLoadingLocation
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 6.w,
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'राज्य *',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _selectedState.isEmpty ? null : _selectedState,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.map),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
          hint: Text('राज्य चुनें'),
          items: _states.map((state) {
            return DropdownMenuItem(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedState = value ?? '';
            });
            _updateProfileData();
          },
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'राज्य चुनना आवश्यक है';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'प्राथमिक भाषा',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: _languages.map((language) {
            final isSelected = _selectedLanguage == language;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLanguage = language;
                });
                _updateProfileData();
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _languageNames[language] ?? language,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _canComplete() {
    return _nameController.text.isNotEmpty && _selectedState.isNotEmpty;
  }

  void _handleComplete() {
    if (_formKey.currentState?.validate() ?? false) {
      _updateProfileData();
      HapticFeedback.lightImpact();
      widget.onComplete();
    }
  }
}