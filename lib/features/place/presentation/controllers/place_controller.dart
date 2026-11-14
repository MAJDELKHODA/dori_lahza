import 'package:dori_lahza/core/error/failure.dart';
import 'package:dori_lahza/core/result/result.dart';
import 'package:dori_lahza/core/theme/app_palette.dart';
import 'package:dori_lahza/core/theme/app_theme.dart';
import 'package:dori_lahza/core/utils/formatters.dart';
import 'package:dori_lahza/features/place/domain/entities/place.dart';
import 'package:dori_lahza/features/place/domain/usecases/place_usecases.dart';
import 'package:get/get.dart';

/// App-wide holder of the place configuration. Loaded once at splash and read
/// by every screen for labels, currency, hours and booking rules.
class PlaceController extends GetxController {
  PlaceController({required PingServer pingServer, required GetPlace getPlace})
      : _ping = pingServer,
        _getPlace = getPlace;

  final PingServer _ping;
  final GetPlace _getPlace;

  final place = Rxn<Place>();

  Place get current => place.value!;
  bool get isLoaded => place.value != null;
  PlaceLabels get labels => place.value?.labels ?? const PlaceLabels();
  String get currencySymbol => place.value?.currencySymbol ?? '₪';
  BookingRules get rules => place.value?.booking ?? const BookingRules();

  String price(num amount) => Fmt.price(amount, currencySymbol);

  /// Pings the server, then loads the place and applies its brand color.
  Future<Result<Place>> load() async {
    final ping = await _ping();
    if (ping case FailureResult(:final failure)) return Result.failure(failure);
    final result = await _getPlace();
    result.fold((_) {}, _apply);
    return result;
  }

  /// Background refresh (e.g. pull to refresh on home); keeps the old value on failure.
  Future<Failure?> refreshPlace() async {
    final result = await _getPlace();
    return result.fold((f) => f, (p) {
      _apply(p);
      return null;
    });
  }

  void _apply(Place value) {
    place.value = value;
    final brand = AppPalette.parseHex(value.primaryColor) ?? AppPalette.fallbackBrand;
    Get.changeTheme(AppTheme.light(brand));
  }
}
