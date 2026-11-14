import 'package:dori_lahza/features/waitlist/domain/repositories/waitlist_repository.dart';
import 'package:dori_lahza/features/waitlist/domain/usecases/waitlist_usecases.dart';
import 'package:dori_lahza/features/waitlist/presentation/controllers/waitlist_controllers.dart';
import 'package:get/get.dart';

class WaitlistBinding extends Bindings {
  @override
  void dependencies() {
    final repo = Get.find<WaitlistRepository>();
    Get.lazyPut(() => WaitlistController(getMyWaitlist: GetMyWaitlist(repo), leaveWaitlist: LeaveWaitlist(repo)));
  }
}

class WaitlistEntryBinding extends Bindings {
  WaitlistEntryBinding(this.entryId);

  final int entryId;

  @override
  void dependencies() {
    final repo = Get.find<WaitlistRepository>();
    Get.lazyPut(
      () => WaitlistEntryController(
        entryId: entryId,
        getEntry: GetWaitlistEntry(repo),
        claimOffer: ClaimWaitlistOffer(repo),
        leaveWaitlist: LeaveWaitlist(repo),
      ),
      tag: '$entryId',
    );
  }
}
