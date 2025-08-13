import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_dialog_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/scheme_card_widget.dart';
import './widgets/search_header_widget.dart';

class GovernmentSchemesList extends StatefulWidget {
  const GovernmentSchemesList({super.key});

  @override
  State<GovernmentSchemesList> createState() => _GovernmentSchemesListState();
}

class _GovernmentSchemesListState extends State<GovernmentSchemesList>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isRefreshing = false;
  String _selectedTab = 'All';
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _filteredSchemes = [];
  Map<String, dynamic>? _selectedSchemeForActions;
  DateTime _lastSyncTime = DateTime.now();

  late TabController _tabController;

  // Mock data for government schemes
  final List<Map<String, dynamic>> _allSchemes = [
    {
      "id": "1",
      "name": "PM-KUSUM Yojana",
      "nameHindi": "प्रधानमंत्री किसान ऊर्जा सुरक्षा एवं उत्थान महाभियान",
      "type": "Central Government",
      "state": "All India",
      "maxSubsidy": "₹4,80,000",
      "subsidyPercentage": 60,
      "deadline": "31 Dec 2024",
      "eligibilityStatus": "eligible",
      "description":
          "Solar pump scheme for farmers to reduce electricity dependency and increase irrigation efficiency.",
      "targetBeneficiaries": "Farmers with irrigation pumps",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-10",
      "isFavorite": false,
    },
    {
      "id": "2",
      "name": "Rooftop Solar Scheme",
      "nameHindi": "छत पर सौर ऊर्जा योजना",
      "type": "Central Government",
      "state": "All India",
      "maxSubsidy": "₹78,000",
      "subsidyPercentage": 40,
      "deadline": "31 Mar 2025",
      "eligibilityStatus": "eligible",
      "description":
          "Subsidy for installing rooftop solar panels on residential and commercial buildings.",
      "targetBeneficiaries": "Residential & Commercial consumers",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-12",
      "isFavorite": true,
    },
    {
      "id": "3",
      "name": "Karnataka Solar Policy 2024",
      "nameHindi": "कर्नाटक सौर नीति 2024",
      "type": "State Government",
      "state": "Karnataka",
      "maxSubsidy": "₹1,20,000",
      "subsidyPercentage": 50,
      "deadline": "30 Sep 2024",
      "eligibilityStatus": "pending",
      "description":
          "State-specific solar incentives for rural households and small businesses in Karnataka.",
      "targetBeneficiaries": "Karnataka residents",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-08",
      "isFavorite": false,
    },
    {
      "id": "4",
      "name": "Solar Water Heating System",
      "nameHindi": "सौर जल तापन प्रणाली",
      "type": "Central Government",
      "state": "All India",
      "maxSubsidy": "₹25,000",
      "subsidyPercentage": 30,
      "deadline": "15 Nov 2024",
      "eligibilityStatus": "eligible",
      "description":
          "Subsidy for installing solar water heating systems in residential buildings.",
      "targetBeneficiaries": "Residential consumers",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-11",
      "isFavorite": false,
    },
    {
      "id": "5",
      "name": "Tamil Nadu Solar Park",
      "nameHindi": "तमिलनाडु सौर पार्क",
      "type": "State Government",
      "state": "Tamil Nadu",
      "maxSubsidy": "₹2,00,000",
      "subsidyPercentage": 45,
      "deadline": "20 Oct 2024",
      "eligibilityStatus": "ineligible",
      "description":
          "Large-scale solar park development with community participation benefits.",
      "targetBeneficiaries": "Tamil Nadu farmers & communities",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-09",
      "isFavorite": false,
    },
    {
      "id": "6",
      "name": "Grid Connected Solar Rooftop",
      "nameHindi": "ग्रिड कनेक्टेड सोलर रूफटॉप",
      "type": "Central Government",
      "state": "All India",
      "maxSubsidy": "₹94,000",
      "subsidyPercentage": 40,
      "deadline": "31 Jan 2025",
      "eligibilityStatus": "eligible",
      "description":
          "Net metering facility with grid-connected rooftop solar installations.",
      "targetBeneficiaries": "All electricity consumers",
      "applicationStatus": "open",
      "lastUpdated": "2024-08-13",
      "isFavorite": false,
    },
  ];

  final List<String> _tabs = [
    'All',
    'Central',
    'State',
    'Eligible',
    'Favorites'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _filteredSchemes = List.from(_allSchemes);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTab = _tabs[_tabController.index];
        _filterSchemes();
      });
    }
  }

  void _onSearchChanged() {
    _filterSchemes();
  }

  void _filterSchemes() {
    setState(() {
      _filteredSchemes = _allSchemes.where((scheme) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            (scheme['name'] as String).toLowerCase().contains(searchQuery) ||
            (scheme['nameHindi'] as String)
                .toLowerCase()
                .contains(searchQuery) ||
            (scheme['description'] as String)
                .toLowerCase()
                .contains(searchQuery);

        if (!matchesSearch) return false;

        // Tab filter
        switch (_selectedTab) {
          case 'Central':
            if (scheme['type'] != 'Central Government') return false;
            break;
          case 'State':
            if (scheme['type'] != 'State Government') return false;
            break;
          case 'Eligible':
            if (scheme['eligibilityStatus'] != 'eligible') return false;
            break;
          case 'Favorites':
            if (!(scheme['isFavorite'] as bool)) return false;
            break;
        }

        // Active filters
        if (_activeFilters.isNotEmpty) {
          // Scheme type filter
          final schemeTypes = _activeFilters['schemeTypes'] as List<String>?;
          if (schemeTypes != null && schemeTypes.isNotEmpty) {
            if (!schemeTypes.contains(scheme['type'])) return false;
          }

          // Subsidy range filter
          final subsidyRange = _activeFilters['subsidyRange'] as String?;
          if (subsidyRange != null) {
            final subsidyAmount = int.tryParse((scheme['maxSubsidy'] as String)
                    .replaceAll('₹', '')
                    .replaceAll(',', '')) ??
                0;

            switch (subsidyRange) {
              case 'Up to ₹50,000':
                if (subsidyAmount > 50000) return false;
                break;
              case '₹50,000 - ₹1,00,000':
                if (subsidyAmount <= 50000 || subsidyAmount > 100000)
                  return false;
                break;
              case '₹1,00,000 - ₹2,00,000':
                if (subsidyAmount <= 100000 || subsidyAmount > 200000)
                  return false;
                break;
              case 'Above ₹2,00,000':
                if (subsidyAmount <= 200000) return false;
                break;
            }
          }

          // Eligibility filter
          final onlyEligible = _activeFilters['onlyEligible'] as bool?;
          if (onlyEligible == true &&
              scheme['eligibilityStatus'] != 'eligible') {
            return false;
          }

          // State filter
          final selectedState = _activeFilters['selectedState'] as String?;
          if (selectedState != null && selectedState != 'All India') {
            if (scheme['state'] != selectedState &&
                scheme['state'] != 'All India') {
              return false;
            }
          }
        }

        return true;
      }).toList();
    });
  }

  Future<void> _refreshSchemes() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastSyncTime = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schemes updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialogWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
            _filterSchemes();
          });
        },
      ),
    );
  }

  void _removeFilter(Map<String, dynamic> filter) {
    setState(() {
      final key = filter['key'] as String;
      _activeFilters.remove(key);
      _filterSchemes();
    });
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _searchController.clear();
      _selectedTab = 'All';
      _tabController.animateTo(0);
      _filterSchemes();
    });
  }

  void _onSchemeCardTap(Map<String, dynamic> scheme) {
    Navigator.pushNamed(
      context,
      '/scheme-details',
      arguments: scheme,
    );
  }

  void _onSchemeCardLongPress(Map<String, dynamic> scheme) {
    setState(() {
      _selectedSchemeForActions = scheme;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsWidget(
        scheme: scheme,
        onShareDetails: () => _shareSchemeDetails(scheme),
        onMarkFavorite: () => _toggleFavorite(scheme),
        onSetReminder: () => _setReminder(scheme),
        onGetAudioSummary: () => _getAudioSummary(scheme),
        onDismiss: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _shareSchemeDetails(Map<String, dynamic> scheme) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${scheme['name']} details...')),
    );
  }

  void _toggleFavorite(Map<String, dynamic> scheme) {
    Navigator.of(context).pop();
    setState(() {
      final index = _allSchemes.indexWhere((s) => s['id'] == scheme['id']);
      if (index != -1) {
        _allSchemes[index]['isFavorite'] = !(scheme['isFavorite'] as bool);
        _filterSchemes();
      }
    });

    final isFavorite = !(scheme['isFavorite'] as bool);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  }

  void _setReminder(Map<String, dynamic> scheme) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set for ${scheme['name']}')),
    );
  }

  void _getAudioSummary(Map<String, dynamic> scheme) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing audio summary for ${scheme['name']}')),
    );
  }

  void _onVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voice search activated')),
    );
  }

  void _showSchemeComparison() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening scheme comparison tool')),
    );
  }

  List<Map<String, dynamic>> _getActiveFiltersList() {
    List<Map<String, dynamic>> filters = [];

    if (_activeFilters['schemeTypes'] != null) {
      final types = _activeFilters['schemeTypes'] as List<String>;
      for (String type in types) {
        filters.add({
          'key': 'schemeTypes',
          'label': type,
          'count': _allSchemes.where((s) => s['type'] == type).length,
        });
      }
    }

    if (_activeFilters['subsidyRange'] != null) {
      filters.add({
        'key': 'subsidyRange',
        'label': _activeFilters['subsidyRange'],
      });
    }

    if (_activeFilters['onlyEligible'] == true) {
      filters.add({
        'key': 'onlyEligible',
        'label': 'Eligible Only',
        'count': _allSchemes
            .where((s) => s['eligibilityStatus'] == 'eligible')
            .length,
      });
    }

    if (_activeFilters['selectedState'] != null &&
        _activeFilters['selectedState'] != 'All India') {
      filters.add({
        'key': 'selectedState',
        'label': _activeFilters['selectedState'],
      });
    }

    return filters;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Search header
          SearchHeaderWidget(
            searchController: _searchController,
            onFilterTap: _showFilterDialog,
            onVoiceSearch: _onVoiceSearch,
            onSearchChanged: (value) => _filterSchemes(),
          ),

          // Tab bar
          Container(
            color: colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),

          // Filter chips
          FilterChipsWidget(
            activeFilters: _getActiveFiltersList(),
            onFilterRemoved: _removeFilter,
          ),

          // Last sync time
          if (!_isRefreshing)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'sync',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Last updated: ${_formatSyncTime(_lastSyncTime)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

          // Schemes list
          Expanded(
            child: _isLoading
                ? _buildSkeletonLoader()
                : _filteredSchemes.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshSchemes,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredSchemes.length,
                          itemBuilder: (context, index) {
                            final scheme = _filteredSchemes[index];
                            return SchemeCardWidget(
                              scheme: scheme,
                              onTap: () => _onSchemeCardTap(scheme),
                              onLongPress: () => _onSchemeCardLongPress(scheme),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // Floating action button for scheme comparison
      floatingActionButton: _filteredSchemes.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showSchemeComparison,
              icon: CustomIconWidget(
                iconName: 'compare',
                color: colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Compare'),
            )
          : null,
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 2.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              height: 1.5.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Container(
                        height: 1.5.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        height: 1.5.h,
                        width: 15.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
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

  Widget _buildEmptyState() {
    EmptyStateType type;
    VoidCallback? action;

    if (_searchController.text.isNotEmpty || _activeFilters.isNotEmpty) {
      type = EmptyStateType.noResults;
      action = _clearAllFilters;
    } else if (_allSchemes.isEmpty) {
      type = EmptyStateType.noSchemes;
      action = _refreshSchemes;
    } else {
      type = EmptyStateType.noConnection;
      action = _refreshSchemes;
    }

    return EmptyStateWidget(
      type: type,
      onAction: action,
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
