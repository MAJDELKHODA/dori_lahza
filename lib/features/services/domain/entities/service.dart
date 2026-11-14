import 'package:dori_lahza/shared/domain/entities/common.dart';

class Service {
  const Service({
    required this.id,
    required this.name,
    this.description,
    required this.durationMinutes,
    this.durationLabel,
    required this.price,
    this.salePrice,
    required this.finalPrice,
    this.discountPercent,
    this.capacity = 1,
    this.isGroup = false,
    this.image,
    this.thumb,
    this.gallery = const [],
    this.attributes = const [],
    this.isFeatured = false,
    this.bookingsCount = 0,
    this.category,
    this.staff = const [],
    this.rating = const RatingSummary(),
    this.related = const [],
  });

  final int id;
  final String name;
  final String? description;
  final int durationMinutes;
  final String? durationLabel;
  final double price;
  final double? salePrice;
  final double finalPrice;
  final int? discountPercent;

  /// Seats per slot for group sessions.
  final int capacity;
  final bool isGroup;
  final String? image;
  final String? thumb;
  final List<String> gallery;

  /// `attributes_display`: label/value pairs set by the place.
  final List<ServiceAttribute> attributes;
  final bool isFeatured;
  final int bookingsCount;
  final CategoryBrief? category;

  /// Who can provide this service.
  final List<StaffBrief> staff;
  final RatingSummary rating;

  /// Only filled by the details endpoint.
  final List<Service> related;

  bool get hasDiscount => salePrice != null && finalPrice < price;
}

class ServiceAttribute {
  const ServiceAttribute({required this.label, required this.value});
  final String label;
  final String value;
}

class CategoryBrief {
  const CategoryBrief({required this.id, required this.name, this.icon});
  final int id;
  final String name;
  final String? icon;
}

class Category {
  const Category({required this.id, required this.name, this.icon, this.image, this.servicesCount = 0});

  final int id;
  final String name;
  final String? icon;
  final String? image;
  final int servicesCount;
}

enum ServiceSort {
  order('order', 'الافتراضي'),
  popular('popular', 'الأكثر طلبًا'),
  rating('rating', 'الأعلى تقييمًا'),
  priceAsc('price', 'السعر: الأقل أولًا', ascending: true),
  priceDesc('price', 'السعر: الأعلى أولًا', ascending: false),
  duration('duration', 'المدة: الأقصر أولًا', ascending: true),
  name('name', 'الاسم');

  const ServiceSort(this.apiValue, this.label, {this.ascending});

  final String apiValue;
  final String label;

  /// null leaves `order` to the server default.
  final bool? ascending;
}

/// Query of `GET /services`. Every field is optional.
class ServiceFilter {
  const ServiceFilter({
    this.query = '',
    this.categoryId,
    this.staffId,
    this.maxDuration,
    this.featuredOnly = false,
    this.groupOnly = false,
    this.sort = ServiceSort.order,
  });

  final String query;
  final int? categoryId;
  final int? staffId;
  final int? maxDuration;
  final bool featuredOnly;
  final bool groupOnly;
  final ServiceSort sort;

  /// Number of filters set besides search text and category (for the badge).
  int get activeCount =>
      [staffId != null, maxDuration != null, featuredOnly, groupOnly, sort != ServiceSort.order]
          .where((e) => e)
          .length;

  ServiceFilter copyWith({
    String? query,
    int? Function()? categoryId,
    int? Function()? staffId,
    int? Function()? maxDuration,
    bool? featuredOnly,
    bool? groupOnly,
    ServiceSort? sort,
  }) =>
      ServiceFilter(
        query: query ?? this.query,
        categoryId: categoryId != null ? categoryId() : this.categoryId,
        staffId: staffId != null ? staffId() : this.staffId,
        maxDuration: maxDuration != null ? maxDuration() : this.maxDuration,
        featuredOnly: featuredOnly ?? this.featuredOnly,
        groupOnly: groupOnly ?? this.groupOnly,
        sort: sort ?? this.sort,
      );

  ServiceFilter clearAdvanced() => ServiceFilter(query: query, categoryId: categoryId);
}
