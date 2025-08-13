import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/audio_player_widget.dart';
import './widgets/scheme_action_buttons.dart';
import './widgets/scheme_hero_section.dart';
import './widgets/scheme_tab_content.dart';

class SchemeDetails extends StatefulWidget {
  const SchemeDetails({super.key});

  @override
  State<SchemeDetails> createState() => _SchemeDetailsState();
}

class _SchemeDetailsState extends State<SchemeDetails> {
  late Map<String, dynamic> _schemeData;
  late Map<String, dynamic> _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchemeData();
  }

  void _loadSchemeData() {
    // Mock scheme data - in real app, this would come from API or route arguments
    _schemeData = {
      "id": "pm-surya-ghar-2024",
      "name": "PM Surya Ghar: Muft Bijli Yojana",
      "authority": "Central",
      "bannerImage":
          "https://images.pexels.com/photos/9875414/pexels-photo-9875414.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "subsidyAmount": "78,000",
      "coveragePercentage": "40",
      "deadline": "2024-12-31",
      "description":
          """The PM Surya Ghar: Muft Bijli Yojana is a flagship scheme by the Government of India to promote rooftop solar installations. Under this scheme, eligible households can get up to 40% subsidy on solar panel installation costs. The scheme aims to reduce electricity bills and promote clean energy adoption across rural and urban areas. Beneficiaries can save up to 90% on their monthly electricity bills while contributing to environmental sustainability.""",
      "eligibilityCriteria": [
        "Annual household income below ₹6,00,000",
        "Own residential property with valid documents",
        "Minimum roof area of 100 sq ft",
        "Valid electricity connection",
        "No previous solar subsidy availed"
      ],
      "requiredDocuments": [
        "Aadhaar Card",
        "Electricity Bill (last 3 months)",
        "Property ownership documents",
        "Income certificate",
        "Bank account details",
        "Roof photograph"
      ],
      "benefits": [
        "Up to ₹78,000 subsidy",
        "40% cost coverage",
        "25-year warranty",
        "Net metering facility",
        "Reduced electricity bills",
        "Environmental benefits"
      ],
      "applicationProcess": [
        "Document verification",
        "Eligibility assessment",
        "Site survey",
        "Application submission",
        "Approval and installation"
      ]
    };

    // Mock user profile data
    _userProfile = {
      "annualIncome": "250000",
      "propertyOwnership": "Yes",
      "roofArea": "250",
      "hasElectricityConnection": "Yes",
      "previousSubsidy": "No",
      "location": "Maharashtra",
      "electricityBill": "2500"
    };

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App bar with hero section
              SliverAppBar(
                expandedHeight: 35.h,
                pinned: true,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  // Audio player button
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: AudioPlayerWidget(
                      text: _schemeData['name'] as String,
                      language: 'hi',
                    ),
                  ),
                  // Share button
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _shareScheme,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: SchemeHeroSection(
                    schemeData: _schemeData,
                  ),
                ),
              ),

              // Tab content
              SliverFillRemaining(
                child: SchemeTabContent(
                  schemeData: _schemeData,
                  userProfile: _userProfile,
                ),
              ),
            ],
          ),

          // Sticky action buttons at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SchemeActionButtons(
              schemeData: _schemeData,
              onEligibilityCheck: _checkEligibility,
              onDownloadPDF: _downloadPDFGuide,
              onShareWhatsApp: _shareOnWhatsApp,
              onSetReminder: _setApplicationReminder,
            ),
          ),
        ],
      ),
    );
  }

  void _shareScheme() {
    final schemeName = _schemeData['name'] as String;
    final subsidyAmount = _schemeData['subsidyAmount'] as String;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing $schemeName scheme details...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _checkEligibility() {
    // Navigate to detailed eligibility assessment
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'fact_check',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Eligibility Check'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Based on your profile:'),
            SizedBox(height: 2.h),
            _buildEligibilityResult('Annual Income', '✓ Eligible'),
            _buildEligibilityResult('Property Ownership', '✓ Eligible'),
            _buildEligibilityResult('Roof Area', '✓ Eligible'),
            _buildEligibilityResult('Electricity Connection', '✓ Eligible'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.green,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'You are eligible for this scheme!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startApplication();
            },
            child: Text('Start Application'),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityResult(String criteria, String result) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(criteria),
          Text(
            result,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPDFGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'download',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Download Guide'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select language for PDF guide:'),
            SizedBox(height: 2.h),
            ...['Hindi', 'English', 'Marathi', 'Telugu']
                .map(
                  (language) => ListTile(
                    title: Text(language),
                    leading: Radio<String>(
                      value: language,
                      groupValue: 'Hindi',
                      onChanged: (value) {},
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _generatePDF(language);
                    },
                  ),
                )
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _generatePDF(String language) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating PDF guide in $language...'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  void _shareOnWhatsApp() {
    final schemeName = _schemeData['name'] as String;
    final subsidyAmount = _schemeData['subsidyAmount'] as String;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: Colors.green,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Share on WhatsApp'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share scheme details:'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🌞 $schemeName\n\n💰 Subsidy: ₹$subsidyAmount\n📱 Apply through SolarMitra app\n\n#SolarEnergy #GovernmentScheme',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening WhatsApp...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 16,
            ),
            label: Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _setApplicationReminder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Set Reminder'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('When would you like to be reminded?'),
            SizedBox(height: 2.h),
            ...['Tomorrow', 'In 3 days', 'In 1 week', 'Custom']
                .map(
                  (option) => ListTile(
                    title: Text(option),
                    leading: CustomIconWidget(
                      iconName: 'notifications',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _scheduleReminder(option);
                    },
                  ),
                )
                .toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _scheduleReminder(String option) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for $option'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _startApplication() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting application process...'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Continue',
          onPressed: () {
            // Navigate to application form or external portal
          },
        ),
      ),
    );
  }
}
