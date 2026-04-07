import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs principales - Style Premium Noir & Doré
  static const Color primaryBlack = Color(0xFF000000);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFF4E5C2);
  static const Color darkGold = Color(0xFFB8941F);

  // Couleurs secondaires
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F8F8);
  static const Color darkGray = Color(0xFF2C2C2C);
  static const Color mediumGray = Color(0xFF666666);
  static const Color lightGray = Color(0xFFE0E0E0);

  // Couleurs de statut
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE74C3C);
  static const Color warningOrange = Color(0xFFFF9800);

  // Thème principal (Dark Mode Premium)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,

      // Couleurs de base
      colorScheme: const ColorScheme.dark(
        primary: accentGold,
        secondary: lightGold,
        surface: darkGray,
        background: primaryBlack,
        error: errorRed,
        onPrimary: primaryBlack,
        onSecondary: primaryBlack,
        onSurface: pureWhite,
        onBackground: pureWhite,
        surfaceVariant: Color(0xFF1A1A1A),
        outline: mediumGray,
      ),

      // Typographie
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        // Headings
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: pureWhite,
          letterSpacing: -0.25,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: pureWhite,
        ),

        // Body text
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: pureWhite,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: pureWhite,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: mediumGray,
          height: 1.3,
        ),

        // Labels
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: pureWhite,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: pureWhite,
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: pureWhite,
        ),
        iconTheme: const IconThemeData(color: pureWhite, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: darkGray,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: primaryBlack,
          elevation: 4,
          shadowColor: accentGold.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentGold,
          side: const BorderSide(color: accentGold, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentGold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mediumGray.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        labelStyle: GoogleFonts.inter(color: mediumGray, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: mediumGray, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryBlack,
        selectedItemColor: accentGold,
        unselectedItemColor: mediumGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: pureWhite, size: 24),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: mediumGray.withOpacity(0.2),
        thickness: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkGray,
        selectedColor: accentGold.withOpacity(0.2),
        disabledColor: primaryBlack,
        labelStyle: const TextStyle(color: pureWhite),
        secondaryLabelStyle: const TextStyle(color: accentGold),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
          side: BorderSide(color: mediumGray.withOpacity(0.3)),
        ),
      ),

      // Badge Theme
      badgeTheme: BadgeThemeData(
        backgroundColor: errorRed,
        textColor: pureWhite,
        smallSize: 8,
        largeSize: 16,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: accentGold,
        inactiveTrackColor: mediumGray.withOpacity(0.3),
        thumbColor: accentGold,
        overlayColor: accentGold.withOpacity(0.2),
        valueIndicatorColor: accentGold,
        valueIndicatorTextStyle: const TextStyle(
          color: primaryBlack,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: darkGray,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: pureWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: GoogleFonts.inter(color: pureWhite, fontSize: 16),
      ),
    );
  }

  // Gradients pour effets premium
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blackGradient = LinearGradient(
    colors: [primaryBlack, darkGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows pour effet depth
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get goldShadow => [
    BoxShadow(
      color: accentGold.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Espacements standardisés
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius standardisés
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;

  // Durées d'animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
}
