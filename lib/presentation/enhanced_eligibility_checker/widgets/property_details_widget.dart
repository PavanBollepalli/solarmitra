import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PropertyDetailsWidget extends StatefulWidget {
  final String landOwnership;
  final double roofArea;
  final String electricalConnection;
  final double monthlyBill;
  final ValueChanged<String> onLandOwnershipChanged;
  final ValueChanged<double> onRoofAreaChanged;
  final ValueChanged<String> onElectricalConnectionChanged;
  final ValueChanged<double> onMonthlyBillChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PropertyDetailsWidget({
    super.key,
    required this.landOwnership,
    required this.roofArea,
    required this.electricalConnection,
    required this.monthlyBill,
    required this.onLandOwnershipChanged,
    required this.onRoofAreaChanged,
    required this.onElectricalConnectionChanged,
    required this.onMonthlyBillChanged,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<PropertyDetailsWidget> createState() => _PropertyDetailsWidgetState();
}

class _PropertyDetailsWidgetState extends State<PropertyDetailsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _billController = TextEditingController();
  bool _showRoofAreaHelper = false;

  final List<OwnershipType> _ownershipTypes = [
    OwnershipType(
      id: 'own',
      title: 'अपना मालिक',
      description: 'मैं इस संपत्ति का मालिक हूं',
      icon: Icons.home,
      color: Colors.green,
    ),
    OwnershipType(
      id: 'rent',
      title: 'किराए पर',
      description: 'मैं किराए पर रहता हूं',
      icon: Icons.key,
      color: Colors.orange,
    ),
    OwnershipType(
      id: 'family',
      title: 'पारिवारिक संपत्ति',
      description: 'यह पारिवारिक संपत्ति है',
      icon: Icons.family_restroom,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

    _billController.text =
        widget.monthlyBill > 0 ? widget.monthlyBill.toString() : '';
    _billController.addListener(() {
      final value = double.tryParse(_billController.text) ?? 0.0;
      widget.onMonthlyBillChanged(value);
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _billController.dispose();
    super.dispose();
  }

  bool _canProceed() {
    return widget.landOwnership.isNotEmpty &&
        widget.roofArea > 0 &&
        widget.electricalConnection.isNotEmpty;
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

                  // Land ownership section
                  _buildOwnershipSection(theme),

                  SizedBox(height: 4.h),

                  // Roof area section
                  _buildRoofAreaSection(theme),

                  SizedBox(height: 4.h),

                  // Electrical connection section
                  _buildElectricalConnectionSection(theme),

                  SizedBox(height: 4.h),

                  // Monthly electricity bill section
                  _buildMonthlyBillSection(theme),

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
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Icon(
            Icons.home_work,
            color: theme.primaryColor,
            size: 10.w,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'संपत्ति विवरण',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'अपनी संपत्ति की जानकारी दें\nसही योजना चुनने के लिए',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildOwnershipSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'भूमि/संपत्ति का स्वामित्व',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...List.generate(_ownershipTypes.length, (index) {
          final ownership = _ownershipTypes[index];
          final isSelected = widget.landOwnership == ownership.id;

          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onLandOwnershipChanged(ownership.id);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      isSelected ? ownership.color.withAlpha(26) : Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: isSelected ? ownership.color : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: ownership.color.withAlpha(51),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Icon(
                        ownership.icon,
                        color: ownership.color,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ownership.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            ownership.description,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 5.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isSelected ? ownership.color : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? ownership.color
                              : Colors.grey.shade300,
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
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRoofAreaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'छत का क्षेत्रफल (वर्ग फुट)',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showRoofAreaHelper = !_showRoofAreaHelper;
                });
              },
              child: Icon(
                Icons.help_outline,
                color: theme.primaryColor,
                size: 5.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),

        // Roof area slider
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '0 sq ft',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      '${widget.roofArea.toInt()} sq ft',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '2000 sq ft',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.primaryColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: theme.primaryColor,
                  overlayColor: theme.primaryColor.withAlpha(51),
                  trackHeight: 1.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
                ),
                child: Slider(
                  value: widget.roofArea.clamp(0.0, 2000.0),
                  max: 2000.0,
                  divisions: 40,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    widget.onRoofAreaChanged(value);
                  },
                ),
              ),
            ],
          ),
        ),

        // Roof area helper
        if (_showRoofAreaHelper) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'छत का क्षेत्रफल कैसे नापें?',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '• लंबाई × चौड़ाई = क्षेत्रफल\n• उदाहरण: 20 फुट × 15 फुट = 300 वर्ग फुट\n• केवल खुला हिस्सा गिनें (टंकी, सीढ़ी छोड़कर)',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildElectricalConnectionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'क्या बिजली का कनेक्शन है?',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildConnectionOption(
                  'yes', 'हां', Icons.power, Colors.green, theme),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildConnectionOption(
                  'no', 'नहीं', Icons.power_off, Colors.red, theme),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectionOption(
      String value, String label, IconData icon, Color color, ThemeData theme) {
    final isSelected = widget.electricalConnection == value;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onElectricalConnectionChanged(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(26) : Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade400,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBillSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'मासिक बिजली बिल (₹)',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _billController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: GoogleFonts.inter(fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: '0',
            prefixIcon: Icon(Icons.currency_rupee),
            suffixText: 'प्रति महीने',
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
        SizedBox(height: 1.h),
        Text(
          'औसत बिल राशि डालें (वैकल्पिक)',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    HapticFeedback.mediumImpact();
    widget.onNext();
  }
}

class OwnershipType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OwnershipType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
