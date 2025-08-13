import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculationResults extends StatefulWidget {
  final Map<String, dynamic> calculationData;
  final VoidCallback onShare;
  final VoidCallback onStartOver;

  const CalculationResults({
    super.key,
    required this.calculationData,
    required this.onShare,
    required this.onStartOver,
  });

  @override
  State<CalculationResults> createState() => _CalculationResultsState();
}

class _CalculationResultsState extends State<CalculationResults>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;

  final List<String> _sectionTitles = [
    'Cost Breakdown',
    'Monthly Savings',
    'Environmental Impact',
  ];

  // Mock calculation results based on input data
  late Map<String, dynamic> _results;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _generateResults();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _generateResults() {
    final roofArea = widget.calculationData['roofArea'] ?? 400.0;
    final monthlyBill = widget.calculationData['monthlyBill'] ?? 2000.0;
    final state = widget.calculationData['state'] ?? 'Karnataka';
    final roofType = widget.calculationData['roofType'] ?? 'Flat Roof';

    // Calculate system size (1 kW per 100 sq ft approximately)
    final systemSize = (roofArea / 100).round();

    // Calculate costs
    final systemCost = systemSize * 50000; // ₹50,000 per kW
    final centralSubsidy = systemSize * 18000; // ₹18,000 per kW central subsidy
    final stateSubsidy = systemSize * 10000; // ₹10,000 per kW state subsidy
    final netCost = systemCost - centralSubsidy - stateSubsidy;

    // Calculate savings
    final monthlySavings = monthlyBill * 0.8; // 80% bill reduction
    final annualSavings = monthlySavings * 12;
    final paybackPeriod = (netCost / annualSavings).round();

    // Environmental impact
    final co2Saved = systemSize * 1.5 * 365; // 1.5 kg CO2 per kW per day
    final treesEquivalent =
        (co2Saved / 22).round(); // 22 kg CO2 per tree per year

    _results = {
      'systemSize': systemSize,
      'systemCost': systemCost,
      'centralSubsidy': centralSubsidy,
      'stateSubsidy': stateSubsidy,
      'netCost': netCost,
      'monthlySavings': monthlySavings,
      'annualSavings': annualSavings,
      'paybackPeriod': paybackPeriod,
      'co2Saved': co2Saved,
      'treesEquivalent': treesEquivalent,
      'roofEfficiency': roofType == 'Flat Roof'
          ? 95
          : roofType == 'Sloped Roof'
              ? 90
              : 85,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with navigation dots
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Text(
                'Your Solar Calculation Results',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_sectionTitles.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Column(
                      children: [
                        Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentPage
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          _sectionTitles[index],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: index == _currentPage
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: index == _currentPage
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        // Results content
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildCostBreakdown(),
              _buildMonthlySavings(),
              _buildEnvironmentalImpact(),
            ],
          ),
        ),

        // Action buttons
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Share button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onShare,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Share Results & Get PDF Report',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Start over button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: widget.onStartOver,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Calculate Again',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System overview
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  Colors.orange,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '${_results['systemSize']} kW',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Recommended System Size',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${_results['roofEfficiency']}%',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Efficiency',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${_results['paybackPeriod']} years',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Payback',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Cost breakdown chart
          Text(
            'Cost Breakdown',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Container(
            height: 30.h,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: _results['netCost'].toDouble(),
                    title:
                        'Your Cost\n₹${(_results['netCost'] / 100000).toStringAsFixed(1)}L',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    radius: 60,
                    titleStyle:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PieChartSectionData(
                    value: _results['centralSubsidy'].toDouble(),
                    title:
                        'Central\nSubsidy\n₹${(_results['centralSubsidy'] / 100000).toStringAsFixed(1)}L',
                    color: Colors.green,
                    radius: 60,
                    titleStyle:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  PieChartSectionData(
                    value: _results['stateSubsidy'].toDouble(),
                    title:
                        'State\nSubsidy\n₹${(_results['stateSubsidy'] / 100000).toStringAsFixed(1)}L',
                    color: Colors.blue,
                    radius: 60,
                    titleStyle:
                        AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Cost details
          _buildCostItem('System Cost', _results['systemCost'], Colors.grey),
          _buildCostItem(
              'Central Subsidy', -_results['centralSubsidy'], Colors.green),
          _buildCostItem(
              'State Subsidy', -_results['stateSubsidy'], Colors.blue),
          Divider(thickness: 2),
          _buildCostItem('Your Final Cost', _results['netCost'],
              AppTheme.lightTheme.colorScheme.primary,
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCostItem(String title, double amount, Color color,
      {bool isTotal = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: isTotal ? color.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            '${amount < 0 ? '-' : ''}₹${(amount.abs() / 100000).toStringAsFixed(1)}L',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySavings() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly savings overview
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '₹${_results['monthlySavings'].toInt()}',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Monthly Savings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Save ₹${(_results['annualSavings'] / 100000).toStringAsFixed(1)}L annually',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Savings timeline chart
          Text(
            '25-Year Savings Projection',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Container(
            height: 30.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '₹${(value / 100000).toInt()}L',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}Y',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(26, (index) {
                      final cumulativeSavings =
                          _results['annualSavings'] * index -
                              _results['netCost'];
                      return FlSpot(
                          index.toDouble(), cumulativeSavings.toDouble());
                    }),
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Key milestones
          Text(
            'Key Milestones',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          _buildMilestone('Break Even', '${_results['paybackPeriod']} years',
              Colors.orange),
          _buildMilestone(
              '10 Year Savings',
              '₹${((_results['annualSavings'] * 10 - _results['netCost']) / 100000).toStringAsFixed(1)}L',
              Colors.green),
          _buildMilestone(
              '25 Year Savings',
              '₹${((_results['annualSavings'] * 25 - _results['netCost']) / 100000).toStringAsFixed(1)}L',
              Colors.blue),
        ],
      ),
    );
  }

  Widget _buildMilestone(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalImpact() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Environmental impact overview
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.teal],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'eco',
                  color: Colors.white,
                  size: 15.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  '${(_results['co2Saved'] / 1000).toStringAsFixed(1)} tons',
                  style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'CO₂ Saved Annually',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Environmental benefits
          Text(
            'Environmental Benefits',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          _buildEnvironmentalBenefit(
            'Trees Planted Equivalent',
            '${_results['treesEquivalent']} trees',
            'nature',
            Colors.green,
          ),

          _buildEnvironmentalBenefit(
            'Cars Off Road Equivalent',
            '${(_results['co2Saved'] / 4600).toInt()} cars/year',
            'directions_car',
            Colors.blue,
          ),

          _buildEnvironmentalBenefit(
            'Coal Avoided',
            '${(_results['co2Saved'] / 820).toStringAsFixed(1)} tons/year',
            'whatshot',
            Colors.orange,
          ),

          _buildEnvironmentalBenefit(
            'Clean Energy Generated',
            '${(_results['systemSize'] * 1500).toInt()} kWh/year',
            'bolt',
            Colors.purple,
          ),

          SizedBox(height: 3.h),

          // 25-year impact
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Text(
                  '25-Year Environmental Impact',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${((_results['co2Saved'] * 25) / 1000).toStringAsFixed(1)}',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Tons CO₂\nSaved',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${_results['treesEquivalent'] * 25}',
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Trees\nEquivalent',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalBenefit(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
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
