import 'package:flutter/material.dart';
import '../presentation/language_selection/language_selection.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/government_schemes_list/government_schemes_list.dart';
import '../presentation/scheme_details/scheme_details.dart';
import '../presentation/rooftop_solar_calculator/rooftop_solar_calculator.dart';
import '../presentation/phone_otp_authentication/phone_otp_authentication.dart';
import '../presentation/enhanced_eligibility_checker/enhanced_eligibility_checker.dart';
import '../presentation/site_survey_tool/site_survey_tool.dart';
import '../presentation/application_form/application_form.dart';
import '../presentation/installer_marketplace/installer_marketplace.dart';
import '../presentation/profile/profile.dart';

class AppRoutes {
  static const String initial = '/';
  static const String languageSelection = '/language-selection';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String governmentSchemesList = '/government-schemes-list';
  static const String schemeDetails = '/scheme-details';
  static const String rooftopSolarCalculator = '/rooftop-solar-calculator';
  static const String phoneOtpAuthentication = '/phone-otp-authentication';
  static const String enhancedEligibilityChecker =
      '/enhanced-eligibility-checker';
  static const String siteSurveyTool = '/site-survey-tool';
  static const String applicationForm = '/application-form';
  static const String installerMarketplace = '/installer-marketplace';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    languageSelection: (context) => const LanguageSelection(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    governmentSchemesList: (context) => const GovernmentSchemesList(),
    schemeDetails: (context) => const SchemeDetails(),
    rooftopSolarCalculator: (context) => const RooftopSolarCalculator(),
    phoneOtpAuthentication: (context) => const PhoneOtpAuthentication(),
    enhancedEligibilityChecker: (context) => const EnhancedEligibilityChecker(),
    siteSurveyTool: (context) => SiteSurveyTool(),
    applicationForm: (context) => const ApplicationForm(),
    installerMarketplace: (context) => const InstallerMarketplace(),
    profile: (context) => const Profile(),
  };
}