import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/network/app_exception.dart';
import 'package:dori_lahza/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:dori_lahza/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:dori_lahza/features/booking/domain/entities/booking_failures.dart';
import 'package:dori_lahza/features/booking/domain/repositories/booking_repository.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/notifications/domain/entities/app_notification.dart';
import 'package:dori_lahza/features/notifications/domain/usecases/resolve_app_link.dart';
import 'package:dori_lahza/features/place/data/models/place_model.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

/// Data source stub that fails every booking with SLOT_UNAVAILABLE.
class _SlotTakenSource implements BookingRemoteDataSource {
  @override
  Future<Booking> create(NewBooking b) async => throw const AppException(
        message: 'سبقك أحد إلى هذا الوقت',
        code: ErrorCodes.slotUnavailable,
        statusCode: 409,
        details: {
          'alternatives': [
            {'time': '10:30', 'starts_at': '2026-11-14T10:30:00+02:00', 'staff': []},
            '2026-11-14T11:00:00+02:00',
          ],
        },
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('ResolveAppLink', () {
    const resolve = ResolveAppLink();

    test('booking, waitlist and queue paths', () {
      expect(resolve('bookings/12'), isA<BookingLink>().having((l) => l.id, 'id', 12));
      expect(resolve('/waitlist/5'), isA<WaitlistEntryLink>().having((l) => l.id, 'id', 5));
      expect(resolve('waitlist'), isA<WaitlistLink>());
      expect(resolve('queue'), isA<QueueLink>());
      expect(resolve('bookings'), isA<MyBookingsLink>());
    });

    test('ignores prefixes and unknown paths', () {
      expect(resolve('https://dori.toldpath.com/places/la7za/bookings/3'), isA<BookingLink>());
      expect(resolve('settings'), isNull);
      expect(resolve(null), isNull);
    });
  });

  test('SLOT_UNAVAILABLE carries the alternatives', () async {
    final repo = BookingRepositoryImpl(_SlotTakenSource());
    final result = await repo.create(const NewBooking(serviceId: 1, startsAt: '2026-11-14T10:00:00+02:00'));
    final failure = result.failureOrNull;
    expect(failure, isA<SlotUnavailableFailure>());
    final alternatives = (failure! as SlotUnavailableFailure).alternatives;
    expect(alternatives.map((s) => s.time), ['10:30', '11:00']);
  });

  test('place labels and intake fields parse with defaults', () {
    final place = PlaceModel.fromJson({
      'id': 33,
      'name': 'la7za',
      'labels': {'staff': 'مصففة'},
      'theme': {'primary_color': '#94DDF0'},
      'booking': {
        'cancel_before_hours': 2,
        'intake_fields': [
          {'key': 'age', 'label': 'العمر', 'type': 'number', 'required': true},
          {'name': 'gender', 'label': 'الجنس', 'type': 'select', 'options': ['ذكر', 'أنثى']},
        ],
      },
    });
    expect(place.labels.staff, 'مصففة');
    expect(place.labels.servicePlural, 'الخدمات');
    expect(place.booking.cancelBeforeHours, 2);
    expect(place.booking.intakeFields.first.type, IntakeFieldType.number);
    expect(place.booking.intakeFields.last.options.map((o) => o.value), ['ذكر', 'أنثى']);
  });
}
