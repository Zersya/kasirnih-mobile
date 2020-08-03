import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/modules/splashscreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('id', 'ID')],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('id', 'ID'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const String kCompanyCode = "ks-bike";

  static final ColorScheme colorSchemeLight = ColorScheme.light(
    primary: const Color(0xFF035AA6),
    secondary: const Color(0xFF18a0fb),
    surface: Colors.white,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    brightness: Brightness.light,
  );

  static final TextTheme _textTheme = TextTheme(
    headline5: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.bold),
    headline6: GoogleFonts.poppins(fontSize: 18),
    subtitle1: GoogleFonts.poppins(fontSize: 14),
    subtitle2: GoogleFonts.poppins(color: Colors.grey[500]),
    bodyText1:
        GoogleFonts.poppins(fontSize: 16.0, color: colorSchemeLight.onSurface),
    bodyText2: GoogleFonts.poppins(fontSize: 12.0),
    overline: GoogleFonts.poppins(color: Colors.grey[500]),
    button: GoogleFonts.poppins(
        fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
  );

  final ThemeData themeData = ThemeData(
    colorScheme: colorSchemeLight,
    primaryColor: colorSchemeLight.primary,
    accentColor: colorSchemeLight.secondary,
    backgroundColor: colorSchemeLight.background,
    textTheme: _textTheme,
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    fontFamily: 'Roboto',
  );

  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KSBike',
      theme: themeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: RouterHelper.generateRoute,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      home: SplashScreen(),
    );
  }
}
