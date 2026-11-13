/// Defensive JSON readers.
///
/// The API is consumed with partial knowledge of some response shapes, so every
/// model reads through these helpers instead of hard casts: a missing or
/// differently-typed field degrades to a sensible default instead of crashing.
typedef Json = Map<String, dynamic>;

Json asJson(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
  return const {};
}

Json? asJsonOrNull(Object? value) => value is Map ? asJson(value) : null;

List<Object?> asList(Object? value) => value is List ? value : const [];

List<T> asListOf<T>(Object? value, T Function(Json json) parse) =>
    asList(value).whereType<Map<Object?, Object?>>().map((e) => parse(asJson(e))).toList();

String asString(Object? value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

String? asStringOrNull(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int asInt(Object? value, [int fallback = 0]) => asIntOrNull(value) ?? fallback;

int? asIntOrNull(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  return null;
}

double asDouble(Object? value, [double fallback = 0]) => asDoubleOrNull(value) ?? fallback;

double? asDoubleOrNull(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

bool asBool(Object? value, [bool fallback = false]) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final v = value.toLowerCase();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return fallback;
}

DateTime? asDateTimeOrNull(Object? value) =>
    value is String && value.isNotEmpty ? DateTime.tryParse(value)?.toLocal() : null;

List<String> asStringList(Object? value) =>
    asList(value).map((e) => asString(e)).where((e) => e.isNotEmpty).toList();
