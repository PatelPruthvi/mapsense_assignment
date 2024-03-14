import 'package:assignment_mapsense/views/map_view/ui/map_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MapSense',
      theme: ThemeData(
          fontFamily: GoogleFonts.varelaRound().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
          useMaterial3: true,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.teal.shade900,
              foregroundColor: Colors.white),
          appBarTheme: AppBarTheme(
              centerTitle: false,
              backgroundColor: Colors.teal.shade900,
              titleTextStyle: TextStyle(
                  fontSize: 24,
                  letterSpacing: 1.3,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.varelaRound().fontFamily))),
      home: const MapView(),
    );
  }
}
