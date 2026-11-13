import 'package:dori_lahza/core/utils/json.dart';

/// One page of a list endpoint, built from `data` + `meta`.
class Paginated<T> {
  const Paginated({
    required this.items,
    required this.page,
    required this.lastPage,
    required this.total,
    this.meta = const {},
  });

  factory Paginated.fromResponse(List<T> items, Json meta) {
    final page = asInt(meta['page'] ?? meta['current_page'], 1);
    return Paginated(
      items: items,
      page: page,
      lastPage: asInt(meta['last_page'], page),
      total: asInt(meta['total'], items.length),
      meta: meta,
    );
  }

  final List<T> items;
  final int page;
  final int lastPage;
  final int total;

  /// The raw `meta`, for endpoint-specific extras (e.g. review `distribution`).
  final Json meta;

  bool get hasMore => page < lastPage;
}
