import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _Result {
  const _Result(this.value);
  final int value;
}

void main() {
  tearDown(Get.reset);

  Widget app() => GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const Text('home')),
          GetPage(
            name: '/pick',
            page: () => TextButton(
              onPressed: () => Get.back(result: const _Result(7)),
              child: const Text('pick'),
            ),
          ),
        ],
      );

  testWidgets('typed Get.toNamed fails to open a GetX page (the original bug)', (tester) async {
    await tester.pumpWidget(app());
    expect(() => Get.toNamed<_Result>('/pick'), throwsA(isA<TypeError>()));
    await tester.pumpAndSettle();
    expect(find.text('pick'), findsNothing);
  });

  testWidgets('AppNav.pushForResult opens the page and returns the typed result', (tester) async {
    await tester.pumpWidget(app());
    _Result? result;
    unawaited(AppNav.pushForResult<_Result>('/pick').then((r) => result = r));
    await tester.pumpAndSettle();
    expect(find.text('pick'), findsOneWidget);

    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();
    expect(result?.value, 7);
  });
}
