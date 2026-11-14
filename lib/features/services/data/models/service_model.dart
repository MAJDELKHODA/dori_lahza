import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/shared/data/models/common_models.dart';

abstract final class ServiceModel {
  static Service fromJson(Json json) {
    final category = asJsonOrNull(json['category']);
    final price = asDouble(json['price']);
    return Service(
      id: asInt(json['id']),
      name: asString(json['name']),
      description: asStringOrNull(json['description']),
      durationMinutes: asInt(json['duration_minutes']),
      durationLabel: asStringOrNull(json['duration_label']),
      price: price,
      salePrice: asDoubleOrNull(json['sale_price']),
      finalPrice: asDouble(json['final_price'], price),
      discountPercent: asIntOrNull(json['discount_percent']),
      capacity: asInt(json['capacity'], 1),
      isGroup: asBool(json['is_group']),
      image: asStringOrNull(json['image']),
      thumb: asStringOrNull(json['thumb']),
      gallery: asList(json['images'])
          .map((e) => e is Map ? asString(asJson(e)['url']) : asString(e))
          .where((e) => e.isNotEmpty)
          .toList(),
      attributes: asList(json['attributes_display']).map(_attribute).whereType<ServiceAttribute>().toList(),
      isFeatured: asBool(json['is_featured']),
      bookingsCount: asInt(json['bookings_count']),
      category: category == null
          ? null
          : CategoryBrief(
              id: asInt(category['id']),
              name: asString(category['name']),
              icon: asStringOrNull(category['icon']),
            ),
      staff: CommonMappers.staffList(json['staff']),
      rating: CommonMappers.rating(json['rating']),
      related: asListOf(json['related'], fromJson),
    );
  }

  static ServiceAttribute? _attribute(Object? value) {
    if (value is Map) {
      final json = asJson(value);
      final label = asString(json['label'] ?? json['name'] ?? json['key']);
      final v = asString(json['value'] ?? json['display']);
      return label.isEmpty && v.isEmpty ? null : ServiceAttribute(label: label, value: v);
    }
    final text = asString(value);
    return text.isEmpty ? null : ServiceAttribute(label: '', value: text);
  }

  static Category categoryFromJson(Json json) => Category(
        id: asInt(json['id']),
        name: asString(json['name']),
        icon: asStringOrNull(json['icon']),
        image: asStringOrNull(json['image']),
        servicesCount: asInt(json['services_count']),
      );

  static Map<String, Object?> filterToQuery(ServiceFilter f, {required int page, int perPage = 15}) => {
        'q': f.query.trim(),
        'category_id': f.categoryId,
        'staff_id': f.staffId,
        'max_duration': f.maxDuration,
        if (f.featuredOnly) 'featured': 1,
        if (f.groupOnly) 'group': 1,
        if (f.sort != ServiceSort.order) 'sort': f.sort.apiValue,
        if (f.sort.ascending != null) 'order': f.sort.ascending! ? 'asc' : 'desc',
        'page': page,
        'per_page': perPage,
      };
}
