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
