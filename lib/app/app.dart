import 'package:dori_lahza/app/bindings/initial_binding.dart';
import 'package:dori_lahza/app/routes/app_pages.dart';
import 'package:dori_lahza/app/routes/app_routes.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

class LahzaApp extends StatelessWidget {
  const LahzaApp({super.key});

  static const _locale = Locale('ar');

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'لحظة',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      fallbackLocale: _locale,
      supportedLocales: const [_locale],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Replaced by the place brand color once `GET /places/{slug}` loads.
      theme: AppTheme.light(AppPalette.fallbackBrand),
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.native,
      // Keep text readable without breaking layouts on very large settings.
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(textScaler: media.textScaler.clamp(maxScaleFactor: 1.3)),
          child: child!,
        );
      },
    );
  }
}
