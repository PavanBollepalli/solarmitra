import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class FilterBottomSheet extends StatefulWidget {
  final String selectedLocation;
  final String selectedExperience;
  final String selectedRating;
  final String sortBy;
  final Function(String, String, String, String) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.selectedLocation,
    required this.selectedExperience,
    required this.selectedRating,
    required this.sortBy,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedLocation;
  late String _selectedExperience;
  late String _selectedRating;
  late String _sortBy;

  final List<String> _locations = [
    'सभी स्थान',
    'जयपुर',
    'उदयपुर',
    'जोधपुर',
    'अजमेर',
    'कोटा',
    'बीकानेर',
  ];

  final List<String> _experienceRanges = [
    'सभी',
    '1-3 साल',
    '4-7 साल',
    '8+ साल',
  ];

  final List<String> _ratingFilters = [
    'सभी रेटिंग',
    '4.5+ स्टार',
    '4.0+ स्टार',
    '3.5+ स्टार',
  ];

  final List<Map<String, String>> _sortOptions = [
    {'value': 'rating', 'label': 'रेटिंग के अनुसार'},
    {'value': 'distance', 'label': 'दूरी के अनुसार'},
    {'value': 'experience', 'label': 'अनुभव के अनुसार'},
    {'value': 'price', 'label': 'कीमत के अनुसार'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocation;
    _selectedExperience = widget.selectedExperience;
    _selectedRating = widget.selectedRating;
    _sortBy = widget.sortBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'फिल्टर और सॉर्ट',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text('सभी साफ़ करें'),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location filter
                  _buildFilterSection(
                    'स्थान',
                    Icons.location_on,
                    _locations,
                    _selectedLocation.isEmpty ? 'सभी स्थान' : _selectedLocation,
                    (value) {
                      setState(() {
                        _selectedLocation = value == 'सभी स्थान' ? '' : value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Experience filter
                  _buildFilterSection(
                    'अनुभव',
                    Icons.work_history,
                    _experienceRanges,
                    _selectedExperience.isEmpty ? 'सभी' : _selectedExperience,
                    (value) {
                      setState(() {
                        _selectedExperience = value == 'सभी' ? '' : value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Rating filter
                  _buildFilterSection(
                    'रेटिंग',
                    Icons.star,
                    _ratingFilters,
                    _selectedRating.isEmpty ? 'सभी रेटिंग' : _selectedRating,
                    (value) {
                      setState(() {
                        _selectedRating = value == 'सभी रेटिंग' ? '' : value;
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Sort options
                  _buildSortSection(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('रद्द करें'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('फिल्टर लागू करें'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    IconData icon,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 5.w),
            SizedBox(width: 2.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.sort, color: Colors.grey.shade600, size: 5.w),
            SizedBox(width: 2.w),
            Text(
              'सॉर्ट करें',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Column(
          children: _sortOptions.map((option) {
            final isSelected = option['value'] == _sortBy;
            return RadioListTile<String>(
              title: Text(
                option['label']!,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              value: option['value']!,
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedLocation = '';
      _selectedExperience = '';
      _selectedRating = '';
      _sortBy = 'rating';
    });
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _selectedLocation,
      _selectedExperience,
      _selectedRating,
      _sortBy,
    );
    Navigator.of(context).pop();
  }
}