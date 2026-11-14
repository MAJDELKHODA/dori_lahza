import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/state/view_state.dart';
import 'package:dori_lahza/features/auth/presentation/controllers/session_controller.dart';
import 'package:dori_lahza/features/bookings/domain/entities/booking.dart';
import 'package:dori_lahza/features/bookings/domain/usecases/bookings_usecases.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/home/domain/usecases/get_home_feed.dart';
import 'package:dori_lahza/features/place/presentation/controllers/place_controller.dart';
import 'package:dori_lahza/features/services/presentation/controllers/services_controller.dart';
import 'package:dori_lahza/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  HomeController({
    required GetHomeFeed getHomeFeed,
    required GetNextBooking getNextBooking,
    required PlaceController place,
    required SessionController session,
    required ShellController shell,
  })  : _getFeed = getHomeFeed,
        _getNextBooking = getNextBooking,
        _place = place,
        _session = session,
        _shell = shell;

  final GetHomeFeed _getFeed;
  final GetNextBooking _getNextBooking;
  final PlaceController _place;
  final SessionController _session;
  final ShellController _shell;

  final state = Rx<ViewState<HomeFeed>>(const ViewLoading());

  /// Soonest upcoming booking of the signed-in user; null for guests or none.
  final nextBooking = Rxn<Booking>();

  final _workers = <Worker>[];

  bool get queueEnabled => _place.place.value?.queueEnabled ?? false;

  @override
  void onInit() {
    super.onInit();
    _workers
      ..add(ever(_session.user, (_) => unawaited(loadNextBooking())))
      // Bookings change on other tabs/pages; refresh when coming back home.
      ..add(ever(_shell.current, (tab) {
        if (tab == ShellTab.home) unawaited(loadNextBooking());
      }));
  }

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    final (feed, _) = await (_getFeed(), loadNextBooking()).wait;
    state.value = ViewState.fromResult(feed);
  }

  /// Pull to refresh: feed, place info (open now, hours) and next booking.
  Future<void> refreshFeed() async {
    final (feed, _, _) = await (_getFeed(), _place.refreshPlace(), loadNextBooking()).wait;
    // Keep showing the old feed if the refresh fails.
    if (feed.isSuccess || state.value is! ViewSuccess) state.value = ViewState.fromResult(feed);
  }

  Future<void> loadNextBooking() async {
    if (!_session.isSignedIn) {
      nextBooking.value = null;
      return;
    }
    final result = await _getNextBooking();
    // Keep the last known booking on a transient failure.
    result.fold((_) {}, (booking) => nextBooking.value = booking);
  }

  void openNextBooking() {
    final booking = nextBooking.value;
    if (booking != null) AppNav.bookingDetails(booking.id, initial: booking);
  }

  void openSearch() => _openServices(focusSearch: true);

  void openCategory(int categoryId) => _openServices(categoryId: categoryId);

  void openAllServices() => _openServices();

  void openQueue() => _shell.open(ShellTab.queue);

  void openBusyHours() => AppNav.busyHours();

  void openTeam() => AppNav.team();

  void openPlaceInfo() => AppNav.placeInfo();

  void openNotifications() => AppNav.notifications();

  Future<void> openBanner(HomeBanner banner) async {
    final id = banner.linkId;
    switch (banner.linkType) {
      case BannerLink.service when id != null:
        await AppNav.serviceDetails(id);
      case BannerLink.category when id != null:
        openCategory(id);
      case BannerLink.staff when id != null:
        await AppNav.staffProfile(id);
      case BannerLink.url when banner.url != null:
        final uri = Uri.tryParse(banner.url!);
        if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
      default:
        break;
    }
  }

  void _openServices({int? categoryId, bool focusSearch = false}) {
    _shell.open(ShellTab.services);
    final services = Get.find<ServicesController>();
    if (categoryId != null) {
      services.selectCategory(categoryId);
    } else if (!focusSearch) {
      services.selectCategory(null);
    }
    if (focusSearch) services.requestSearchFocus();
  }

  @override
  void onClose() {
    for (final w in _workers) {
      w.dispose();
    }
    super.onClose();
  }
}
