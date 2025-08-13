import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/continue_button_widget.dart';
import './widgets/language_card_widget.dart';
import './widgets/language_header_widget.dart';
import './widgets/loading_overlay_widget.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection>
    with TickerProviderStateMixin {
  String? selectedLanguageCode;
  bool isLoading = false;
  bool isDownloading = false;
  double downloadProgress = 0.0;
  late AnimationController _celebrationController;
  late Animation<double> _celebrationAnimation;

  // Mock language data with native scripts and regional illustrations
  final List<Map<String, dynamic>> availableLanguages = [
    {
      'code': 'hi',
      'nativeName': 'हिंदी',
      'englishName': 'Hindi',
      'flag': '🇮🇳',
      'audioUrl': 'https://example.com/audio/hindi.mp3',
      'contentPackSize': '12.5 MB',
      'isDownloaded': true,
    },
    {
      'code': 'te',
      'nativeName': 'తెలుగు',
      'englishName': 'Telugu',
      'flag': '🏛️',
      'audioUrl': 'https://example.com/audio/telugu.mp3',
      'contentPackSize': '11.8 MB',
      'isDownloaded': false,
    },
    {
      'code': 'ta',
      'nativeName': 'தமிழ்',
      'englishName': 'Tamil',
      'flag': '🏺',
      'audioUrl': 'https://example.com/audio/tamil.mp3',
      'contentPackSize': '13.2 MB',
      'isDownloaded': false,
    },
    {
      'code': 'kn',
      'nativeName': 'ಕನ್ನಡ',
      'englishName': 'Kannada',
      'flag': '🎭',
      'audioUrl': 'https://example.com/audio/kannada.mp3',
      'contentPackSize': '10.9 MB',
      'isDownloaded': false,
    },
    {
      'code': 'mr',
      'nativeName': 'मराठी',
      'englishName': 'Marathi',
      'flag': '⛰️',
      'audioUrl': 'https://example.com/audio/marathi.mp3',
      'contentPackSize': '12.1 MB',
      'isDownloaded': false,
    },
    {
      'code': 'bn',
      'nativeName': 'বাংলা',
      'englishName': 'Bengali',
      'flag': '🐅',
      'audioUrl': 'https://example.com/audio/bengali.mp3',
      'contentPackSize': '14.3 MB',
      'isDownloaded': false,
    },
    {
      'code': 'en',
      'nativeName': 'English',
      'englishName': 'English',
      'flag': '🌍',
      'audioUrl': 'https://example.com/audio/english.mp3',
      'contentPackSize': '8.7 MB',
      'isDownloaded': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    // Set default language to Hindi if available
    if (availableLanguages.isNotEmpty) {
      selectedLanguageCode = 'hi';
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void _selectLanguage(String languageCode) {
    setState(() {
      selectedLanguageCode = languageCode;
    });

    HapticFeedback.selectionClick();

    // Show selection feedback
    final selectedLanguage = availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
    );

    Fluttertoast.showToast(
      msg: '${selectedLanguage['nativeName']} selected',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _playLanguageAudio(String languageCode) {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
    );

    // Mock audio playback - in real implementation, use audio player
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: 'Playing ${language['nativeName']} pronunciation',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
      fontSize: 12.sp,
    );
  }

  Future<void> _downloadContentPack(String languageCode) async {
    final language = availableLanguages.firstWhere(
      (lang) => lang['code'] == languageCode,
    );

    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
    });

    // Simulate content pack download with progress
    for (int i = 0; i <= 100; i += 5) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        downloadProgress = i / 100.0;
      });
    }

    // Mark as downloaded
    language['isDownloaded'] = true;

    setState(() {
      isDownloading = false;
      downloadProgress = 0.0;
    });

    // Show success message
    Fluttertoast.showToast(
      msg: '${language['nativeName']} content downloaded successfully!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  Future<void> _continueWithSelectedLanguage() async {
    if (selectedLanguageCode == null) return;

    final selectedLanguage = availableLanguages.firstWhere(
      (lang) => lang['code'] == selectedLanguageCode,
    );

    setState(() {
      isLoading = true;
    });

    // Check if content pack needs to be downloaded
    if (!(selectedLanguage['isDownloaded'] as bool)) {
      await _downloadContentPack(selectedLanguageCode!);
    }

    // Simulate language switching and content loading
    await Future.delayed(Duration(milliseconds: 1500));

    // Trigger celebration animation
    _celebrationController.forward();

    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      isLoading = false;
    });

    // Navigate to home dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-dashboard',
      (route) => false,
    );
  }

  Future<void> _refreshLanguagePacks() async {
    // Simulate server refresh
    await Future.delayed(Duration(milliseconds: 1500));

    Fluttertoast.showToast(
      msg: 'Language packs updated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  void _handleBackNavigation() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/splash-screen',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                LanguageHeaderWidget(
                  title: 'Select Language / भाषा चुनें',
                  onBackPressed: canGoBack ? _handleBackNavigation : null,
                ),

                // Language list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshLanguagePacks,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      itemCount: availableLanguages.length,
                      itemBuilder: (context, index) {
                        final language = availableLanguages[index];
                        final isSelected =
                            selectedLanguageCode == language['code'];

                        return LanguageCardWidget(
                          language: language,
                          isSelected: isSelected,
                          onTap: () =>
                              _selectLanguage(language['code'] as String),
                          onAudioPlay: () =>
                              _playLanguageAudio(language['code'] as String),
                        );
                      },
                    ),
                  ),
                ),

                // Continue button
                ContinueButtonWidget(
                  isEnabled: selectedLanguageCode != null,
                  isLoading: isLoading,
                  buttonText: 'Continue / जारी रखें',
                  onPressed: _continueWithSelectedLanguage,
                ),
              ],
            ),
          ),

          // Loading overlay for content download
          LoadingOverlayWidget(
            isVisible: isDownloading,
            loadingText:
                'Downloading language content...\nकृपया प्रतीक्षा करें',
            progress: downloadProgress,
          ),

          // Celebration animation overlay
          AnimatedBuilder(
            animation: _celebrationAnimation,
            builder: (context, child) {
              return _celebrationAnimation.value > 0
                  ? Container(
                      color: Colors.black
                          .withValues(alpha: 0.3 * _celebrationAnimation.value),
                      child: Center(
                        child: Transform.scale(
                          scale: _celebrationAnimation.value,
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: CustomIconWidget(
                              iconName: 'check',
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
