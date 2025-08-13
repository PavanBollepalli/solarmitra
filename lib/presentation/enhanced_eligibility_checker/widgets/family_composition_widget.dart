import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class FamilyCompositionWidget extends StatefulWidget {
  final int familySize;
  final int dependents;
  final ValueChanged<int> onFamilySizeChanged;
  final ValueChanged<int> onDependentsChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isCalculating;

  const FamilyCompositionWidget({
    super.key,
    required this.familySize,
    required this.dependents,
    required this.onFamilySizeChanged,
    required this.onDependentsChanged,
    required this.onNext,
    required this.onPrevious,
    required this.isCalculating,
  });

  @override
  State<FamilyCompositionWidget> createState() =>
      _FamilyCompositionWidgetState();
}

class _FamilyCompositionWidgetState extends State<FamilyCompositionWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _counterController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<FamilyMember> _familyMembers = [
    FamilyMember(
      type: 'पुरुष',
      icon: Icons.man,
      color: Colors.blue,
      count: 1,
    ),
    FamilyMember(
      type: 'महिला',
      icon: Icons.woman,
      color: Colors.pink,
      count: 1,
    ),
    FamilyMember(
      type: 'बच्चे',
      icon: Icons.child_care,
      color: Colors.orange,
      count: 0,
    ),
    FamilyMember(
      type: 'बुजुर्ग',
      icon: Icons.elderly,
      color: Colors.grey,
      count: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFamilyData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _counterController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
  }

  void _initializeFamilyData() {
    // Initialize family members based on current data
    int remainingFamily = widget.familySize;

    if (remainingFamily > 0) {
      _familyMembers[0].count = 1; // At least one male
      remainingFamily--;
    }

    if (remainingFamily > 0) {
      _familyMembers[1].count = 1; // At least one female
      remainingFamily--;
    }

    // Distribute remaining members
    _familyMembers[2].count = widget.dependents.clamp(0, remainingFamily);
    remainingFamily -= _familyMembers[2].count;

    if (remainingFamily > 0) {
      _familyMembers[3].count = remainingFamily;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  void _updateFamilyMember(int index, int newCount) {
    setState(() {
      _familyMembers[index].count = newCount.clamp(0, 20);
    });

    _counterController.reset();
    _counterController.forward();

    _updateTotals();
    HapticFeedback.lightImpact();
  }

  void _updateTotals() {
    int totalFamily =
        _familyMembers.fold(0, (sum, member) => sum + member.count);
    int totalDependents = _familyMembers[2].count + _familyMembers[3].count;

    widget.onFamilySizeChanged(totalFamily.clamp(1, 50));
    widget.onDependentsChanged(totalDependents.clamp(0, 20));
  }

  int get _totalPowerConsumption {
    // Mock calculation based on family composition
    int totalConsumption = 0;

    // Adults: 50-80 units per person per month
    totalConsumption +=
        (_familyMembers[0].count + _familyMembers[1].count) * 60;

    // Children: 30-50 units per child per month
    totalConsumption += _familyMembers[2].count * 40;

    // Elderly: 70-100 units per person per month (more home time)
    totalConsumption += _familyMembers[3].count * 80;

    return totalConsumption;
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

                  // Family composition section
                  _buildFamilyCompositionSection(theme),

                  SizedBox(height: 4.h),

                  // Summary cards
                  _buildSummaryCards(theme),

                  SizedBox(height: 4.h),

                  // Power consumption estimate
                  _buildPowerConsumptionCard(theme),

                  SizedBox(height: 4.h),

                  // Information note
                  _buildInformationNote(theme),

                  SizedBox(height: 4.h),

                  // Navigation buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 6.h,
                          child: OutlinedButton(
                            onPressed:
                                widget.isCalculating ? null : widget.onPrevious,
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
                            onPressed:
                                widget.isCalculating ? null : _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                              elevation: widget.isCalculating ? 0 : 2,
                            ),
                            child: widget.isCalculating
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                        height: 5.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        'गणना हो रही है...',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'परिणाम देखें',
                                        style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(Icons.calculate, size: 5.w),
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
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Icon(
            Icons.family_restroom,
            color: theme.primaryColor,
            size: 10.w,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'परिवारिक संरचना',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'परिवार के सदस्यों की संख्या बताएं\nसटीक बिजली की जरूरत जानने के लिए',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyCompositionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'परिवार के सदस्य',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 3.h),
        ...List.generate(_familyMembers.length, (index) {
          final member = _familyMembers[index];
          return Container(
            margin: EdgeInsets.only(bottom: 3.h),
            child: _buildFamilyMemberCard(member, index, theme),
          );
        }),
      ],
    );
  }

  Widget _buildFamilyMemberCard(
      FamilyMember member, int index, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: member.color.withAlpha(13),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: member.color.withAlpha(51)),
      ),
      child: Row(
        children: [
          // Icon section
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: member.color.withAlpha(26),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Icon(
              member.icon,
              color: member.color,
              size: 8.w,
            ),
          ),

          SizedBox(width: 4.w),

          // Label
          Expanded(
            child: Text(
              member.type,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          // Counter controls
          Row(
            children: [
              _buildCounterButton(
                icon: Icons.remove,
                color: member.color,
                onPressed: member.count > 0
                    ? () => _updateFamilyMember(index, member.count - 1)
                    : null,
              ),
              SizedBox(width: 3.w),
              AnimatedBuilder(
                animation: _scaleAnimation,
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: member.color.withAlpha(26),
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(color: member.color.withAlpha(77)),
                  ),
                  child: Text(
                    '${member.count}',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: member.color,
                    ),
                  ),
                ),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  );
                },
              ),
              SizedBox(width: 3.w),
              _buildCounterButton(
                icon: Icons.add,
                color: member.color,
                onPressed: member.count < 20
                    ? () => _updateFamilyMember(index, member.count + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 10.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? color : Colors.grey.shade200,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          padding: EdgeInsets.zero,
          elevation: onPressed != null ? 2 : 0,
        ),
        child: Icon(
          icon,
          size: 5.w,
          color: onPressed != null ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'कुल सदस्य',
            value: '${widget.familySize}',
            icon: Icons.people,
            color: Colors.blue,
            theme: theme,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'आश्रित सदस्य',
            value: '${widget.dependents}',
            icon: Icons.child_care,
            color: Colors.orange,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerConsumptionCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.primaryColor.withAlpha(26),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: theme.primaryColor.withAlpha(77)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.electric_bolt,
                color: theme.primaryColor,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'अनुमानित मासिक विद्युत खपत',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '${_totalPowerConsumption} यूनिट/महीना',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: theme.primaryColor,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'परिवारिक संरचना के आधार पर',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationNote(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.green.shade600,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'जानकारी',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '• यह अनुमान औसत खपत के आधार पर है\n• सटीक गणना के लिए पिछले बिजली बिल देखें\n• सोलर सिस्टम आपके बिल को 80-90% तक कम कर सकता है',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.green.shade700,
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

class FamilyMember {
  final String type;
  final IconData icon;
  final Color color;
  int count;

  FamilyMember({
    required this.type,
    required this.icon,
    required this.color,
    required this.count,
  });
}
