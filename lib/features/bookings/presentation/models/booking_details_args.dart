import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';

/// Route argument of the booking details page.
class BookingDetailsArgs {
  const BookingDetailsArgs(this.id, {this.initial, this.justCreated = false});

  final int id;

  /// Shown immediately while the full details load.
  final Booking? initial;

  /// Shows the "booked" success header.
  final bool justCreated;
}
