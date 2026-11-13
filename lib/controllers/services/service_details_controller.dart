import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/service/service_details_model.dart';
import '../../data/repositories/service_repository.dart';

class ServiceDetailsController extends GetxController {
  final ServiceRepository _repository;
  final int serviceId;

  ServiceDetailsController({
    required ServiceRepository repository,
    required this.serviceId,
  }) : _repository = repository;

  final RxBool isLoading = false.obs;

  final Rxn<ServiceDetailsModel> service = Rxn<ServiceDetailsModel>();

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServiceDetails();
  }

  Future<void> fetchServiceDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      service.value = await _repository.getServiceDetails(serviceId);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'حدث خطأ غير متوقع';
    } finally {
      isLoading.value = false;
    }
  }
}
