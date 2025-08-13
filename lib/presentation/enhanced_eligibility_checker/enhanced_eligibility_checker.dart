import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import './widgets/eligibility_results_widget.dart';
import './widgets/family_composition_widget.dart';
import './widgets/income_assessment_widget.dart';
import './widgets/location_verification_widget.dart';
import './widgets/property_details_widget.dart';
import './widgets/step_indicator_widget.dart';

class EnhancedEligibilityChecker extends StatefulWidget {
  const EnhancedEligibilityChecker({super.key});

  @override
  State<EnhancedEligibilityChecker> createState() =>
      _EnhancedEligibilityCheckerState();
}

class _EnhancedEligibilityCheckerState extends State<EnhancedEligibilityChecker>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late List<AnimationController> _stepAnimationControllers;
  late Animation<double> _fadeAnimation;

  // Current step tracking
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Assessment data
  Map<String, dynamic> _assessmentData = {
    'income_range': '',
    'occupation': '',
    'land_ownership': '',
    'roof_area': 0,
    'electrical_connection': '',
    'location': '',
    'family_size': 1,
    'dependents': 0,
    'monthly_electricity_bill': 0,
  };

  // Loading states
  bool _isCalculating = false;
  List<SchemeRecommendation> _recommendations = [];
  double _eligibilityScore = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSavedData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _stepAnimationControllers = List.generate(
      _totalSteps,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _stepAnimationControllers[0].forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _stepAnimationControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('eligibility_assessment');
      if (savedData != null) {
        // Parse saved data if available
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveAssessmentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'eligibility_assessment', _assessmentData.toString());
    } catch (e) {
      // Handle error silently
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      _stepAnimationControllers[_currentStep].forward();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );

      // Haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );

      // Haptic feedback
      HapticFeedback.lightImpact();
    }
  }

  void _updateAssessmentData(String key, dynamic value) {
    setState(() {
      _assessmentData[key] = value;
    });
    _saveAssessmentData();
  }

  Future<void> _calculateEligibility() async {
    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation with realistic delay
    await Future.delayed(const Duration(seconds: 3));

    final recommendations = _generateRecommendations();
    final score = _calculateEligibilityScore();

    setState(() {
      _recommendations = recommendations;
      _eligibilityScore = score;
      _isCalculating = false;
    });

    _nextStep();
  }

  List<SchemeRecommendation> _generateRecommendations() {
    final recommendations = <SchemeRecommendation>[];

    // Mock recommendations based on assessment data
    if (_assessmentData['income_range'] == 'bpl') {
      recommendations.add(SchemeRecommendation(
        id: 'pm_kusum_a',
        name: 'PM-KUSUM Component A',
        description:
            'सोलर पंप सेट योजना - गरीबी रेखा के नीचे के किसानों के लिए',
        subsidy: 90,
        maxCapacity: 10,
        estimatedSaving: 50000,
        processingTime: '2-3 महीने',
        confidence: 95,
        category: 'Central Government',
        benefits: [
          '90% सब्सिडी',
          'मुफ्त इंस्टॉलेशन',
          '5 साल AMC',
          '25 साल वारंटी'
        ],
        eligibilityCriteria: [
          'BPL कार्ड धारक',
          'कृषि भूमि का मालिक',
          'बिजली कनेक्शन'
        ],
        documentsRequired: [
          'आधार कार्ड',
          'BPL कार्ड',
          'भूमि दस्तावेज',
          'बैंक पासबुक'
        ],
      ));
    }

    if (_assessmentData['roof_area'] >= 100) {
      recommendations.add(SchemeRecommendation(
        id: 'solar_rooftop',
        name: 'Solar Rooftop Subsidy Scheme',
        description: 'रूफटॉप सोलर योजना - घर और व्यापारिक उपयोग के लिए',
        subsidy: 40,
        maxCapacity: 10,
        estimatedSaving: 80000,
        processingTime: '1-2 महीने',
        confidence: 88,
        category: 'Central Government',
        benefits: [
          '40% केंद्रीय सब्सिडी',
          'नेट मीटरिंग',
          '25 साल वारंटी',
          'EMI की सुविधा'
        ],
        eligibilityCriteria: [
          'अपनी छत',
          'बिजली कनेक्शन',
          'पर्याप्त छत क्षेत्र'
        ],
        documentsRequired: [
          'आधार कार्ड',
          'बिजली बिल',
          'घर के कागजात',
          'बैंक स्टेटमेंट'
        ],
      ));
    }

    // Add more recommendations based on different criteria
    return recommendations
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
  }

  double _calculateEligibilityScore() {
    double score = 0.0;

    // Income scoring
    switch (_assessmentData['income_range']) {
      case 'bpl':
        score += 40;
        break;
      case 'apl':
        score += 30;
        break;
      case 'above_apl':
        score += 20;
        break;
    }

    // Property scoring
    if (_assessmentData['roof_area'] >= 100)
      score += 25;
    else if (_assessmentData['roof_area'] >= 50)
      score += 20;
    else if (_assessmentData['roof_area'] >= 25) score += 15;

    // Electrical connection scoring
    if (_assessmentData['electrical_connection'] == 'yes') score += 15;

    // Location scoring (mock)
    score += 10;

    // Family composition scoring
    if (_assessmentData['family_size'] >= 4) score += 10;

    return score.clamp(0.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'पात्रता जांच',
        variant: AppBarVariant.primary,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Step indicator
            Container(
              padding: EdgeInsets.all(4.w),
              child: StepIndicatorWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                stepTitles: const [
                  'आय मूल्यांकन',
                  'संपत्ति विवरण',
                  'स्थान सत्यापन',
                  'परिवारिक संरचना',
                  'परिणाम',
                ],
              ),
            ),

            // Progress bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 1.h,
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Income Assessment
                  FadeTransition(
                    opacity: _stepAnimationControllers[0],
                    child: IncomeAssessmentWidget(
                      incomeRange: _assessmentData['income_range'] ?? '',
                      occupation: _assessmentData['occupation'] ?? '',
                      onIncomeRangeChanged: (value) =>
                          _updateAssessmentData('income_range', value),
                      onOccupationChanged: (value) =>
                          _updateAssessmentData('occupation', value),
                      onNext: _nextStep,
                    ),
                  ),

                  // Step 2: Property Details
                  _currentStep >= 1
                      ? FadeTransition(
                          opacity: _stepAnimationControllers[1],
                          child: PropertyDetailsWidget(
                            landOwnership:
                                _assessmentData['land_ownership'] ?? '',
                            roofArea:
                                _assessmentData['roof_area']?.toDouble() ?? 0.0,
                            electricalConnection:
                                _assessmentData['electrical_connection'] ?? '',
                            monthlyBill:
                                _assessmentData['monthly_electricity_bill']
                                        ?.toDouble() ??
                                    0.0,
                            onLandOwnershipChanged: (value) =>
                                _updateAssessmentData('land_ownership', value),
                            onRoofAreaChanged: (value) =>
                                _updateAssessmentData('roof_area', value),
                            onElectricalConnectionChanged: (value) =>
                                _updateAssessmentData(
                                    'electrical_connection', value),
                            onMonthlyBillChanged: (value) =>
                                _updateAssessmentData(
                                    'monthly_electricity_bill', value),
                            onNext: _nextStep,
                            onPrevious: _previousStep,
                          ),
                        )
                      : const SizedBox(),

                  // Step 3: Location Verification
                  _currentStep >= 2
                      ? FadeTransition(
                          opacity: _stepAnimationControllers[2],
                          child: LocationVerificationWidget(
                            location: _assessmentData['location'] ?? '',
                            onLocationChanged: (value) =>
                                _updateAssessmentData('location', value),
                            onNext: _nextStep,
                            onPrevious: _previousStep,
                          ),
                        )
                      : const SizedBox(),

                  // Step 4: Family Composition
                  _currentStep >= 3
                      ? FadeTransition(
                          opacity: _stepAnimationControllers[3],
                          child: FamilyCompositionWidget(
                            familySize: _assessmentData['family_size'] ?? 1,
                            dependents: _assessmentData['dependents'] ?? 0,
                            onFamilySizeChanged: (value) =>
                                _updateAssessmentData('family_size', value),
                            onDependentsChanged: (value) =>
                                _updateAssessmentData('dependents', value),
                            onNext: _calculateEligibility,
                            onPrevious: _previousStep,
                            isCalculating: _isCalculating,
                          ),
                        )
                      : const SizedBox(),

                  // Step 5: Results
                  _currentStep >= 4
                      ? FadeTransition(
                          opacity: _stepAnimationControllers[4],
                          child: EligibilityResultsWidget(
                            eligibilityScore: _eligibilityScore,
                            recommendations: _recommendations,
                            onSaveProfile: _saveProfileForFuture,
                            onFindInstallers: _navigateToInstallerMarketplace,
                            onShareResults: _shareResults,
                            onStartApplication: _startApplication,
                          ),
                        )
                      : const SizedBox(),
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
        title: Row(
          children: [
            Icon(Icons.help, color: Theme.of(context).primaryColor),
            SizedBox(width: 2.w),
            Text('सहायता'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                  '1. आय मूल्यांकन', 'अपनी वार्षिक आय और व्यवसाय चुनें'),
              _buildHelpItem('2. संपत्ति विवरण',
                  'छत का क्षेत्रफल और बिजली कनेक्शन की जानकारी दें'),
              _buildHelpItem(
                  '3. स्थान सत्यापन', 'सटीक स्थान से बेहतर योजनाएं मिलेंगी'),
              _buildHelpItem(
                  '4. परिवारिक संरचना', 'परिवार के सदस्यों की संख्या दें'),
              _buildHelpItem('5. परिणाम', 'आपके लिए उपयुक्त योजनाओं की सूची'),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: Colors.blue, size: 5.w),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'हेल्पलाइन सहायता',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '1800-XXX-XXXX (टोल फ्री)',
                            style: GoogleFonts.inter(color: Colors.blue),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('समझ गया'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfileForFuture() {
    _saveAssessmentData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('आपकी प्रोफाइल सेव कर दी गई है'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToInstallerMarketplace() {
    Navigator.pushNamed(context, '/installer-marketplace');
  }

  void _shareResults() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('परिणाम WhatsApp पर साझा किए गए'),
        action: SnackBarAction(
          label: 'देखें',
          onPressed: () {},
        ),
      ),
    );
  }

  void _startApplication(String schemeId) {
    Navigator.pushNamed(
      context,
      '/application-form',
      arguments: schemeId,
    );
  }
}

class SchemeRecommendation {
  final String id;
  final String name;
  final String description;
  final int subsidy;
  final int maxCapacity;
  final int estimatedSaving;
  final String processingTime;
  final int confidence;
  final String category;
  final List<String> benefits;
  final List<String> eligibilityCriteria;
  final List<String> documentsRequired;

  SchemeRecommendation({
    required this.id,
    required this.name,
    required this.description,
    required this.subsidy,
    required this.maxCapacity,
    required this.estimatedSaving,
    required this.processingTime,
    required this.confidence,
    required this.category,
    required this.benefits,
    required this.eligibilityCriteria,
    required this.documentsRequired,
  });
}