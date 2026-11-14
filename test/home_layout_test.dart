import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_sections.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Home strips have fixed heights; their tiles must fit at the largest text
/// scale the app allows (1.3, see `LahzaApp`).
void main() {
  Widget host(double height, Widget child, {double scale = 1.3}) => MaterialApp(
        theme: AppTheme.light(AppPalette.fallbackBrand),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Scaffold(body: Center(child: SizedBox(height: height, child: child))),
          ),
        ),
      );

  for (final scale in [1.0, 1.3]) {
    testWidgets('category tile fits the 112px strip at text scale $scale', (tester) async {
      await tester.pumpWidget(
        host(
          112,
          CategoryTile(
            category: const Category(id: 1, name: 'ديكور وتنسيق الحفلات والمناسبات الخاصة', icon: 'sparkles'),
            onTap: () {},
          ),
          scale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('staff bubble fits the 124px strip at text scale $scale', (tester) async {
      await tester.pumpWidget(
        host(
          124,
          StaffBubble(name: 'محمد نبيل', title: 'منسّق ديكور ومناسبات', initials: 'من', onTap: () {}),
          scale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
