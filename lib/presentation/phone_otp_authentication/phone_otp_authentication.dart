import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/otp_verification_widget.dart';
import './widgets/phone_number_input_widget.dart';
import './widgets/profile_setup_widget.dart';
import './widgets/role_selection_widget.dart';
import 'widgets/otp_verification_widget.dart';
import 'widgets/phone_number_input_widget.dart';
import 'widgets/profile_setup_widget.dart';
import 'widgets/role_selection_widget.dart';

class PhoneOtpAuthentication extends StatefulWidget {
  const PhoneOtpAuthentication({super.key});

  @override
  State<PhoneOtpAuthentication> createState() => _PhoneOtpAuthenticationState();
}

class _PhoneOtpAuthenticationState extends State<PhoneOtpAuthentication>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Authentication state
  AuthenticationStep _currentStep = AuthenticationStep.phoneNumber;
  String _phoneNumber = '';
  String _verificationId = '';
  String _selectedRole = '';
  Map<String, String> _profileData = {};

  // Loading states
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phoneNumber.length < 10) {
      setState(() {
        _errorMessage = 'कृपया वैध मोबाइल नंबर दर्ज करें';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (kIsWeb) {
        // Web implementation with confirmation result
        final confirmationResult = await FirebaseAuth.instance
            .signInWithPhoneNumber('+91$_phoneNumber');
        _verificationId = confirmationResult.verificationId;
      } else {
        // Mobile implementation
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91$_phoneNumber',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            _moveToNextStep();
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _errorMessage = 'OTP भेजने में त्रुटि: ${e.message}';
              _isLoading = false;
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              _isLoading = false;
            });
            _moveToNextStep();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
          timeout: const Duration(seconds: 60),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Show success animation
      _showSuccessAnimation();

      await Future.delayed(const Duration(seconds: 2));
      _moveToNextStep();
    } catch (e) {
      setState(() {
        _errorMessage = 'गलत OTP। कृपया पुनः प्रयास करें।';
        _isLoading = false;
      });
    }
  }

  void _moveToNextStep() {
    setState(() {
      switch (_currentStep) {
        case AuthenticationStep.phoneNumber:
          _currentStep = AuthenticationStep.otpVerification;
          break;
        case AuthenticationStep.otpVerification:
          _currentStep = AuthenticationStep.roleSelection;
          break;
        case AuthenticationStep.roleSelection:
          _currentStep = AuthenticationStep.profileSetup;
          break;
        case AuthenticationStep.profileSetup:
          _completeAuthentication();
          return;
      }
      _isLoading = false;
    });

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _completeAuthentication() {
    // Save user data locally
    // Navigate to home dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-dashboard',
      (route) => false,
    );
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 15.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'सत्यापन सफल!',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'प्रमाणीकरण',
        variant: AppBarVariant.primary,
        leading: _currentStep == AuthenticationStep.phoneNumber
            ? IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _showHelpDialog(),
              )
            : null,
        actions: [
          if (_currentStep != AuthenticationStep.profileSetup)
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                '/home-dashboard',
              ),
              child: Text(
                'अतिथि मोड',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: i <= _currentStep.index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Trust indicators
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security,
                    color: Theme.of(context).primaryColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'सरकारी साझेदारी',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 5.w),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PhoneNumberInputWidget(
                    phoneNumber: _phoneNumber,
                    onPhoneNumberChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                        _errorMessage = '';
                      });
                    },
                    onSendOtp: _sendOtp,
                    isLoading: _isLoading,
                  ),
                  OtpVerificationWidget(
                    phoneNumber: _phoneNumber,
                    onOtpSubmitted: _verifyOtp,
                    onResendOtp: _sendOtp,
                    isLoading: _isLoading,
                  ),
                  RoleSelectionWidget(
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() {
                        _selectedRole = role;
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _moveToNextStep();
                      });
                    },
                  ),
                  ProfileSetupWidget(
                    selectedRole: _selectedRole,
                    profileData: _profileData,
                    onProfileDataChanged: (data) {
                      setState(() {
                        _profileData = data;
                      });
                    },
                    onComplete: _completeAuthentication,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('सहायता'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• अपना 10 अंकों का मोबाइल नंबर दर्ज करें'),
            SizedBox(height: 1.h),
            Text('• OTP 30 सेकंड में आएगा'),
            SizedBox(height: 1.h),
            Text('• नेटवर्क समस्या होने पर पुनः प्रयास करें'),
            SizedBox(height: 2.h),
            Text(
              'सहायता हेल्पलाइन: 1800-XXX-XXXX',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('समझ गया'),
          ),
        ],
      ),
    );
  }
}

enum AuthenticationStep {
  phoneNumber,
  otpVerification,
  roleSelection,
  profileSetup,
}