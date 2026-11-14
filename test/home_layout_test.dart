import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:dori_lahza/features/home/presentation/widgets/home_sections.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/domain/repositories/place_repository.dart';
import 'package:dori_lahza/features/place/domain/usecases/place_usecases.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/services/presentation/widgets/service_cards.dart';
import 'package:dori_lahza/features/staff/presentation/widgets/staff_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Never called: cards only read the default currency symbol.
class _NoPlaceRepo implements PlaceRepository {
  @override
  Future<Result<Place>> getPlace() => throw UnimplementedError();

  @override
  Future<Result<void>> ping() => throw UnimplementedError();
}

/// Home strips have fixed heights; their tiles must fit at the largest text
/// scale the app allows (1.3, see `LahzaApp`).
void main() {
  setUp(() {
    final repo = _NoPlaceRepo();
    Get.put(PlaceController(pingServer: PingServer(repo), getPlace: GetPlace(repo)));
  });
  tearDown(Get.reset);

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

    testWidgets('service card fits the 252px strip at text scale $scale', (tester) async {
      await tester.pumpWidget(
        host(
          252,
          ServiceCard(
            service: const Service(
              id: 1,
              name: 'تصوير فوتوغرافي احترافي للمناسبات والحفلات',
              durationMinutes: 120,
              durationLabel: 'ساعتان',
              price: 2000,
              salePrice: 1600,
              finalPrice: 1600,
              discountPercent: 20,
              isGroup: true,
              capacity: 12,
            ),
            onTap: () {},
          ),
          scale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
