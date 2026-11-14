import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';
import 'package:dori_lahza/features/insights/domain/usecases/get_busy_hours.dart';
import 'package:dori_lahza/features/insights/presentation/controllers/busy_hours_controller.dart';
import 'package:dori_lahza/features/insights/presentation/views/busy_hours_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// A day whose busiest hour is at level 1.0 (the case that overflowed by 1px).
class _Repo implements InsightsRepository {
  @override
  Future<Result<BusyHours>> busyHours() async {
    const hours = [
      BusyHour(hour: 9, open: true, level: 0),
      BusyHour(hour: 10, open: true, level: 0.2),
      BusyHour(hour: 14, open: true, level: 1),
      BusyHour(hour: 15, open: true, level: 0.5),
    ];
    return const Result.success(
      BusyHours(
        fromHour: 9,
        toHour: 15,
        days: [
          BusyDay(day: 'sat', label: 'السبت', hours: hours),
          BusyDay(day: 'sun', label: 'الأحد', hours: hours),
          BusyDay(day: 'mon', label: 'الاثنين', hours: hours),
          BusyDay(day: 'tue', label: 'الثلاثاء', hours: hours),
          BusyDay(day: 'wed', label: 'الأربعاء', hours: hours),
          BusyDay(day: 'thu', label: 'الخميس', hours: hours),
          BusyDay(day: 'fri', label: 'الجمعة', hours: hours),
        ],
        bestTimes: [BestTime(day: 'sat', dayLabel: 'السبت', time: '09:00', level: 0)],
        now: BusyNow(open: true, level: 0.5, label: 'ازدحام متوسط'),
      ),
    );
  }
}

void main() {
  tearDown(Get.reset);

  for (final scale in [1.0, 1.3]) {
    testWidgets('day chart does not overflow at the busiest hour, text scale $scale', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      Get.put(BusyHoursController(getBusyHours: GetBusyHours(_Repo())));
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light(AppPalette.fallbackBrand),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQueryData(size: const Size(375, 812), textScaler: TextScaler.linear(scale)),
              child: const BusyHoursView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('ازدحام متوسط'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
