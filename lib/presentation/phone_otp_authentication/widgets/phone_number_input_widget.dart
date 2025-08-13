import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PhoneNumberInputWidget extends StatefulWidget {
  final String phoneNumber;
  final ValueChanged<String> onPhoneNumberChanged;
  final VoidCallback onSendOtp;
  final bool isLoading;

  const PhoneNumberInputWidget({
    super.key,
    required this.phoneNumber,
    required this.onPhoneNumberChanged,
    required this.onSendOtp,
    this.isLoading = false,
  });

  @override
  State<PhoneNumberInputWidget> createState() => _PhoneNumberInputWidgetState();
}

class _PhoneNumberInputWidgetState extends State<PhoneNumberInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.phoneNumber;
    _controller.addListener(() {
      widget.onPhoneNumberChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 4.h),

          // App logo and title
          Center(
            child: Column(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.white,
                    size: 10.w,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Solar Mitra',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'आपका सौर ऊर्जा साथी',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // Phone number input section
          Text(
            'मोबाइल नंबर दर्ज करें',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'हम आपको OTP भेजेंगे',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 3.h),

          // Phone number input field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? theme.primaryColor
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Country code section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '🇮🇳',
                        style: TextStyle(fontSize: 5.w),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '+91',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Separator
                Container(
                  width: 1,
                  height: 6.h,
                  color: Colors.grey.shade300,
                ),

                // Phone number input
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: '98765 43210',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey.shade400,
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.h),

          // Format helper text
          Text(
            'उदाहरण: 9876543210',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),
          ),

          SizedBox(height: 4.h),

          // Send OTP button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: widget.isLoading || _controller.text.length < 10
                  ? null
                  : widget.onSendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'OTP भेजें',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 3.h),

          // Terms and privacy
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
              children: [
                const TextSpan(text: 'आगे बढ़कर आप हमारी '),
                TextSpan(
                  text: 'शर्तें',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: ' और '),
                TextSpan(
                  text: 'गोपनीयता नीति',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: ' से सहमत हैं।'),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // Accessibility features info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.accessibility,
                  color: Colors.blue.shade600,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'सुविधा सुलभ ऐप',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      Text(
                        'आवाज़ सहायता और बड़े टेक्स्ट के लिए सेटिंग्स देखें',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.blue.shade600,
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
    );
  }
}
