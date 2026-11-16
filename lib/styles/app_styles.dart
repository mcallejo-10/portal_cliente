import 'package:flutter/material.dart';

class AppStyles {
  // ==================== COLORS ====================

  /// Primary Colors (10% - Action components, FAB, active nav items, AI icon)
  static const Color primaryColor = Color(0xFF1461DC); // FacturIA Blue
  static const Color primaryLight = Color(0xFF2E78F3);
  static const Color primaryDark = Color(0xFF0D3FA8);

  /// Neutral Background (60%)
  static const Color backgroundLight = Color(0xFFF5F6FA);
  static const Color backgroundDefault = Color(0xFFFAFAFA);

  /// Surfaces & Cards (30%)
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F9FB);

  /// Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF111827);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  /// Semantic Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  /// Dividers & Borders
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color borderColor = Color(0xFFD1D5DB);

  /// Icon Colors
  static const Color iconPrimary = Color(0xFF000000);
  static const Color iconSecondary = Color(0xFF6B7280);
  static const Color iconDisabled = Color(0xFF9CA3AF);
  static const Color iconActive = Color(0xFF1461DC);
  static const Color iconBackground = Color.fromARGB(50, 20, 97, 220);

  // ==================== TYPOGRAPHY ====================

  static const String fontFamily = 'Sarabun';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: textPrimary,
    letterSpacing: -0.25,
  );

  static const TextStyle headingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: textPrimary,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: textPrimary,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle subheadingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textSecondary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: textTertiary,
  );

  /// Caption & Label Styles
  static const TextStyle captionStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: textTertiary,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.38,
    color: textPrimary,
    letterSpacing: 0.25,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: textSecondary,
    letterSpacing: 0.5,
  );

  // ==================== SEPARATORS ====================
  static final Widget tinySeparator = SizedBox(height: 4, width: 4);
  static final Widget smallSeparator = SizedBox(height: 8, width: 8);
  static final Widget mediumSeparator = SizedBox(height: 16, width: 16);
  static final Widget bigSeparator = SizedBox(height: 24, width: 24);

  // ==================== SPACING ====================

  /// Spacing scale (base: 4dp)
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;

  // ==================== BUTTON STYLES ====================

  /// Primary Button Style
  static const ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(primaryColor),
    foregroundColor: WidgetStatePropertyAll(surfaceWhite),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing12),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textStyle: WidgetStatePropertyAll(labelStyle),
  );

  /// Secondary Button Style
  static const ButtonStyle secondaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(backgroundLight),
    foregroundColor: WidgetStatePropertyAll(primaryColor),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing12),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    textStyle: WidgetStatePropertyAll(labelStyle),
  );

  // ==================== CARD STYLES ====================

  static const double cardBorderRadius = 12;
  static const double cardElevation = 1;

  /// Card Box Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceWhite,
    borderRadius: const BorderRadius.all(Radius.circular(cardBorderRadius)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ==================== ICON STYLES ====================
  /// Icon Size
  static const double iconSize = 28;

  /// Icon Button Padding
  static const double iconButtonPaddingVertical = 6;
  static const double iconButtonPaddingHorizontal = 20;
  static const double iconBottomBarBorderRadius = 24;
  static const double iconBorderRadius = 24;

  // ==================== INPUT FIELD STYLES ====================

  static const double inputBorderRadius = 8;

  /// Input Decoration Theme
  static InputDecoration inputDecoration(String labelText, {String? hintText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: labelStyle,
      hintStyle: bodySmall.copyWith(color: textLight),
      filled: true,
      fillColor: backgroundLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(inputBorderRadius),
        ),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(inputBorderRadius),
        ),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(inputBorderRadius),
        ),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(inputBorderRadius),
        ),
        borderSide: const BorderSide(color: errorColor),
      ),
    );
  }

  // ==================== THEME DATA ====================

  static ThemeData get appTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryLight,
        surface: surfaceWhite,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundDefault,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0.5,
        centerTitle: false,
        titleTextStyle: headingStyle,
      ),
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineSmall: headingStyle,
        titleLarge: subheadingStyle,
        titleMedium: subheadingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyStyle,
        bodySmall: bodySmall,
        labelLarge: labelStyle,
        labelSmall: labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButtonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(inputBorderRadius),
          ),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(inputBorderRadius),
          ),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(inputBorderRadius),
          ),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: surfaceWhite,
        elevation: cardElevation,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceWhite,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? iconActive
              : iconSecondary;
          return captionStyle.copyWith(color: color);
        }),
        indicatorColor: iconBackground,
        elevation: cardElevation,
      ),
    );
  }
}
