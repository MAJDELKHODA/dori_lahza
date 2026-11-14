import 'package:intl/intl.dart';

/// Display formatting shared by all features. Call
/// `initializeDateFormatting('ar')` once at startup (done in `main`).
abstract final class Fmt {
  static const locale = 'ar';

  /// `150 ₪` — drops `.0` for whole amounts.
  static String price(num amount, String symbol) {
    final text = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(2);
    return '$text $symbol';
  }

  /// `45 دقيقة`, `1 س 30 د`.
  static String minutes(int minutes) {
    if (minutes < 60) return '$minutes دقيقة';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h ${h == 1 ? 'ساعة' : 'ساعات'}' : '$h س $m د';
  }

  /// `السبت 14 نوفمبر`.
  static String dayMonth(DateTime date) => DateFormat('EEEE d MMMM', locale).format(date);

  /// `14 نوفمبر 2026`.
  static String fullDate(DateTime date) => DateFormat('d MMMM y', locale).format(date);

  /// `14 نوف`.
  static String shortDate(DateTime date) => DateFormat('d MMM', locale).format(date);

  /// `9:30 ص`.
  static String time(DateTime date) => DateFormat('h:mm a', locale).format(date);

  /// `2026-11-14` for API query parameters.
  static String apiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  /// `منذ 5 دقائق`, `أمس`, or a short date for older items.
  static String relative(DateTime date, {DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(date);
    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} د';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} س';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return shortDate(date);
  }

  /// Time left until a future moment: `بعد 25 دقيقة`, `بعد 3 ساعات`, `غدًا`, `بعد 4 أيام`.
  static String until(DateTime date, {DateTime? now}) {
    final from = now ?? DateTime.now();
    final diff = date.difference(from);
    if (diff.isNegative || diff.inMinutes < 1) return 'الآن';
    if (diff.inMinutes < 60) return 'بعد ${diff.inMinutes} دقيقة';
    final today = DateTime(from.year, from.month, from.day);
    final days = DateTime(date.year, date.month, date.day).difference(today).inDays;
    if (days == 0) return diff.inHours == 1 ? 'بعد ساعة' : 'بعد ${diff.inHours} ساعات';
    if (days == 1) return 'غدًا';
    if (days == 2) return 'بعد يومين';
    return 'بعد $days أيام';
  }

  /// Hour of day as `9 ص` / `2 م`.
  static String hour(int hour) {
    final h = hour % 24;
    final twelve = h % 12 == 0 ? 12 : h % 12;
    return '$twelve ${h < 12 ? 'ص' : 'م'}';
  }

  /// `02:45` countdown.
  static String countdown(int seconds) {
    final s = seconds < 0 ? 0 : seconds;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  /// `5.0`.
  static String rating(double value) => value.toStringAsFixed(1);
}
