import 'package:get/get.dart';

import '../../data/models/home/home_response.dart';
import '../../data/repositories/home_repository.dart';
import '../../core/network/api_exceptions.dart';

class HomeController extends GetxController {
  final HomeRepository _repository;

  HomeController({required HomeRepository repository})
    : _repository = repository;

  final RxBool isLoading = false.obs;

  final Rxn<HomeResponse> homeData = Rxn<HomeResponse>();

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _repository.getHomeData();

      homeData.value = response;
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'حدث خطأ غير متوقع';
    } finally {
      isLoading.value = false;
    }
  }
}
