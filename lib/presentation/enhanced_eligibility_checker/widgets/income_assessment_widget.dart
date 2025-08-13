import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class IncomeAssessmentWidget extends StatefulWidget {
  final String incomeRange;
  final String occupation;
  final ValueChanged<String> onIncomeRangeChanged;
  final ValueChanged<String> onOccupationChanged;
  final VoidCallback onNext;

  const IncomeAssessmentWidget({
    super.key,
    required this.incomeRange,
    required this.occupation,
    required this.onIncomeRangeChanged,
    required this.onOccupationChanged,
    required this.onNext,
  });

  @override
  State<IncomeAssessmentWidget> createState() => _IncomeAssessmentWidgetState();
}

class _IncomeAssessmentWidgetState extends State<IncomeAssessmentWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<IncomeRange> _incomeRanges = [
    IncomeRange(
      id: 'bpl',
      title: 'गरीबी रेखा के नीचे',
      subtitle: '₹0 - ₹2,00,000 प्रति वर्ष',
      description: 'BPL कार्ड धारक',
      icon: Icons.trending_down,
      color: Colors.green,
      subsidy: 90,
    ),
    IncomeRange(
      id: 'apl',
      title: 'गरीबी रेखा के ऊपर',
      subtitle: '₹2,00,000 - ₹5,00,000 प्रति वर्ष',
      description: 'APL कार्ड धारक',
      icon: Icons.trending_flat,
      color: Colors.orange,
      subsidy: 70,
    ),
    IncomeRange(
      id: 'above_apl',
      title: 'उच्च आय वर्ग',
      subtitle: '₹5,00,000+ प्रति वर्ष',
      description: 'सामान्य श्रेणी',
      icon: Icons.trending_up,
      color: Colors.blue,
      subsidy: 40,
    ),
  ];

  final List<String> _occupations = [
    'किसान',
    'व्यापारी',
    'नौकरी पेशा',
    'गृहिणी',
    'मजदूर',
    'पशुपालक',
    'रिटायर्ड',
    'अन्य',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _canProceed() {
    return widget.incomeRange.isNotEmpty && widget.occupation.isNotEmpty;
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

                  // Header with icon and description
                  _buildHeader(theme),

                  SizedBox(height: 4.h),

                  // Income range selection
                  Text(
                    'वार्षिक पारिवारिक आय चुनें',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Income range cards
                  ...List.generate(_incomeRanges.length, (index) {
                    final range = _incomeRanges[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 3.h),
                      child: _buildIncomeRangeCard(range, theme),
                    );
                  }),

                  SizedBox(height: 3.h),

                  // Occupation selection
                  Text(
                    'आपका व्यवसाय',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Occupation chips
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 2.w,
                    children: _occupations.map((occupation) {
                      final isSelected = widget.occupation == occupation;
                      return _buildOccupationChip(
                          occupation, isSelected, theme);
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Information box
                  _buildInfoBox(theme),

                  SizedBox(height: 4.h),

                  // Next button
                  SizedBox(
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
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            color: theme.primaryColor,
            size: 10.w,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'आय मूल्यांकन',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'सही योजना चुनने के लिए\nअपनी आर्थिक स्थिति बताएं',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeRangeCard(IncomeRange range, ThemeData theme) {
    final isSelected = widget.incomeRange == range.id;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onIncomeRangeChanged(range.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected ? range.color.withAlpha(26) : Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected ? range.color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? range.color.withAlpha(38)
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
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: range.color.withAlpha(26),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                range.icon,
                color: range.color,
                size: 6.w,
              ),
            ),

            SizedBox(width: 4.w),

            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    range.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    range.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: range.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    range.description,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Subsidy badge and selection indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: range.color,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    '${range.subsidy}% सब्सिडी',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 5.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? range.color : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? range.color : Colors.grey.shade300,
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
          ],
        ),
      ),
    );
  }

  Widget _buildOccupationChip(
      String occupation, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onOccupationChanged(occupation);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withAlpha(77),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          occupation,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue.shade600,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'महत्वपूर्ण जानकारी',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '• आय की जानकारी पूर्णतः गुप्त रखी जाएगी\n• सही जानकारी देने पर बेहतर योजनाएं मिलेंगी\n• आवश्यक दस्तावेजों की सूची बाद में मिलेगी',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    HapticFeedback.mediumImpact();
    widget.onNext();
  }
}

class IncomeRange {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final int subsidy;

  IncomeRange({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.subsidy,
  });
}
