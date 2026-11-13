import 'package:dori_lahza/core/theme/app_dimens.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds the app theme around the place brand color, with IBM Plex Sans
/// Arabic for all text.
abstract final class AppTheme {
  static const fontFamily = 'Plex';

  static ThemeData light(Color brand) {
    final p = AppPalette.fromBrand(brand);
    final scheme = ColorScheme.fromSeed(seedColor: p.strong).copyWith(
      primary: p.strong,
      onPrimary: p.onStrong,
      primaryContainer: p.soft,
      onPrimaryContainer: p.strong,
      secondary: p.brand,
      surface: p.surface,
      onSurface: p.textPrimary,
      onSurfaceVariant: p.textSecondary,
      outline: p.border,
      outlineVariant: p.border,
      error: p.danger,
    );

    final text = _textTheme(p);
    const fieldBorder = OutlineInputBorder(borderRadius: Radii.field);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: p.background,
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleMedium,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: Radii.card, side: BorderSide(color: p.border)),
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: Gap.md, vertical: 15),
        hintStyle: text.bodyMedium?.copyWith(color: p.textMuted),
        labelStyle: text.bodyMedium?.copyWith(color: p.textSecondary),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: p.strong),
        errorStyle: text.bodySmall?.copyWith(color: p.danger),
        prefixIconColor: p.textMuted,
        suffixIconColor: p.textMuted,
        border: fieldBorder.copyWith(borderSide: BorderSide(color: p.border)),
        enabledBorder: fieldBorder.copyWith(borderSide: BorderSide(color: p.border)),
        focusedBorder: fieldBorder.copyWith(borderSide: BorderSide(color: p.strong, width: 1.6)),
        errorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: p.danger)),
        focusedErrorBorder: fieldBorder.copyWith(borderSide: BorderSide(color: p.danger, width: 1.6)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.strong,
          foregroundColor: p.onStrong,
          disabledBackgroundColor: p.border,
          disabledForegroundColor: p.textMuted,
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(borderRadius: Radii.field),
          textStyle: text.titleSmall,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textPrimary,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: p.border),
          shape: const RoundedRectangleBorder(borderRadius: Radii.field),
          textStyle: text.titleSmall,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.strong, textStyle: text.labelLarge),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.soft,
        side: BorderSide(color: p.border),
        labelStyle: text.labelMedium,
        shape: const StadiumBorder(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: Gap.xs, vertical: Gap.xxs),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
        showDragHandle: true,
        dragHandleColor: p.border,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.lg)),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyMedium?.copyWith(color: p.textSecondary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: p.soft,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected) ? p.strong : p.textMuted,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? p.strong : p.textMuted,
            size: 24,
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.strong,
        unselectedLabelColor: p.textSecondary,
        labelStyle: text.titleSmall,
        unselectedLabelStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        indicatorColor: p.strong,
        dividerColor: p.border,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.textPrimary,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.md)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.strong),
    );
  }

  static TextTheme _textTheme(AppPalette p) {
    TextStyle s(double size, FontWeight weight, {Color? color, double height = 1.45}) =>
        TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: weight,
          height: height,
          color: color ?? p.textPrimary,
        );

    return TextTheme(
      displaySmall: s(30, FontWeight.w700, height: 1.25),
      headlineMedium: s(26, FontWeight.w700, height: 1.3),
      headlineSmall: s(22, FontWeight.w700, height: 1.3),
      titleLarge: s(19, FontWeight.w700),
      titleMedium: s(17, FontWeight.w700),
      titleSmall: s(15, FontWeight.w600),
      bodyLarge: s(16, FontWeight.w400),
      bodyMedium: s(14, FontWeight.w400),
      bodySmall: s(12.5, FontWeight.w400, color: p.textSecondary),
      labelLarge: s(14, FontWeight.w600),
      labelMedium: s(13, FontWeight.w500),
      labelSmall: s(11.5, FontWeight.w500, color: p.textSecondary),
    );
  }
}
