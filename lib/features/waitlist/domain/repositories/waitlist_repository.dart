import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/features/waitlist/domain/entities/waitlist_entry.dart';

abstract interface class WaitlistRepository {
  Future<Result<WaitlistEntry>> join(JoinWaitlistRequest request);

  Future<Result<List<WaitlistEntry>>> list({bool activeOnly = true});

  Future<Result<WaitlistEntry>> entry(int id);

  /// Turns the offer into a booking (returns its id when known); fails with
  /// `SLOT_TAKEN` if someone was faster.
  Future<Result<int?>> claim(int id);

  Future<Result<void>> leave(int id);
}
