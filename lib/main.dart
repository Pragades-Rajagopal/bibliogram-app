import 'package:bibliogram_app/presentations/user_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromRGBO(86, 80, 14, 171),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.poppins(fontSize: 22.0),
          bodyMedium: GoogleFonts.poppins(fontSize: 22.0),
          bodySmall: GoogleFonts.poppins(fontSize: 22.0),
          titleLarge: GoogleFonts.poppins(fontSize: 22.0),
          titleSmall: GoogleFonts.poppins(fontSize: 22.0),
          titleMedium: GoogleFonts.poppins(fontSize: 22.0),
          labelLarge: GoogleFonts.poppins(fontSize: 22.0),
          labelSmall: GoogleFonts.poppins(fontSize: 22.0),
          labelMedium: GoogleFonts.poppins(fontSize: 22.0),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}