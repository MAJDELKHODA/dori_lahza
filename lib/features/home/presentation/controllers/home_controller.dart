import 'dart:async';

import 'package:dori_lahza/app/routes/app_nav.dart';
import 'package:dori_lahza/core/state/view_state.dart';
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
    required PlaceController place,
    required ShellController shell,
  })  : _getFeed = getHomeFeed,
        _place = place,
        _shell = shell;

  final GetHomeFeed _getFeed;
  final PlaceController _place;
  final ShellController _shell;

  final state = Rx<ViewState<HomeFeed>>(const ViewLoading());

  @override
  void onReady() {
    super.onReady();
    unawaited(load());
  }

  Future<void> load() async {
    state.value = const ViewLoading();
    state.value = ViewState.fromResult(await _getFeed());
  }

  /// Pull to refresh: home feed and place info (open now, hours) together.
  Future<void> refreshFeed() async {
    final (feed, _) = await (_getFeed(), _place.refreshPlace()).wait;
    // Keep showing the old feed if the refresh fails.
    if (feed.isSuccess || state.value is! ViewSuccess) state.value = ViewState.fromResult(feed);
  }

  void openSearch() => _openServices(focusSearch: true);

  void openCategory(int categoryId) => _openServices(categoryId: categoryId);

  void openAllServices() => _openServices();

  void openQueue() => _shell.open(ShellTab.queue);

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
}
