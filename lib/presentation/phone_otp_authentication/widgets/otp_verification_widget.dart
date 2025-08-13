import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

class OtpVerificationWidget extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<String> onOtpSubmitted;
  final VoidCallback onResendOtp;
  final bool isLoading;

  const OtpVerificationWidget({
    super.key,
    required this.phoneNumber,
    required this.onOtpSubmitted,
    required this.onResendOtp,
    this.isLoading = false,
  });

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget>
    with TickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  Timer? _timer;
  int _resendCountdown = 60;
  bool _canResend = false;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
            timer.cancel();
          }
        });
      }
    });
  }

  void _handleOtpChange(String otp) {
    setState(() {
      _currentOtp = otp;
    });

    if (otp.length == 6) {
      // Trigger animation
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      // Haptic feedback
      HapticFeedback.lightImpact();

      // Auto submit after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onOtpSubmitted(otp);
      });
    }
  }

  void _handleResendOtp() {
    if (_canResend && !widget.isLoading) {
      widget.onResendOtp();
      _startResendTimer();

      // Clear current OTP
      _otpController.clear();
      setState(() {
        _currentOtp = '';
      });

      // Show feedback
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP पुनः भेजा गया'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 6.h),

          // OTP icon with animation
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Icon(
                  Icons.sms,
                  color: theme.primaryColor,
                  size: 10.w,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title and subtitle
          Text(
            'OTP सत्यापन',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
              children: [
                const TextSpan(text: 'हमने '),
                TextSpan(
                  text: '+91 ${widget.phoneNumber}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ' पर\n6 अंकों का OTP भेजा है'),
              ],
            ),
          ),

          SizedBox(height: 5.h),

          // OTP input field
          PinCodeTextField(
            appContext: context,
            controller: _otpController,
            length: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            animationType: AnimationType.scale,
            animationDuration: const Duration(milliseconds: 200),
            enableActiveFill: true,
            cursorColor: theme.primaryColor,
            textStyle: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(2.w),
              fieldHeight: 12.w,
              fieldWidth: 12.w,
              borderWidth: 2,
              activeFillColor: theme.primaryColor.withAlpha(26),
              inactiveFillColor: Colors.grey.shade50,
              selectedFillColor: theme.primaryColor.withAlpha(38),
              activeColor: theme.primaryColor,
              inactiveColor: Colors.grey.shade300,
              selectedColor: theme.primaryColor,
              disabledColor: Colors.grey.shade200,
            ),
            onChanged: _handleOtpChange,
            beforeTextPaste: (text) {
              // Allow pasting only if it's 6 digits
              return text?.length == 6 && int.tryParse(text!) != null;
            },
            hapticFeedbackTypes: HapticFeedbackTypes.light,
            useHapticFeedback: true,
          ),

          SizedBox(height: 1.h),

          // OTP progress indicator
          if (_currentOtp.isNotEmpty)
            Center(
              child: Text(
                '${_currentOtp.length}/6',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: _currentOtp.length == 6
                      ? Colors.green
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          SizedBox(height: 4.h),

          // Resend OTP section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OTP नहीं मिला? ',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              if (_canResend)
                GestureDetector(
                  onTap: _handleResendOtp,
                  child: Text(
                    'पुनः भेजें',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  '${_resendCountdown}s में पुनः भेजें',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),

          SizedBox(height: 6.h),

          // Loading indicator
          if (widget.isLoading)
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'सत्यापित हो रहा है...',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 4.h),

          // Help section
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade600,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'समस्या निवारण',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• OTP आने में 2 मिनट तक लग सकते हैं\n• स्पैम फोल्डर भी चेक करें\n• नेटवर्क कनेक्शन जांचें',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Change phone number option
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'फ़ोन नंबर बदलें',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
