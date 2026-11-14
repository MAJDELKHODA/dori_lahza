import 'package:dori_lahza/features/booking/domain/entities/availability.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';

/// What the user chose in the slot step, carried to the confirm step.
class BookingDraft {
  const BookingDraft({required this.service, required this.day, required this.slot, this.staffId, this.staffName});

  final Service service;
  final AvailabilityDay day;
  final Slot slot;
  final int? staffId;
  final String? staffName;

  BookingDraft withSlot(Slot value) =>
      BookingDraft(service: service, day: day, slot: value, staffId: staffId, staffName: staffName);
}
