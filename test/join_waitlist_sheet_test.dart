import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';
import 'package:dori_lahza/features/waitlist/domain/repositories/waitlist_repository.dart';
import 'package:dori_lahza/features/waitlist/domain/usecases/waitlist_usecases.dart';
import 'package:dori_lahza/features/waitlist/presentation/controllers/join_waitlist_controller.dart';
import 'package:dori_lahza/features/waitlist/presentation/widgets/join_waitlist_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _JoinOnlyRepo implements WaitlistRepository {
  JoinWaitlistRequest? sent;

  @override
  Future<Result<WaitlistEntry>> join(JoinWaitlistRequest request) async {
    sent = request;
    return Success(
      WaitlistEntry(id: 1, status: WaitlistStatus.waiting, serviceId: 3, serviceName: 'قص', date: request.date),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Regression: deleting the sheet's controller as soon as the sheet's future
/// completes used to dispose the notes field mid close-animation, flashing a
/// red error screen before the waitlist page opened.
void main() {
  tearDown(Get.reset);

  testWidgets('submitting closes the sheet with true and no error frame', (tester) async {
    final repo = _JoinOnlyRepo();
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light(AppPalette.fallbackBrand),
        home: const Scaffold(body: SizedBox()),
      ),
    );

    const tag = 'join-waitlist';
    final controller = Get.put(
      JoinWaitlistController(serviceId: 3, date: '2026-11-15', joinWaitlist: JoinWaitlist(repo)),
      tag: tag,
    );
    bool? joined;
    final sheet = Get.bottomSheet<bool>(
      JoinWaitlistSheet(controller: controller, serviceName: 'قص', dayLabel: 'الأحد'),
      isScrollControlled: true,
    ).then((value) async {
      joined = value;
      await Get.delete<JoinWaitlistController>(tag: tag);
    });
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '  بعد الدوام ');
    await tester.tap(find.text('انضم لقائمة الانتظار'));
    // Step through the close animation frame by frame.
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.takeException(), isNull);
    }
    await sheet;
    await tester.pumpAndSettle();

    expect(joined, isTrue);
    expect(repo.sent?.notes, 'بعد الدوام');
    expect(find.byType(JoinWaitlistSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
