import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/installer_card.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/search_bar_widget.dart';

class InstallerMarketplace extends StatefulWidget {
  const InstallerMarketplace({super.key});

  @override
  State<InstallerMarketplace> createState() => _InstallerMarketplaceState();
}

class _InstallerMarketplaceState extends State<InstallerMarketplace>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _installers = [];
  List<Map<String, dynamic>> _filteredInstallers = [];
  
  String _selectedLocation = '';
  String _selectedExperience = '';
  String _selectedRating = '';
  String _sortBy = 'rating';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadInstallers();
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

  void _loadInstallers() {
    // Mock installer data
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _installers = [
          {
            'id': '1',
            'name': 'सोलर एनर्जी सिस्टम्स',
            'ownerName': 'राजेश कुमार',
            'rating': 4.8,
            'reviewCount': 156,
            'experience': '8 साल',
            'location': 'जयपुर, राजस्थान',
            'distance': '2.5 किमी',
            'specialization': ['रेसिडेंशियल', 'कमर्शियल'],
            'certifications': ['MNRE Certified', 'ISO 9001'],
            'minPrice': 45000,
            'maxPrice': 250000,
            'projectsCompleted': 450,
            'phone': '+91 98765 43210',
            'whatsapp': '+91 98765 43210',
            'email': 'info@solarenergy.com',
            'services': ['सोलर पैनल इंस्टॉलेशन', 'मेंटेनेंस', 'रिपेयर'],
            'languages': ['हिंदी', 'English'],
            'isVerified': true,
            'responseTime': '2 घंटे',
            'availability': 'उपलब्ध',
            'profileImage': 'https://example.com/profile1.jpg',
            'galleryImages': [
              'https://example.com/project1.jpg',
              'https://example.com/project2.jpg',
            ],
          },
          {
            'id': '2',
            'name': 'ग्रीन पावर सोल्यूशन्स',
            'ownerName': 'अमित शर्मा',
            'rating': 4.6,
            'reviewCount': 89,
            'experience': '5 साल',
            'location': 'उदयपुर, राजस्थान',
            'distance': '15 किमी',
            'specialization': ['रेसिडेंशियल'],
            'certifications': ['MNRE Certified'],
            'minPrice': 35000,
            'maxPrice': 180000,
            'projectsCompleted': 220,
            'phone': '+91 87654 32109',
            'whatsapp': '+91 87654 32109',
            'email': 'contact@greenpower.com',
            'services': ['सोलर पैनल इंस्टॉलेशन', 'कंसल्टेशन'],
            'languages': ['हिंदी', 'राजस्थानी'],
            'isVerified': true,
            'responseTime': '4 घंटे',
            'availability': 'उपलब्ध',
            'profileImage': 'https://example.com/profile2.jpg',
            'galleryImages': [
              'https://example.com/project3.jpg',
              'https://example.com/project4.jpg',
            ],
          },
          {
            'id': '3',
            'name': 'सन शाइन टेक्नोलॉजी',
            'ownerName': 'प्रदीप गुप्ता',
            'rating': 4.9,
            'reviewCount': 234,
            'experience': '12 साल',
            'location': 'जोधपुर, राजस्थान',
            'distance': '45 किमी',
            'specialization': ['रेसिडेंशियल', 'कमर्शियल', 'इंडस्ट्रियल'],
            'certifications': ['MNRE Certified', 'ISO 9001', 'ISO 14001'],
            'minPrice': 55000,
            'maxPrice': 500000,
            'projectsCompleted': 850,
            'phone': '+91 76543 21098',
            'whatsapp': '+91 76543 21098',
            'email': 'info@sunshine.com',
            'services': ['सोलर पैनल इंस्टॉलेशन', 'मेंटेनेंस', 'रिपेयर', 'कंसल्टेशन'],
            'languages': ['हिंदी', 'English', 'राजस्थानी'],
            'isVerified': true,
            'responseTime': '1 घंटा',
            'availability': 'व्यस्त',
            'profileImage': 'https://example.com/profile3.jpg',
            'galleryImages': [
              'https://example.com/project5.jpg',
              'https://example.com/project6.jpg',
            ],
          },
          {
            'id': '4',
            'name': 'इको सोलर वर्क्स',
            'ownerName': 'विकास पटेल',
            'rating': 4.4,
            'reviewCount': 67,
            'experience': '3 साल',
            'location': 'अजमेर, राजस्थान',
            'distance': '25 किमी',
            'specialization': ['रेसिडेंशियल'],
            'certifications': ['MNRE Certified'],
            'minPrice': 32000,
            'maxPrice': 150000,
            'projectsCompleted': 120,
            'phone': '+91 65432 10987',
            'whatsapp': '+91 65432 10987',
            'email': 'contact@ecosolar.com',
            'services': ['सोलर पैनल इंस्टॉलेशन', 'मेंटेनेंस'],
            'languages': ['हिंदी', 'गुजराती'],
            'isVerified': false,
            'responseTime': '6 घंटे',
            'availability': 'उपलब्ध',
            'profileImage': 'https://example.com/profile4.jpg',
            'galleryImages': [
              'https://example.com/project7.jpg',
            ],
          },
        ];
        _filteredInstallers = List.from(_installers);
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'इंस्टॉलर मार्केटप्लेस',
          showBackArrow: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'इंस्टॉलर मार्केटप्लेस',
        showBackArrow: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Search and filter section
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search bar
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: _filterInstallers,
                      onFilterPressed: _showFilterBottomSheet,
                    ),
                    
                    SizedBox(height: 2.h),
                    
                    // Quick stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatChip(
                          '${_filteredInstallers.length}',
                          'इंस्टॉलर',
                          Icons.engineering,
                        ),
                        _buildStatChip(
                          '${_filteredInstallers.where((i) => i['isVerified']).length}',
                          'सत्यापित',
                          Icons.verified,
                        ),
                        _buildStatChip(
                          '${_filteredInstallers.where((i) => i['availability'] == 'उपलब्ध').length}',
                          'उपलब्ध',
                          Icons.check_circle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Installers list
              Expanded(
                child: _filteredInstallers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(4.w),
                        itemCount: _filteredInstallers.length,
                        itemBuilder: (context, index) {
                          return InstallerCard(
                            installer: _filteredInstallers[index],
                            onTap: () => _showInstallerDetails(_filteredInstallers[index]),
                            onContact: () => _contactInstaller(_filteredInstallers[index]),
                            onGetQuote: () => _getQuote(_filteredInstallers[index]),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String count, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 5.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          count,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 20.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'कोई इंस्टॉलर नहीं मिला',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'अपने फिल्टर बदलकर दोबारा कोशिश करें',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _clearFilters,
            child: Text('फिल्टर साफ़ करें'),
          ),
        ],
      ),
    );
  }

  void _filterInstallers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInstallers = List.from(_installers);
      } else {
        _filteredInstallers = _installers.where((installer) {
          final name = installer['name'].toString().toLowerCase();
          final location = installer['location'].toString().toLowerCase();
          final services = installer['services'].join(' ').toLowerCase();
          final searchQuery = query.toLowerCase();
          
          return name.contains(searchQuery) ||
                 location.contains(searchQuery) ||
                 services.contains(searchQuery);
        }).toList();
      }
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    // Apply filters
    List<Map<String, dynamic>> filtered = List.from(_filteredInstallers);

    if (_selectedLocation.isNotEmpty) {
      filtered = filtered.where((installer) =>
          installer['location'].toString().contains(_selectedLocation)).toList();
    }

    if (_selectedExperience.isNotEmpty) {
      filtered = filtered.where((installer) {
        final experience = int.tryParse(installer['experience'].toString().split(' ')[0]) ?? 0;
        switch (_selectedExperience) {
          case '1-3 साल':
            return experience >= 1 && experience <= 3;
          case '4-7 साल':
            return experience >= 4 && experience <= 7;
          case '8+ साल':
            return experience >= 8;
          default:
            return true;
        }
      }).toList();
    }

    if (_selectedRating.isNotEmpty) {
      final minRating = double.tryParse(_selectedRating.split(' ')[0]) ?? 0.0;
      filtered = filtered.where((installer) =>
          installer['rating'] >= minRating).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
        break;
      case 'distance':
        filtered.sort((a, b) {
          final distanceA = double.tryParse(a['distance'].toString().split(' ')[0]) ?? double.infinity;
          final distanceB = double.tryParse(b['distance'].toString().split(' ')[0]) ?? double.infinity;
          return distanceA.compareTo(distanceB);
        });
        break;
      case 'experience':
        filtered.sort((a, b) {
          final expA = int.tryParse(a['experience'].toString().split(' ')[0]) ?? 0;
          final expB = int.tryParse(b['experience'].toString().split(' ')[0]) ?? 0;
          return expB.compareTo(expA);
        });
        break;
      case 'price':
        filtered.sort((a, b) => (a['minPrice'] as int).compareTo(b['minPrice'] as int));
        break;
    }

    setState(() {
      _filteredInstallers = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedLocation: _selectedLocation,
        selectedExperience: _selectedExperience,
        selectedRating: _selectedRating,
        sortBy: _sortBy,
        onApplyFilters: (location, experience, rating, sort) {
          setState(() {
            _selectedLocation = location;
            _selectedExperience = experience;
            _selectedRating = rating;
            _sortBy = sort;
          });
          _applyFiltersAndSort();
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedLocation = '';
      _selectedExperience = '';
      _selectedRating = '';
      _sortBy = 'rating';
      _searchController.clear();
      _filteredInstallers = List.from(_installers);
    });
  }

  void _showInstallerDetails(Map<String, dynamic> installer) {
    Navigator.pushNamed(
      context,
      '/installer-details',
      arguments: installer,
    );
  }

  void _contactInstaller(Map<String, dynamic> installer) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${installer['name']} से संपर्क करें',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactOption(
                  'फोन कॉल',
                  Icons.phone,
                  Colors.blue,
                  () => _makePhoneCall(installer['phone']),
                ),
                _buildContactOption(
                  'WhatsApp',
                  Icons.chat,
                  Colors.green,
                  () => _openWhatsApp(installer['whatsapp']),
                ),
                _buildContactOption(
                  'ईमेल',
                  Icons.email,
                  Colors.orange,
                  () => _sendEmail(installer['email']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 6.w),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  void _getQuote(Map<String, dynamic> installer) {
    Navigator.pushNamed(
      context,
      '/quote-request',
      arguments: installer,
    );
  }

  void _makePhoneCall(String phone) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('कॉल कर रहे हैं: $phone'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _openWhatsApp(String whatsapp) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('WhatsApp खोल रहे हैं: $whatsapp'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _sendEmail(String email) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ईमेल भेज रहे हैं: $email'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}