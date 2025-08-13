import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation with spring effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    // Background gradient animation
    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xFFFFA726),
      end: AppTheme.lightTheme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _logoAnimationController.forward();
    _backgroundAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style for splash
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks with real-world timing
      await Future.wait([
        _checkLanguagePreferences(),
        _loadOfflineDatabase(),
        _fetchSchemeUpdates(),
        _prepareCachedContent(),
      ]);

      // Minimum splash display time for branding
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _initializationStatus = 'Loading offline content...';
        });
        // Fallback to offline mode after brief delay
        await Future.delayed(const Duration(milliseconds: 1000));
        _navigateToNextScreen();
      }
    }
  }

  Future<void> _checkLanguagePreferences() async {
    setState(() {
      _initializationStatus = 'Checking language preferences...';
    });
    // Simulate checking stored language preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadOfflineDatabase() async {
    setState(() {
      _initializationStatus = 'Loading scheme database...';
    });
    // Simulate loading SQLite database
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _fetchSchemeUpdates() async {
    setState(() {
      _initializationStatus = 'Fetching latest schemes...';
    });
    // Simulate network call for scheme updates
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _prepareCachedContent() async {
    setState(() {
      _initializationStatus = 'Preparing content...';
    });
    // Simulate preparing multilingual content packs
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _navigateToNextScreen() {
    // Navigation logic based on user state
    // For demo purposes, we'll check if it's first time user
    final bool isFirstTimeUser = _checkIfFirstTimeUser();
    final bool hasUserProgress = _checkUserProgress();

    String nextRoute;
    if (isFirstTimeUser) {
      nextRoute = '/language-selection';
    } else if (hasUserProgress) {
      nextRoute = '/home-dashboard';
    } else {
      nextRoute = '/home-dashboard'; // Default to home for try mode
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  bool _checkIfFirstTimeUser() {
    // Simulate checking if user has completed onboarding
    // In real app, this would check SharedPreferences or secure storage
    return false; // For demo, assume returning user
  }

  bool _checkUserProgress() {
    // Simulate checking if user has saved progress
    // In real app, this would check local database
    return true; // For demo, assume user has progress
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoAnimationController,
          _backgroundAnimationController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundColorAnimation.value ??
                      AppTheme.lightTheme.primaryColor,
                  const Color(0xFFFFA726),
                  const Color(0xFFFFB74D),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content to center
                  const Spacer(flex: 2),

                  // Logo section with animation
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: _buildLogo(),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // App name with government backing
                  FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'SolarMitra',
                          style: AppTheme.lightTheme.textTheme.headlineLarge
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Government of India Initiative',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Loading indicator and status
                  if (_isInitializing) ...[
                    _buildLoadingIndicator(),
                    SizedBox(height: 2.h),
                    Text(
                      _initializationStatus,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  SizedBox(height: 4.h),

                  // Government branding
                  _buildGovernmentBranding(),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Solar panel icon background
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.primaryColor,
                  const Color(0xFFFFA726),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // Solar panel icon
          CustomIconWidget(
            iconName: 'solar_power',
            color: Colors.white,
            size: 12.w,
          ),
          // Sun rays effect
          Positioned.fill(
            child: CustomPaint(
              painter: SunRaysPainter(
                color: Colors.white.withValues(alpha: 0.3),
                animation: _logoAnimationController,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 8.w,
      height: 8.w,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildGovernmentBranding() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Government of India emblem placeholder
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'account_balance',
                color: Colors.white,
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Ministry of New and\nRenewable Energy',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 10.sp,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Empowering Rural India with Solar Energy',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 9.sp,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Custom painter for sun rays effect around logo
class SunRaysPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  SunRaysPainter({
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rayLength = 8.0;

    // Draw 8 sun rays around the logo
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startRadius = radius + 5;
      final endRadius = startRadius + rayLength * animation.value;

      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + endRadius * math.cos(angle);
      final endY = center.dy + endRadius * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}