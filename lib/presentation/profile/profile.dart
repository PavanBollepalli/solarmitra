import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'राम कुमार',
    'phone': '+91 98765 43210',
    'email': 'ram.kumar@email.com',
    'location': 'जयपुर, राजस्थान',
    'profilePicture': null,
    'memberSince': '2024',
    'applicationsSubmitted': 3,
    'savedSchemes': 8,
    'profileCompletion': 85,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'प्रोफाइल',
        showBackArrow: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              // Profile header
              _buildProfileHeader(theme),
              
              SizedBox(height: 3.h),
              
              // Profile completion
              _buildProfileCompletion(theme),
              
              SizedBox(height: 3.h),
              
              // Statistics
              _buildStatistics(theme),
              
              SizedBox(height: 3.h),
              
              // Menu options
              _buildMenuOptions(theme),
              
              SizedBox(height: 3.h),
              
              // Logout button
              _buildLogoutButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile picture
          Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 12.w,
            ),
          ),
          
          SizedBox(height: 2.h),
          
          // Name
          Text(
            _userData['name'],
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 0.5.h),
          
          // Phone
          Text(
            _userData['phone'],
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          
          SizedBox(height: 0.5.h),
          
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white.withOpacity(0.9),
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                _userData['location'],
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 1.h),
          
          // Member since
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Text(
              'सदस्य ${_userData['memberSince']} से',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletion(ThemeData theme) {
    final completion = _userData['profileCompletion'] as int;
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'प्रोफाइल पूर्णता',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$completion%',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 2.h),
          
          LinearProgressIndicator(
            value: completion / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
          
          SizedBox(height: 1.h),
          
          Text(
            'अपनी प्रोफाइल को पूरा करने से बेहतर सुझाव मिलते हैं',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '${_userData['applicationsSubmitted']}',
            'आवेदन जमा किए',
            Icons.description,
            Colors.blue,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            '${_userData['savedSchemes']}',
            'सेव की गई योजनाएं',
            Icons.bookmark,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
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
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
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

  Widget _buildMenuOptions(ThemeData theme) {
    final menuItems = [
      {
        'title': 'व्यक्तिगत जानकारी',
        'subtitle': 'नाम, फोन, ईमेल संपादित करें',
        'icon': Icons.person_outline,
        'onTap': () => _editPersonalInfo(),
      },
      {
        'title': 'सहेजी गई योजनाएं',
        'subtitle': 'आपकी पसंदीदा योजनाएं देखें',
        'icon': Icons.bookmark_outline,
        'onTap': () => _viewSavedSchemes(),
      },
      {
        'title': 'आवेदन इतिहास',
        'subtitle': 'सभी आवेदनों की स्थिति देखें',
        'icon': Icons.history,
        'onTap': () => _viewApplicationHistory(),
      },
      {
        'title': 'भाषा सेटिंग्स',
        'subtitle': 'ऐप की भाषा बदलें',
        'icon': Icons.language,
        'onTap': () => _changeLanguage(),
      },
      {
        'title': 'सूचनाएं',
        'subtitle': 'नोटिफिकेशन सेटिंग्स',
        'icon': Icons.notifications_outline,
        'onTap': () => _notificationSettings(),
      },
      {
        'title': 'सहायता और समर्थन',
        'subtitle': 'मदद पाएं या समस्या रिपोर्ट करें',
        'icon': Icons.help_outline,
        'onTap': () => _helpAndSupport(),
      },
      {
        'title': 'ऐप के बारे में',
        'subtitle': 'संस्करण और जानकारी',
        'icon': Icons.info_outline,
        'onTap': () => _aboutApp(),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: menuItems.map((item) {
          final isLast = item == menuItems.last;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: theme.primaryColor,
                    size: 5.w,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 4.w,
                ),
                onTap: item['onTap'] as VoidCallback,
              ),
              if (!isLast) Divider(height: 1, indent: 16.w),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _logout,
        icon: Icon(Icons.logout, size: 5.w),
        label: Text('लॉग आउट'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('प्रोफाइल संपादन फीचर जल्द आएगा')),
    );
  }

  void _editPersonalInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('व्यक्तिगत जानकारी संपादन फीचर जल्द आएगा')),
    );
  }

  void _viewSavedSchemes() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('सहेजी गई योजनाएं फीचर जल्द आएगा')),
    );
  }

  void _viewApplicationHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('आवेदन इतिहास फीचर जल्द आएगा')),
    );
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('भाषा चुनें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('हिंदी'),
              leading: Radio(value: 'hi', groupValue: 'hi', onChanged: (v) {}),
            ),
            ListTile(
              title: Text('English'),
              leading: Radio(value: 'en', groupValue: 'hi', onChanged: (v) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('सेव करें'),
          ),
        ],
      ),
    );
  }

  void _notificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('नोटिफिकेशन सेटिंग्स फीचर जल्द आएगा')),
    );
  }

  void _helpAndSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('सहायता और समर्थन'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('सहायता के लिए संपर्क करें:'),
            SizedBox(height: 2.h),
            Text('📞 हेल्पलाइन: 1800-XXX-XXXX'),
            Text('📧 ईमेल: support@solarmitra.gov.in'),
            Text('🕒 समय: सुबह 9 बजे से शाम 6 बजे तक'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  void _aboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('SolarMitra के बारे में'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('संस्करण: 1.0.0'),
            SizedBox(height: 1.h),
            Text('SolarMitra - आपका सोलर एनर्जी पार्टनर'),
            SizedBox(height: 1.h),
            Text('यह ऐप भारत सरकार की पहल है जो नागरिकों को सोलर एनर्जी के बारे में जानकारी और सरकारी योजनाओं का लाभ उठाने में मदद करती है।'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ठीक है'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('लॉग आउट'),
        content: Text('क्या आप वाकई लॉग आउट करना चाहते हैं?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('रद्द करें'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/phone-otp-authentication',
                (route) => false,
              );
            },
            child: Text('लॉग आउट'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}