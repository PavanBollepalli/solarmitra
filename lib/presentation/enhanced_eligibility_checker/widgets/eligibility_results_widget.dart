import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../enhanced_eligibility_checker.dart';

class EligibilityResultsWidget extends StatefulWidget {
  final double eligibilityScore;
  final List<SchemeRecommendation> recommendations;
  final VoidCallback onSaveProfile;
  final VoidCallback onFindInstallers;
  final VoidCallback onShareResults;
  final ValueChanged<String> onStartApplication;

  const EligibilityResultsWidget({
    super.key,
    required this.eligibilityScore,
    required this.recommendations,
    required this.onSaveProfile,
    required this.onFindInstallers,
    required this.onShareResults,
    required this.onStartApplication,
  });

  @override
  State<EligibilityResultsWidget> createState() =>
      _EligibilityResultsWidgetState();
}

class _EligibilityResultsWidgetState extends State<EligibilityResultsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _scoreController;
  late AnimationController _celebrationController;
  late List<AnimationController> _cardControllers;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scoreAnimation;
  late Animation<double> _celebrationAnimation;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardControllers = List.generate(
      widget.recommendations.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    _scoreAnimation =
        Tween<double>(begin: 0.0, end: widget.eligibilityScore).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    _celebrationAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _celebrationController, curve: Curves.elasticOut),
    );

    _cardAnimations = _cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
      );
    }).toList();
  }

  Future<void> _startAnimationSequence() async {
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    _scoreController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    if (widget.eligibilityScore >= 70) {
      _celebrationController.repeat(reverse: true);
      HapticFeedback.heavyImpact();
    }

    // Animate cards with stagger
    for (int i = 0; i < _cardControllers.length; i++) {
      _cardControllers[i].forward();
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scoreController.dispose();
    _celebrationController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color get _scoreColor {
    if (widget.eligibilityScore >= 80) return Colors.green;
    if (widget.eligibilityScore >= 60) return Colors.orange;
    return Colors.red;
  }

  String get _scoreMessage {
    if (widget.eligibilityScore >= 80)
      return 'उत्कृष्ट! आप कई योजनाओं के पात्र हैं';
    if (widget.eligibilityScore >= 60) return 'अच्छा! कुछ योजनाएं उपलब्ध हैं';
    return 'कुछ योजनाएं उपलब्ध हैं';
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

                  // Success header
                  _buildSuccessHeader(theme),

                  SizedBox(height: 4.h),

                  // Eligibility score section
                  _buildEligibilityScoreSection(theme),

                  SizedBox(height: 4.h),

                  // Recommendations section
                  if (widget.recommendations.isNotEmpty) ...[
                    _buildRecommendationsHeader(theme),
                    SizedBox(height: 2.h),
                    ...List.generate(widget.recommendations.length, (index) {
                      return AnimatedBuilder(
                        animation: _cardAnimations[index],
                        child: Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          child: _buildRecommendationCard(
                            widget.recommendations[index],
                            theme,
                          ),
                        ),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _cardAnimations[index].value,
                            child: child,
                          );
                        },
                      );
                    }),
                  ] else
                    _buildNoRecommendationsCard(theme),

                  SizedBox(height: 4.h),

                  // Action buttons
                  _buildActionButtons(theme),

                  SizedBox(height: 4.h),

                  // Next steps info
                  _buildNextStepsInfo(theme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessHeader(ThemeData theme) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _celebrationAnimation,
          child: Icon(
            Icons.celebration,
            color: _scoreColor,
            size: 15.w,
          ),
          builder: (context, child) {
            return Transform.scale(
              scale: _celebrationAnimation.value,
              child: child,
            );
          },
        ),
        SizedBox(height: 3.h),
        Text(
          'पात्रता परिणाम',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'आपकी जानकारी के आधार पर',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEligibilityScoreSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _scoreColor.withAlpha(26),
            _scoreColor.withAlpha(13),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: _scoreColor.withAlpha(77), width: 2),
      ),
      child: Column(
        children: [
          // Circular progress indicator
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _scoreAnimation.value / 100,
                        strokeWidth: 2.w,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_scoreAnimation.value.toInt()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: _scoreColor,
                          ),
                        ),
                        Text(
                          'पात्रता स्कोर',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            _scoreMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: _scoreColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.recommend,
          color: theme.primaryColor,
          size: 6.w,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            'आपके लिए उपयुक्त योजनाएं',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Text(
          '${widget.recommendations.length} योजनाएं',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      SchemeRecommendation recommendation, ThemeData theme) {
    final confidenceColor = recommendation.confidence >= 80
        ? Colors.green
        : recommendation.confidence >= 60
            ? Colors.orange
            : Colors.red;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with confidence badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    recommendation.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: confidenceColor,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    '${recommendation.confidence}% मैच',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Text(
              recommendation.description,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: 2.h),

            // Key metrics
            Row(
              children: [
                Expanded(
                  child: _buildMetricChip(
                    icon: Icons.percent,
                    label: '${recommendation.subsidy}% सब्सिडी',
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildMetricChip(
                    icon: Icons.savings,
                    label: '₹${recommendation.estimatedSaving ~/ 1000}K बचत',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: _buildMetricChip(
                    icon: Icons.timer,
                    label: recommendation.processingTime,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildMetricChip(
                    icon: Icons.category,
                    label: recommendation.category,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showSchemeDetails(recommendation, theme),
                    icon: Icon(Icons.info_outline, size: 4.w),
                    label: Text('विवरण देखें'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.primaryColor,
                      side: BorderSide(color: theme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onStartApplication(recommendation.id);
                    },
                    icon: Icon(Icons.launch, size: 4.w),
                    label: Text('आवेदन करें'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 4.w),
          SizedBox(width: 1.w),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRecommendationsCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'कोई योजना नहीं मिली',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'आपकी वर्तमान स्थिति के अनुसार कोई सरकारी योजना उपलब्ध नहीं है। कृपया संपर्क करें।',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          height: 6.h,
          child: ElevatedButton.icon(
            onPressed: widget.onFindInstallers,
            icon: Icon(Icons.handyman, size: 5.w),
            label: Text(
              'इंस्टॉलर ढूंढें',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onSaveProfile();
                },
                icon: Icon(Icons.bookmark, size: 4.w),
                label: Text('प्रोफाइल सेव करें'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.primaryColor,
                  side: BorderSide(color: theme.primaryColor),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  widget.onShareResults();
                },
                icon: Icon(Icons.share, size: 4.w),
                label: Text('WhatsApp शेयर'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: BorderSide(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextStepsInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade600,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'अगले कदम',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '1. चुनी गई योजना के लिए आवेदन करें\n'
            '2. आवश्यक दस्तावेज तैयार करें\n'
            '3. सत्यापित इंस्टॉलर से संपर्क करें\n'
            '4. साइट सर्वे कराएं और कोटेशन लें',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showSchemeDetails(
      SchemeRecommendation recommendation, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.h),
              width: 15.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.name,
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      recommendation.description,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    _buildDetailSection('लाभ', recommendation.benefits),
                    SizedBox(height: 3.h),
                    _buildDetailSection(
                        'पात्रता मापदंड', recommendation.eligibilityCriteria),
                    SizedBox(height: 3.h),
                    _buildDetailSection(
                        'आवश्यक दस्तावेज', recommendation.documentsRequired),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...items
            .map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: GoogleFonts.inter(fontSize: 14.sp)),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.inter(fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}