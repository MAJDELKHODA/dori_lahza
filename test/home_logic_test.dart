import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:dori_lahza/features/insights/domain/entities/busy_hours.dart';
import 'package:dori_lahza/features/insights/domain/repositories/insights_repository.dart';
import 'package:dori_lahza/features/insights/domain/usecases/get_busy_hours.dart';
import 'package:dori_lahza/features/insights/presentation/controllers/busy_hours_controller.dart';
import 'package:flutter_test/flutter_test.dart';

Booking _booking(int id, DateTime? start, BookingStatus status) => Booking(
      id: id,
      number: '$id',
      code: 'C$id',
      status: status,
      statusLabel: '',
      startsAt: start,
      dateLabel: '',
      dayLabel: '',
      time: '',
      durationMinutes: 30,
      serviceId: 1,
      serviceName: 'خدمة',
      price: 0,
      discount: 0,
      total: 0,
      currencySymbol: '₪',
      canCancel: false,
      canReschedule: false,
      canReview: false,
      cancelIsLate: false,
    );

class _NoInsights implements InsightsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Repo implements BookingsRepository {
  _Repo(this.items);
  final List<Booking> items;

  @override
  Future<Result<Paginated<Booking>>> list(BookingScope scope, {required int page}) async =>
      Result.success(Paginated(items: items, page: 1, lastPage: 1, total: items.length));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Fmt.until', () {
    final now = DateTime(2026, 11, 14, 10);
    test('minutes, hours, tomorrow, days', () {
      expect(Fmt.until(DateTime(2026, 11, 14, 10, 25), now: now), 'بعد 25 دقيقة');
      expect(Fmt.until(DateTime(2026, 11, 14, 11, 30), now: now), 'بعد ساعة');
      expect(Fmt.until(DateTime(2026, 11, 14, 15), now: now), 'بعد 5 ساعات');
      expect(Fmt.until(DateTime(2026, 11, 15, 9), now: now), 'غدًا');
      expect(Fmt.until(DateTime(2026, 11, 16, 9), now: now), 'بعد يومين');
      expect(Fmt.until(DateTime(2026, 11, 20, 9), now: now), 'بعد 6 أيام');
      expect(Fmt.until(DateTime(2026, 11, 14, 9), now: now), 'الآن');
    });
  });

  test('GetNextBooking picks the soonest active booking', () async {
    final repo = _Repo([
      _booking(1, DateTime(2026, 11, 20), BookingStatus.confirmed),
      _booking(2, DateTime(2026, 11, 15), BookingStatus.cancelled),
      _booking(3, DateTime(2026, 11, 16), BookingStatus.pending),
      _booking(4, null, BookingStatus.confirmed),
    ]);
    final next = (await GetNextBooking(repo)()).dataOrNull;
    expect(next?.id, 3);
  });

  test('GetNextBooking returns null when nothing is active', () async {
    final repo = _Repo([_booking(1, DateTime(2026, 11, 20), BookingStatus.completed)]);
    expect((await GetNextBooking(repo)()).dataOrNull, isNull);
  });

  test('Fmt.hour uses 12-hour Arabic markers', () {
    expect(Fmt.hour(9), '9 ص');
    expect(Fmt.hour(12), '12 م');
    expect(Fmt.hour(14), '2 م');
    expect(Fmt.hour(0), '12 ص');
  });

  group('BusyHoursController.extremes', () {
    final c = BusyHoursController(getBusyHours: GetBusyHours(_NoInsights()));

    test('quietest and busiest open hours', () {
      const day = BusyDay(day: 'sat', label: 'السبت', hours: [
        BusyHour(hour: 9, open: true, level: 0.2),
        BusyHour(hour: 10, open: true, level: 0),
        BusyHour(hour: 11, open: true, level: 0.9),
        BusyHour(hour: 12, open: false, level: 0),
      ]);
      final (:quiet, :peak) = c.extremes(day);
      expect(quiet?.hour, 10);
      expect(peak?.hour, 11);
    });

    test('flat or closed days have no peak', () {
      const flat = BusyDay(day: 'sun', label: 'الأحد', hours: [
        BusyHour(hour: 9, open: true, level: 0),
        BusyHour(hour: 10, open: true, level: 0),
      ]);
      expect(c.extremes(flat).peak, isNull);
      expect(c.extremes(const BusyDay(day: 'fri', label: 'الجمعة', hours: [])).quiet, isNull);
    });
  });
}
