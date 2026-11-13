class HomeResponse {
  final List<HomeBanner> banners;
  final List<HomeCategory> categories;
  final List<HomeService> featured;
  final List<HomeService> popular;
  final List<HomeStaff> staff;

  HomeResponse({
    required this.banners,
    required this.categories,
    required this.featured,
    required this.popular,
    required this.staff,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return HomeResponse(
      banners: (data['banners'] as List? ?? [])
          .map((e) => HomeBanner.fromJson(e))
          .toList(),

      categories: (data['categories'] as List? ?? [])
          .map((e) => HomeCategory.fromJson(e))
          .toList(),

      featured: (data['featured'] as List? ?? [])
          .map((e) => HomeService.fromJson(e))
          .toList(),

      popular: (data['popular'] as List? ?? [])
          .map((e) => HomeService.fromJson(e))
          .toList(),

      staff: (data['staff'] as List? ?? [])
          .map((e) => HomeStaff.fromJson(e))
          .toList(),
    );
  }
}

class HomeBanner {
  final int id;
  final String? title;
  final String image;
  final String? linkType;
  final String? linkName;

  HomeBanner.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      image = json['image'] ?? '',
      linkType = json['link_type'],
      linkName = json['link_name'];
}

class HomeCategory {
  final int id;
  final String name;
  final String? icon;
  final String? image;
  final int servicesCount;

  HomeCategory.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'] ?? '',
      icon = json['icon'],
      image = json['image'],
      servicesCount = json['services_count'] ?? 0;
}

class HomeService {
  final int id;
  final String name;
  final String description;
  final String? image;
  final String durationLabel;
  final double price;
  final double finalPrice;
  final double? salePrice;
  final int? discountPercent;
  final String? categoryName;
  final List<HomeStaff> staff;
  final int bookingsCount;
  final int durationMinutes;

  HomeService.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'] ?? '',
      durationMinutes = json['duration_minutes'] ?? 0,
      description = json['description'] ?? '',
      image = json['image'],
      durationLabel = json['duration_label'] ?? '',
      bookingsCount = json['bookings_count'] ?? 0,
      price = (json['price'] as num? ?? 0).toDouble(),
      finalPrice = (json['final_price'] as num? ?? 0).toDouble(),
      salePrice = (json['sale_price'] as num?)?.toDouble(),
      discountPercent = json['discount_percent'] as int?,
      categoryName = json['category']?['name'],
      staff = (json['staff'] as List? ?? [])
          .map((e) => HomeStaff.fromJson(e))
          .toList();
}

class HomeStaff {
  final int id;
  final String name;
  final String title;
  final String? avatar;

  HomeStaff.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'] ?? '',
      title = json['title'] ?? '',
      avatar = json['avatar'];
}
