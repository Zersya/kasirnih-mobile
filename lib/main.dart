import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/modules/auth/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    onPrimary: Colors.black87,
    onSecondary: Colors.black87,
    onSurface: Colors.black87,
    brightness: Brightness.light,
  );

  static final TextTheme _textTheme = TextTheme(
    headline5: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
    headline6: GoogleFonts.poppins(fontSize: 20),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KSBike',
      theme: themeData,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: RouterHelper.generateRoute,
      home: AuthScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
