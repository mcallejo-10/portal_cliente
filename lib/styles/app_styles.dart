import 'package:flutter/material.dart';

class AppStyles {
  // ==================== COLORS ====================

  /// Primary Colors (10% - Action components, FAB, active nav items, AI icon)
  static const Color primaryColor = Color(0xFF1461DC); // FacturIA Blue
  static const Color primaryLight = Color(0xFF2E78F3);
  static const Color primaryDark = Color(0xFF0D3FA8);

  /// Neutral Background (60%)
  static const Color backgroundLight = Color(0xFFF5F6FA);
  static const Color backgroundDefault = Color.fromARGB(255, 248, 246, 246);
  static const Color backgroundError = Color(0xFFFFDAD6);

  /// Surfaces & Cards (30%)
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGrey = Color(0xFFF8F9FB);
  static const Color surfaceBlue = Color(0xFFD6E6FF);
  static const Color inputFillColor = Color(0xFFEEF0F5);

  /// Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF111827);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  /// Semantic Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFF93000A);
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
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: textPrimary,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
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
    color: textTertiary,
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
    fontSize: 15,
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
    fontWeight: FontWeight.w400,
    height: 1.38,
    color: textSecondary,
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

  static const TextStyle titleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle blueTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: primaryColor,
  );

  /// Subtitle shown under the app title (login / activate account)
  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: textSecondary,
  );

  /// Label placed above a form field
  static const TextStyle fieldLabelStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  /// Text typed inside a form field
  static const TextStyle inputTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: textSecondary,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle linkStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: primaryColor,
  );

  // ==================== SEPARATORS ====================
  static final Widget tinySeparator = SizedBox(height: 4, width: 4);
  static final Widget smallSeparator = SizedBox(height: 8, width: 8);
  static final Widget mediumSeparator = SizedBox(height: 16, width: 16);
  static final Widget bigSeparator = SizedBox(height: 48, width: 48);

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

  static const double buttonHeight = 48;
  static const double buttonBorderRadius = 2;
  static const double buttonIconSize = 20;

  /// Primary Button Style
  static const ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(primaryColor),
    foregroundColor: WidgetStatePropertyAll(surfaceWhite),
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing12),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius)),
      ),
    ),
    textStyle: WidgetStatePropertyAll(buttonTextStyle),
  );

  /// Link Button Style (text-only actions such as "¿Has olvidado tu contraseña?")
  static const ButtonStyle linkButtonStyle = ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(primaryColor),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: spacing12, vertical: spacing8),
    ),
    minimumSize: WidgetStatePropertyAll(Size(0, 36)),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: WidgetStatePropertyAll(linkStyle),
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

  static const ButtonStyle logOutButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(backgroundError),
    foregroundColor: WidgetStatePropertyAll(errorColor),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: spacing24, vertical: spacing12),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius)),
      ),
    ),
    textStyle: WidgetStatePropertyAll(buttonTextStyle),
  );

  // ==================== CARD STYLES ====================

  static const double cardBorderRadius = 4;
  static const double cardElevation = 1;
  static const Color cardShadowColor = Color(0x33000000);
  static const EdgeInsets cardContentPadding = EdgeInsets.all(spacing20);
  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(cardBorderRadius)),
  );
  static const double cardMargin = 8;
  static const EdgeInsets padding = EdgeInsets.all(cardMargin);

  // ==================== ICON STYLES ====================
  /// Icon Size
  static const double iconSize = 28;

  /// Icon Button Padding
  static const double iconButtonPaddingVertical = 6;
  static const double iconButtonPaddingHorizontal = 20;
  static const double iconBottomBarBorderRadius = 24;
  static const double iconBorderRadius = 24;

  // ==================== IMAGE STYLES ====================

  static const double appBarLogoHeight = 36;
  static const double appBarLogoWidth = 36;
  static const double loginScreenLogoHeight = 44;
  static const double loginScreenLogoWidth = 44;
  static const double splashScreenLogoHeight = 180;
  static const double splashScreenLogoWidth = 180;
  static const double loginScreenLogoShape = 64;

  // ==================== APP BAR ====================

  static const double appBarHeight = 64;

  /// Small uppercase text above the screen title ("PORTAL CLIENTE")
  static const TextStyle appBarOverlineStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: textTertiary,
    letterSpacing: 0.8,
  );

  static const TextStyle appBarTitleStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.25,
    color: textPrimary,
  );

  // ==================== AVATAR ====================

  static const double avatarSize = 36;
  static const Color avatarBackground = primaryColor;

  /// Initials shown in the avatar when the user has no photo
  static const TextStyle avatarInitialsStyle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1,
    color: surfaceWhite,
    letterSpacing: 0.5,
  );

  // ==================== AUTH SCREENS (login / activate account) ====================

  /// Max width of the content column so it does not stretch on tablets / web
  static const double authContentMaxWidth = 420;
  static const EdgeInsets authScreenPadding = EdgeInsets.symmetric(
    horizontal: spacing24,
    vertical: spacing32,
  );
  static const double authFooterIconSize = 16;

  // ==================== INPUT FIELD STYLES ====================

  /// Pill-shaped fields: the radius is larger than half the field height
  static const double inputBorderRadius = 28;
  static const double inputIconSize = 20;

  static OutlineInputBorder _inputBorder([BorderSide side = BorderSide.none]) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(inputBorderRadius)),
      borderSide: side,
    );
  }

  /// Input Decoration: filled pill without border, optional leading icon and
  /// trailing widget (e.g. the show/hide password button).
  /// The field label goes above the field using [fieldLabelStyle].
  static InputDecoration inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: inputTextStyle.copyWith(color: textLight),
      errorStyle: bodySmall.copyWith(color: errorColor),
      errorMaxLines: 2,
      filled: true,
      fillColor: inputFillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      prefixIcon: prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: spacing16, right: spacing8),
              child: Icon(prefixIcon, size: inputIconSize),
            ),
      prefixIconConstraints: const BoxConstraints(minHeight: buttonHeight),
      prefixIconColor: textSecondary,
      suffixIcon: suffixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: spacing4),
              child: suffixIcon,
            ),
      suffixIconColor: textSecondary,
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(
        const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: _inputBorder(const BorderSide(color: errorColor)),
      focusedErrorBorder: _inputBorder(
        const BorderSide(color: errorColor, width: 1.5),
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
      textButtonTheme: TextButtonThemeData(style: linkButtonStyle),
      checkboxTheme: const CheckboxThemeData(
        shape: CircleBorder(),
        side: BorderSide(color: borderColor, width: 1.5),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          const BorderSide(color: primaryColor, width: 1.5),
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

  static Null get cardBoxDecoration => null;
}
