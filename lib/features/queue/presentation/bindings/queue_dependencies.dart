import 'package:dori_lahza/features/queue/domain/repositories/queue_repository.dart';
import 'package:dori_lahza/features/queue/domain/usecases/queue_usecases.dart';
import 'package:dori_lahza/features/queue/presentation/controllers/queue_controller.dart';
import 'package:get/get.dart';

abstract final class QueueDependencies {
  /// The live-queue tab controller (lives with the shell).
  static void registerTab() => Get.lazyPut(
        () {
          final repo = Get.find<QueueRepository>();
          return QueueController(
            getBoard: GetQueueBoard(repo),
            getMyTicket: GetMyTicket(repo),
            takeTicket: TakeQueueTicket(repo),
            cancelTicket: CancelQueueTicket(repo),
            session: Get.find(),
            shell: Get.find(),
          );
        },
        fenix: true,
      );
}
