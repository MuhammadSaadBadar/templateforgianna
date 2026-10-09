import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// Palette: dark espresso brown + white, with a white + brown light mode.
/// Change colours here to re-skin the whole site.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.tint,
    required this.line,
    required this.ink,
    required this.muted,
    required this.accent,
    required this.accentDark,
    required this.tan,
    required this.stage,
    required this.stageLine,
    required this.card,
  });

  final Color bg,
      tint,
      line,
      ink,
      muted,
      accent,
      accentDark,
      tan,
      stage,
      stageLine,
      card;

  /// Text colours used on the always-dark "stage" sections.
  static const onDark = Color(0xFFFBF7F3);
  static const onDarkMuted = Color(0xFFCDB9A9);

  static const dark = AppColors(
    bg: Color(0xFF150D09),
    tint: Color(0xFF1D130D),
    line: Color(0xFF35251A),
    ink: Color(0xFFFBF7F3),
    muted: Color(0xFFB9A596),
    accent: Color(0xFF8B5A3C),
    accentDark: Color(0xFF5A3420),
    tan: Color(0xFFD2A97F),
    stage: Color(0xFF1F140E),
    stageLine: Color(0xFF35251A),
    card: Color(0xFF21160F),
  );

  static const light = AppColors(
    bg: Color(0xFFFFFFFF),
    tint: Color(0xFFF7F1EB),
    line: Color(0xFFE7DACD),
    ink: Color(0xFF2B1A10),
    muted: Color(0xFF7A6354),
    accent: Color(0xFF7A4A2E),
    accentDark: Color(0xFF4E2D1B),
    tan: Color(0xFF7A4A2E),
    stage: Color(0xFF2A1A10),
    stageLine: Color(0xFF4A3426),
    card: Color(0xFF2A1A10),
  );

  LinearGradient get buttonGradient => LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bg: l(bg, other.bg),
      tint: l(tint, other.tint),
      line: l(line, other.line),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      accent: l(accent, other.accent),
      accentDark: l(accentDark, other.accentDark),
      tan: l(tan, other.tan),
      stage: l(stage, other.stage),
      stageLine: l(stageLine, other.stageLine),
      card: l(card, other.card),
    );
  }
}

class AppTheme {
  const AppTheme._();

  static ThemeData _build(Brightness brightness, AppColors c) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.accent,
        brightness: brightness,
      ).copyWith(surface: c.bg),
      extensions: [c],
    );
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(
        base.textTheme,
      ).apply(bodyColor: c.ink, displayColor: c.ink),
    );
  }

  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);
  static ThemeData get light => _build(Brightness.light, AppColors.light);
}

class ThemeController extends ChangeNotifier {
  ThemeMode mode = ThemeMode.light; // dark brown is the default
  void toggle() {
    mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

final themeController = ThemeController();

/// Responsive breakpoints used throughout the application
class Breakpoints {
  /// Extra small screens (smartphones)
  static const double xs = 480.0;

  /// Small screens (larger phones, small tablets in portrait)
  static const double sm = 640.0;

  /// Medium screens (tablets in landscape, small laptops)
  static const double md = 768.0;

  /// Large screens (laptops, desktops)
  static const double lg = 1024.0;

  /// Extra large screens (large desktop monitors)
  static const double xl = 1200.0;
}

extension BreakpointUtils on BuildContext {
  /// Get current screen width
  double get width => MediaQuery.sizeOf(this).width;
  double get w => MediaQuery.sizeOf(this).width;

  /// Get current screen height
  double get height => MediaQuery.sizeOf(this).height;
  double get h => MediaQuery.sizeOf(this).height;

  /// Get AppColors
  AppColors get c => Theme.of(this).extension<AppColors>()!;

  /// Check if the theme is dark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Check if screen is extra small (< 480px)
  bool get isXs => width < Breakpoints.xs;

  /// Check if screen is small (< 640px)
  bool get isSm => width < Breakpoints.sm;

  /// Check if screen is medium (< 768px)
  bool get isMd => width < Breakpoints.md;

  /// Check if screen is large (< 1024px)
  bool get isLg => width < Breakpoints.lg;

  /// Check if screen is extra large (>= 1200px)
  bool get isXl => width >= Breakpoints.xl;

  /// Check if screen is mobile (use same threshold as isSm for consistency)
  bool get isMobile => isSm;

  /// Check if screen is desktop (use same threshold as isLg for consistency)
  bool get isDesktop => isLg;

  /// Check if screen is tablet (between sm and md)
  bool get isTablet => isMd && !isSm;

  /// Get device category for use in responsive grids and layouts
  String get deviceCategory {
    if (isXl) return 'xl';
    if (isLg) return 'lg';
    if (isMd) return 'md';
    if (isSm) return 'sm';
    return 'xs';
  }
}

/// Headline style (Inter, tight tracking, like the reference).
TextStyle display(
  BuildContext context,
  double size, {
  Color? color,
  FontWeight weight = FontWeight.w500,
  bool italic = false,
  double height = 1.08,
}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    height: height,
    letterSpacing: -size * 0.035,
    color: color ?? context.c.ink,
  );
}

/// Serif headline style (Playfair Display) for elegant accents.
TextStyle displaySerif(
  BuildContext context,
  double size, {
  Color? color,
  FontWeight weight = FontWeight.w400,
  bool italic = false,
  double height = 1.08,
}) {
  return GoogleFonts.playfairDisplay(
    fontSize: size,
    fontWeight: weight,
    fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    height: height,
    letterSpacing: -size * 0.02,
    color: color ?? context.c.ink,
  );
}

TextStyle body(
  BuildContext context, {
  double size = 17,
  Color? color,
  FontWeight weight = FontWeight.w400,
  double height = 1.6,
}) {
  return GoogleFonts.inter(
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color ?? context.c.ink,
  );
}
