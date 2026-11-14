import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/features/booking/domain/entities/availability.dart';

/// `SLOT_UNAVAILABLE`: someone booked the time first. Carries nearby
/// alternatives from `error.details.alternatives`.
class SlotUnavailableFailure extends Failure {
  SlotUnavailableFailure(Failure base, this.alternatives)
      : super(
          message: base.message,
          code: base.code,
          statusCode: base.statusCode,
          details: base.details,
        );

  final List<Slot> alternatives;
}
