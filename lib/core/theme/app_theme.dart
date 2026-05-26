import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Navy / Baby Blue Palette
  static const Color primaryNavy = Color(0xFF1E3A8A); // Deep Navy
  static const Color accentBabyBlue = Color(0xFF89CFF0); // Bright Baby Blue
  static const Color backgroundLight = Color(0xFFF8FAFC); // Very light greyish blue
  static const Color surfaceWhite = Colors.white;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryNavy,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentBabyBlue,
      primary: primaryNavy,
      secondary: accentBabyBlue,
      surface: surfaceWhite,
      background: backgroundLight,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: const Color(0xFF1E293B),
      displayColor: const Color(0xFF0F172A),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: backgroundLight,
      foregroundColor: primaryNavy,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        color: primaryNavy,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: primaryNavy),
    ),
    cardTheme: CardThemeData(
      color: surfaceWhite,
      elevation: 8,
      shadowColor: accentBabyBlue.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: accentBabyBlue.withOpacity(0.1),
      disabledColor: Colors.grey.shade100,
      selectedColor: primaryNavy,
      secondarySelectedColor: primaryNavy,
      labelStyle: const TextStyle(color: primaryNavy, fontWeight: FontWeight.w500),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.transparent),
      ),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        shadowColor: primaryNavy.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentBabyBlue,
      foregroundColor: primaryNavy,
      elevation: 4,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceWhite,
      indicatorColor: accentBabyBlue.withOpacity(0.3),
      elevation: 16,
      shadowColor: primaryNavy.withOpacity(0.1),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: primaryNavy,
          );
        }
        return GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade600,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: primaryNavy, size: 26);
        }
        return IconThemeData(color: Colors.grey.shade500, size: 24);
      }),
    ),
  );
}
