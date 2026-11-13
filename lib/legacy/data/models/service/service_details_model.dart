import '../home/home_response.dart';

class ServiceDetailsModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final int durationMinutes;
  final String durationLabel;
  final double price;
  final double finalPrice;
  final double? salePrice;
  final int? discountPercent;
  final String? image;
  final List<ServiceImage> images;
  final int categoryId;
  final String categoryName;
  final List<HomeStaff> staff;
  final double ratingAverage;
  final int ratingCount;
  final List<HomeService> related;
  final int capacity;
  final bool isGroup;

  ServiceDetailsModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.durationMinutes,
    required this.durationLabel,
    required this.price,
    required this.finalPrice,
    required this.salePrice,
    required this.discountPercent,
    required this.image,
    required this.images,
    required this.categoryId,
    required this.categoryName,
    required this.staff,
    required this.ratingAverage,
    required this.ratingCount,
    required this.related,
    required this.capacity,
    required this.isGroup,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map? ?? {};
    final rating = json['rating'] as Map? ?? {};

    return ServiceDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      durationLabel: json['duration_label'] ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      finalPrice: (json['final_price'] as num? ?? 0).toDouble(),
      salePrice: (json['sale_price'] as num?)?.toDouble(),
      discountPercent: json['discount_percent'] as int?,
      image: json['image'],
      images: (json['images'] as List? ?? [])
          .map((item) => ServiceImage.fromJson(item))
          .toList(),
      categoryId: json['category_id'] ?? 0,
      categoryName: category['name']?.toString() ?? '',
      staff: (json['staff'] as List? ?? [])
          .map((item) => HomeStaff.fromJson(item))
          .toList(),
      ratingAverage: (rating['average'] as num? ?? 0).toDouble(),
      ratingCount: rating['count'] ?? 0,
      related: (json['related'] as List? ?? [])
          .map((item) => HomeService.fromJson(item))
          .toList(),
      capacity: json['capacity'] ?? 1,
      isGroup: json['is_group'] ?? false,
    );
  }

  factory ServiceDetailsModel.fromResponse(Map<String, dynamic> json) {
    if (json['success'] != true || json['data'] is! Map) {
      throw FormatException(json['message']?.toString() ?? 'Invalid response');
    }

    return ServiceDetailsModel.fromJson(
      Map<String, dynamic>.from(json['data']),
    );
  }
}

class ServiceImage {
  final String path;
  final String url;
  final String? thumb;

  ServiceImage({required this.path, required this.url, this.thumb});

  factory ServiceImage.fromJson(Map<String, dynamic> json) {
    return ServiceImage(
      path: json['path'] ?? '',
      url: json['url'] ?? '',
      thumb: json['thumb'],
    );
  }
}
