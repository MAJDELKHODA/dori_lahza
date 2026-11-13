import 'package:flutter/material.dart';

/// Brand palette derived from the place's `theme.primary_color`.
///
/// Places may choose very light colors (la7za uses `#94DDF0`), which fail
/// contrast as button backgrounds with white text. [strong] is the same hue
/// darkened until it reaches readable contrast on white, and is what buttons,
/// links and active states use; [brand] stays for decorative surfaces.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brand,
    required this.strong,
    required this.soft,
    required this.onStrong,
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.star,
  });

  factory AppPalette.fromBrand(Color brand) {
    final strong = _ensureContrast(brand, Colors.white, 4.5);
    return AppPalette(
      brand: brand,
      strong: strong,
      soft: Color.alphaBlend(brand.withValues(alpha: 0.16), Colors.white),
      onStrong: Colors.white,
      background: const Color(0xFFF5F7FA),
      surface: Colors.white,
      surfaceMuted: const Color(0xFFF0F3F7),
      border: const Color(0xFFE4E9F0),
      textPrimary: const Color(0xFF0F172A),
      textSecondary: const Color(0xFF526075),
      textMuted: const Color(0xFF8A96A8),
      success: const Color(0xFF0E9F6E),
      successSoft: const Color(0xFFE3F6EE),
      warning: const Color(0xFFC27803),
      warningSoft: const Color(0xFFFDF3DC),
      danger: const Color(0xFFDC2626),
      dangerSoft: const Color(0xFFFDE8E8),
      info: const Color(0xFF2563EB),
      infoSoft: const Color(0xFFE6EEFD),
      star: const Color(0xFFF5A524),
    );
  }

  static const fallbackBrand = Color(0xFF94DDF0);

  final Color brand;
  final Color strong;
  final Color soft;
  final Color onStrong;
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color star;

  /// Heatmap color for a busy level between 0 (quiet) and 1 (busy).
  Color heat(double level) {
    final t = level.clamp(0.0, 1.0);
    if (t == 0) return successSoft;
    return Color.lerp(const Color(0xFFB7EBD3), danger, t)!;
  }

  static Color _ensureContrast(Color color, Color against, double ratio) {
    var hsl = HSLColor.fromColor(color);
    var result = color;
    while (_contrast(result, against) < ratio && hsl.lightness > 0.05) {
      hsl = hsl.withLightness((hsl.lightness - 0.03).clamp(0.0, 1.0));
      hsl = hsl.withSaturation((hsl.saturation + 0.01).clamp(0.0, 1.0));
      result = hsl.toColor();
    }
    return result;
  }

  static double _contrast(Color a, Color b) {
    final la = a.computeLuminance() + 0.05;
    final lb = b.computeLuminance() + 0.05;
    return la > lb ? la / lb : lb / la;
  }

  /// Parses `#RRGGBB` / `#AARRGGBB`; returns null for anything else.
  static Color? parseHex(String? hex) {
    if (hex == null) return null;
    var value = hex.replaceFirst('#', '').trim();
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    return parsed == null ? null : Color(parsed);
  }

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) =>
      other is AppPalette && t > 0.5 ? other : this;
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
  TextTheme get text => Theme.of(this).textTheme;
}
