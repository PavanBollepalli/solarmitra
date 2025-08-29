import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/application_form_content.dart';
import './widgets/document_upload_section.dart';
import './widgets/form_progress_indicator.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  
  int _currentStep = 0;
  final int _totalSteps = 4;
  
  String? _schemeId;
  
  // Form data
  final Map<String, dynamic> _formData = {
    'personalDetails': {},
    'addressDetails': {},
    'technicalDetails': {},
    'documents': {},
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSchemeDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get scheme ID from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _schemeId = args;
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _loadSchemeDetails() {
    // Mock loading scheme details based on scheme ID
    // In real app, this would fetch from API
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'आवेदन प्रपत्र',
        showBackArrow: true,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Progress indicator
              FormProgressIndicator(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
                stepTitles: const [
                  'व्यक्तिगत विवरण',
                  'पता विवरण',
                  'तकनीकी विवरण',
                  'दस्तावेज़',
                ],
              ),

              // Form content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _totalSteps,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return ApplicationFormContent(
                          stepType: FormStepType.personal,
                          formData: _formData['personalDetails'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['personalDetails'] = data;
                            });
                          },
                        );
                      case 1:
                        return ApplicationFormContent(
                          stepType: FormStepType.address,
                          formData: _formData['addressDetails'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['addressDetails'] = data;
                            });
                          },
                        );
                      case 2:
                        return ApplicationFormContent(
                          stepType: FormStepType.technical,
                          formData: _formData['technicalDetails'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['technicalDetails'] = data;
                            });
                          },
                        );
                      case 3:
                        return DocumentUploadSection(
                          formData: _formData['documents'],
                          onDataChanged: (data) {
                            setState(() {
                              _formData['documents'] = data;
                            });
                          },
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),

              // Navigation buttons
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: Text('पिछला'),
                        ),
                      ),
                    if (_currentStep > 0) SizedBox(width: 4.w),
                    Expanded(
                      flex: _currentStep == 0 ? 1 : 1,
                      child: ElevatedButton(
                        onPressed: _currentStep < _totalSteps - 1
                            ? _nextStep
                            : _submitApplication,
                        child: Text(
                          _currentStep < _totalSteps - 1
                              ? 'अगला'
                              : 'आवेदन जमा करें',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool _validateCurrentStep() {
    // Add validation logic for each step
    switch (_currentStep) {
      case 0:
        return _validatePersonalDetails();
      case 1:
        return _validateAddressDetails();
      case 2:
        return _validateTechnicalDetails();
      case 3:
        return _validateDocuments();
      default:
        return true;
    }
  }

  bool _validatePersonalDetails() {
    final data = _formData['personalDetails'] as Map<String, dynamic>;
    return data['name']?.isNotEmpty == true &&
           data['phone']?.isNotEmpty == true &&
           data['email']?.isNotEmpty == true;
  }

  bool _validateAddressDetails() {
    final data = _formData['addressDetails'] as Map<String, dynamic>;
    return data['address']?.isNotEmpty == true &&
           data['city']?.isNotEmpty == true &&
           data['state']?.isNotEmpty == true;
  }

  bool _validateTechnicalDetails() {
    final data = _formData['technicalDetails'] as Map<String, dynamic>;
    return data['roofArea']?.isNotEmpty == true &&
           data['electricityConnection']?.isNotEmpty == true;
  }

  bool _validateDocuments() {
    final data = _formData['documents'] as Map<String, dynamic>;
    return data.isNotEmpty;
  }

  void _submitApplication() {
    if (_validateCurrentStep()) {
      HapticFeedback.mediumImpact();
      _showSubmissionDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('कृपया सभी आवश्यक दस्तावेज़ अपलोड करें'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('आवेदन सफल'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('आपका आवेदन सफलतापूर्वक जमा हो गया है।'),
            SizedBox(height: 2.h),
            Text(
              'Application ID: APL${DateTime.now().millisecondsSinceEpoch}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 2.h),
            Text('आप 2-3 कार्यदिवसों में स्टेटस अपडेट प्राप्त करेंगे।'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home-dashboard',
                (route) => false,
              );
            },
            child: Text('होम पर जाएं'),
          ),
        ],
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
            Text('आवेदन प्रक्रिया:'),
            SizedBox(height: 1.h),
            Text('1. सभी व्यक्तिगत विवरण भरें'),
            Text('2. सही पता दर्ज करें'),
            Text('3. तकनीकी जानकारी प्रदान करें'),
            Text('4. आवश्यक दस्तावेज़ अपलोड करें'),
            SizedBox(height: 2.h),
            Text(
              'सहायता के लिए: 1800-XXX-XXXX',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
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

enum FormStepType {
  personal,
  address,
  technical,
  documents,
}