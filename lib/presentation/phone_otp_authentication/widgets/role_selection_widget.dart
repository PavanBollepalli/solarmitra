import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class RoleSelectionWidget extends StatefulWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleSelected;

  const RoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  State<RoleSelectionWidget> createState() => _RoleSelectionWidgetState();
}

class _RoleSelectionWidgetState extends State<RoleSelectionWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardAnimationControllers;
  late List<Animation<double>> _cardAnimations;

  final List<RoleData> _roles = [
    RoleData(
      id: 'farmer',
      title: 'किसान',
      subtitle: 'कृषि सिंचाई के लिए सोलर',
      description: 'फसल सिंचाई और कृषि उपकरणों के लिए सोलर समाधान',
      icon: Icons.agriculture,
      color: Colors.green,
      benefits: ['सिंचाई लागत में 80% बचत', 'सरकारी सब्सिडी', 'EMI की सुविधा'],
    ),
    RoleData(
      id: 'homeowner',
      title: 'गृहस्वामी',
      subtitle: 'घरेलू उपयोग के लिए सोलर',
      description: 'घर की बिजली की जरूरतों के लिए रूफटॉप सोलर',
      icon: Icons.home,
      color: Colors.blue,
      benefits: [
        'बिजली बिल में 90% बचत',
        'घर की वैल्यू बढ़ती है',
        'पर्यावरण सुरक्षा'
      ],
    ),
    RoleData(
      id: 'business',
      title: 'व्यापारी',
      subtitle: 'व्यापारिक उपयोग के लिए सोलर',
      description: 'दुकान, फैक्ट्री और कार्यालय के लिए सोलर समाधान',
      icon: Icons.business,
      color: Colors.orange,
      benefits: ['ऑपरेटिंग कॉस्ट कम', '25 साल की गारंटी', 'तुरंत फायदा'],
    ),
    RoleData(
      id: 'installer',
      title: 'इंस्टॉलर',
      subtitle: 'सोलर इंस्टॉलेशन व्यवसाय',
      description: 'सोलर सिस्टम इंस्टॉलेशन का व्यवसाय शुरू करें',
      icon: Icons.construction,
      color: Colors.purple,
      benefits: ['नया व्यवसाय अवसर', 'ट्रेनिंग की सुविधा', 'लाइसेंस सहायता'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationControllers = List.generate(
      _roles.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      ),
    );

    _cardAnimations = _cardAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _animationController.forward();
    for (int i = 0; i < _cardAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _cardAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleRoleSelection(String roleId) {
    HapticFeedback.mediumImpact();
    widget.onRoleSelected(roleId);
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

          // Header section
          FadeTransition(
            opacity: _animationController,
            child: Column(
              children: [
                Icon(
                  Icons.person_add,
                  size: 12.w,
                  color: theme.primaryColor,
                ),
                SizedBox(height: 2.h),
                Text(
                  'आप कौन हैं?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'सबसे उपयुक्त योजनाओं के लिए\nअपनी भूमिका चुनें',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Role cards
          ...List.generate(_roles.length, (index) {
            final role = _roles[index];
            return AnimatedBuilder(
              animation: _cardAnimations[index],
              builder: (context, child) {
                return Transform.scale(
                  scale: _cardAnimations[index].value,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 3.h),
                    child: _buildRoleCard(role, theme),
                  ),
                );
              },
            );
          }),

          SizedBox(height: 2.h),

          // Help text
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
                  Icons.lightbulb_outline,
                  color: Colors.blue.shade600,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'सही चुनाव करें',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      Text(
                        'आपकी भूमिका के अनुसार सबसे बेहतर योजनाएं दिखाई जाएंगी',
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

  Widget _buildRoleCard(RoleData role, ThemeData theme) {
    final isSelected = widget.selectedRole == role.id;

    return GestureDetector(
      onTap: () => _handleRoleSelection(role.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected ? role.color.withAlpha(26) : Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected ? role.color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? role.color.withAlpha(51)
                  : Colors.grey.withAlpha(26),
              blurRadius: isSelected ? 8 : 4,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon section
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: role.color.withAlpha(26),
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Icon(
                role.icon,
                color: role.color,
                size: 8.w,
              ),
            ),

            SizedBox(width: 4.w),

            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    role.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: role.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    role.description,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Benefits
                  ...role.benefits
                      .take(2)
                      .map((benefit) => Padding(
                            padding: EdgeInsets.only(bottom: 0.5.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: role.color,
                                  size: 4.w,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? role.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? role.color : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 3.w,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class RoleData {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> benefits;

  RoleData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.benefits,
  });
}
