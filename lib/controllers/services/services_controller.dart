import 'package:get/get.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/home/home_response.dart';
import '../../data/repositories/service_repository.dart';
import 'package:flutter/widgets.dart';

class ServicesController extends GetxController {
  final ServiceRepository _repository;

  ServicesController({required ServiceRepository repository})
    : _repository = repository;

  final RxList<HomeService> services = <HomeService>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'الكل'.obs;
  final RxString selectedSort = 'الأكثر طلبًا'.obs;

  List<String> get categories {
    final names = services
        .map((service) => service.categoryName ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    return ['الكل', ...names];
  }

  List<HomeService> get filteredServices {
    final query = searchQuery.value.trim();

    final result = services.where((service) {
      final matchesSearch =
          service.name.contains(query) || service.description.contains(query);

      final matchesCategory =
          selectedCategory.value == 'الكل' ||
          service.categoryName == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();

    switch (selectedSort.value) {
      case 'السعر: الأقل أولًا':
        result.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;

      case 'السعر: الأعلى أولًا':
        result.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;

      case 'الأقصر مدة':
        result.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;

      case 'الاسم':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;

      case 'الأكثر طلبًا':
        result.sort((a, b) => b.bookingsCount.compareTo(a.bookingsCount));
        break;
    }

    return result;
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchServices();
    });
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getServices();

      services.assignAll(result);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } catch (error) {
      errorMessage.value = 'حدث خطأ أثناء تحميل الخدمات';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String value) {
    searchQuery.value = value;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectSort(String sort) {
    selectedSort.value = sort;
  }
}
