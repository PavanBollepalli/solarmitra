import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SchemeTabContent extends StatelessWidget {
  final Map<String, dynamic> schemeData;
  final Map<String, dynamic> userProfile;

  const SchemeTabContent({
    super.key,
    required this.schemeData,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Tab bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              tabs: [
                Tab(text: 'Overview'),
                Tab(text: 'Eligibility'),
                Tab(text: 'Documents'),
                Tab(text: 'Apply'),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                _buildOverviewTab(context),
                _buildEligibilityTab(context),
                _buildDocumentsTab(context),
                _buildApplyTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subsidy amount card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Subsidy Amount',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '₹${schemeData['subsidyAmount'] ?? '30,000'}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Up to ${schemeData['coveragePercentage'] ?? '40'}% coverage',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Key benefits
          Text(
            'Key Benefits',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          ..._buildBenefitsList(context),

          SizedBox(height: 3.h),

          // Description
          if (schemeData['description'] != null) ...[
            Text(
              'About This Scheme',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              child: Text(
                schemeData['description'] as String,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ),
          ],

          SizedBox(height: 10.h), // Bottom padding for sticky button
        ],
      ),
    );
  }

  List<Widget> _buildBenefitsList(BuildContext context) {
    final benefits = [
      {
        'icon': 'solar_power',
        'title': 'Clean Energy',
        'subtitle': 'Reduce carbon footprint'
      },
      {
        'icon': 'savings',
        'title': 'Bill Reduction',
        'subtitle': 'Up to 90% electricity savings'
      },
      {
        'icon': 'trending_up',
        'title': 'Property Value',
        'subtitle': 'Increase home value'
      },
      {
        'icon': 'support_agent',
        'title': 'Government Support',
        'subtitle': '25-year warranty support'
      },
    ];

    return benefits
        .map((benefit) => Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: benefit['icon'] as String,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          benefit['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          benefit['subtitle'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildEligibilityTab(BuildContext context) {
    final theme = Theme.of(context);

    final eligibilityCriteria = [
      {
        'title': 'Annual Income',
        'requirement': 'Below ₹6,00,000',
        'userValue': '₹${userProfile['annualIncome'] ?? '2,50,000'}',
        'status': _checkIncomeEligibility(),
      },
      {
        'title': 'Property Ownership',
        'requirement': 'Own residential property',
        'userValue': userProfile['propertyOwnership'] ?? 'Yes',
        'status': (userProfile['propertyOwnership'] ?? 'Yes') == 'Yes',
      },
      {
        'title': 'Roof Area',
        'requirement': 'Minimum 100 sq ft',
        'userValue': '${userProfile['roofArea'] ?? '250'} sq ft',
        'status': int.tryParse(userProfile['roofArea']?.toString() ?? '250') !=
                null &&
            int.parse(userProfile['roofArea']?.toString() ?? '250') >= 100,
      },
      {
        'title': 'Electricity Connection',
        'requirement': 'Valid electricity connection',
        'userValue': userProfile['hasElectricityConnection'] ?? 'Yes',
        'status': (userProfile['hasElectricityConnection'] ?? 'Yes') == 'Yes',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall eligibility status
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: _getOverallEligibility(eligibilityCriteria)
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getOverallEligibility(eligibilityCriteria)
                    ? Colors.green
                    : Colors.orange,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _getOverallEligibility(eligibilityCriteria)
                      ? 'check_circle'
                      : 'warning',
                  color: _getOverallEligibility(eligibilityCriteria)
                      ? Colors.green
                      : Colors.orange,
                  size: 32,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getOverallEligibility(eligibilityCriteria)
                            ? 'You are Eligible!'
                            : 'Partially Eligible',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getOverallEligibility(eligibilityCriteria)
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _getOverallEligibility(eligibilityCriteria)
                            ? 'You meet all requirements for this scheme'
                            : 'Some requirements need attention',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Eligibility Checklist',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Eligibility criteria list
          ...eligibilityCriteria
              .map((criteria) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: (criteria['status'] as bool)
                              ? 'check_circle'
                              : 'cancel',
                          color: (criteria['status'] as bool)
                              ? Colors.green
                              : Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                criteria['title'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Required: ${criteria['requirement']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                'Your status: ${criteria['userValue']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: (criteria['status'] as bool)
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),

          SizedBox(height: 10.h), // Bottom padding for sticky button
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(BuildContext context) {
    final theme = Theme.of(context);

    final requiredDocuments = [
      {'name': 'Aadhaar Card', 'icon': 'credit_card', 'uploaded': true},
      {'name': 'Electricity Bill', 'icon': 'receipt', 'uploaded': false},
      {'name': 'Property Documents', 'icon': 'home', 'uploaded': false},
      {
        'name': 'Income Certificate',
        'icon': 'account_balance_wallet',
        'uploaded': false
      },
      {'name': 'Bank Passbook', 'icon': 'account_balance', 'uploaded': true},
      {'name': 'Roof Photograph', 'icon': 'photo_camera', 'uploaded': false},
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload progress
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Document Upload Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                LinearProgressIndicator(
                  value: _getUploadProgress(requiredDocuments),
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${(_getUploadProgress(requiredDocuments) * 100).toInt()}% Complete',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          Text(
            'Required Documents',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Documents list
          ...requiredDocuments
              .map((document) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: (document['uploaded'] as bool)
                                ? Colors.green.withValues(alpha: 0.1)
                                : theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: document['icon'] as String,
                            color: (document['uploaded'] as bool)
                                ? Colors.green
                                : theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document['name'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                (document['uploaded'] as bool)
                                    ? 'Uploaded'
                                    : 'Not uploaded',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: (document['uploaded'] as bool)
                                      ? Colors.green
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!(document['uploaded'] as bool))
                          ElevatedButton(
                            onPressed: () => _uploadDocument(
                                context, document['name'] as String),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              minimumSize: Size(0, 0),
                            ),
                            child: Text('Upload'),
                          )
                        else
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: Colors.green,
                            size: 24,
                          ),
                      ],
                    ),
                  ))
              .toList(),

          SizedBox(height: 10.h), // Bottom padding for sticky button
        ],
      ),
    );
  }

  Widget _buildApplyTab(BuildContext context) {
    final theme = Theme.of(context);

    final applicationSteps = [
      {
        'step': '1',
        'title': 'Document Verification',
        'description': 'Upload and verify all required documents',
        'status': 'completed',
      },
      {
        'step': '2',
        'title': 'Eligibility Check',
        'description': 'System will verify your eligibility automatically',
        'status': 'current',
      },
      {
        'step': '3',
        'title': 'Site Survey',
        'description': 'Technical team will visit for roof assessment',
        'status': 'pending',
      },
      {
        'step': '4',
        'title': 'Application Submission',
        'description': 'Submit application to government portal',
        'status': 'pending',
      },
      {
        'step': '5',
        'title': 'Approval & Installation',
        'description': 'Get approval and schedule installation',
        'status': 'pending',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Application process
          Text(
            'Application Process',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          // Steps list
          ...applicationSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == applicationSteps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator
                Column(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: _getStepColor(step['status'] as String, theme),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _getStepIcon(
                            step['status'] as String, step['step'] as String),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 8.h,
                        color: theme.dividerColor,
                      ),
                  ],
                ),

                SizedBox(width: 4.w),

                // Step content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          step['description'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),

          SizedBox(height: 4.h),

          // External links section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Official Application Portal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                ElevatedButton.icon(
                  onPressed: () => _openOfficialPortal(context),
                  icon: CustomIconWidget(
                    iconName: 'open_in_new',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text('Visit Government Portal'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 6.h),
                  ),
                ),
                SizedBox(height: 2.h),
                OutlinedButton.icon(
                  onPressed: () => _generatePreFilledForm(context),
                  icon: CustomIconWidget(
                    iconName: 'description',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text('Generate Pre-filled Form'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 6.h),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h), // Bottom padding for sticky button
        ],
      ),
    );
  }

  bool _checkIncomeEligibility() {
    final income =
        int.tryParse(userProfile['annualIncome']?.toString() ?? '250000') ??
            250000;
    return income <= 600000;
  }

  bool _getOverallEligibility(List<Map<String, dynamic>> criteria) {
    return criteria.every((criterion) => criterion['status'] as bool);
  }

  double _getUploadProgress(List<Map<String, dynamic>> documents) {
    final uploadedCount =
        documents.where((doc) => doc['uploaded'] as bool).length;
    return uploadedCount / documents.length;
  }

  Color _getStepColor(String status, ThemeData theme) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'current':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.3);
    }
  }

  Widget _getStepIcon(String status, String stepNumber) {
    switch (status) {
      case 'completed':
        return CustomIconWidget(
          iconName: 'check',
          color: Colors.white,
          size: 20,
        );
      case 'current':
        return Text(
          stepNumber,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        );
      default:
        return Text(
          stepNumber,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        );
    }
  }

  void _uploadDocument(BuildContext context, String documentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Upload functionality for $documentName will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openOfficialPortal(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening official government portal...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generatePreFilledForm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating pre-filled application form...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
