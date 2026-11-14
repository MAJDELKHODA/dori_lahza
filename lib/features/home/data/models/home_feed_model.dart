import 'package:dori_lahza/core/utils/json.dart';
import 'package:dori_lahza/features/home/domain/entities/home_feed.dart';
import 'package:dori_lahza/features/queue/data/models/queue_model.dart';
import 'package:dori_lahza/features/reviews/data/models/review_model.dart';
import 'package:dori_lahza/features/services/data/models/service_model.dart';
import 'package:dori_lahza/features/staff/data/models/staff_model.dart';

abstract final class HomeFeedModel {
  static HomeFeed fromJson(Json json) {
    final queue = asJsonOrNull(json['queue']);
    return HomeFeed(
      banners: asListOf(json['banners'], _banner),
      categories: asListOf(json['categories'], ServiceModel.categoryFromJson),
      featured: asListOf(json['featured'], ServiceModel.fromJson),
      popular: asListOf(json['popular'], ServiceModel.fromJson),
      staff: asListOf(json['staff'], StaffModel.fromJson),
      latestReviews: asListOf(json['latest_reviews'], ReviewModel.fromJson),
      queue: queue == null ? null : QueueModel.boardFromJson(queue),
    );
  }

  static HomeBanner _banner(Json json) => HomeBanner(
        id: asInt(json['id']),
        title: asStringOrNull(json['title']),
        image: asStringOrNull(json['image']),
        linkType: switch (asString(json['link_type'])) {
          'service' => BannerLink.service,
          'category' => BannerLink.category,
          'staff' => BannerLink.staff,
          'url' || 'link' => BannerLink.url,
          _ => BannerLink.none,
        },
        linkId: asIntOrNull(json['link_id']),
        linkName: asStringOrNull(json['link_name']),
        url: asStringOrNull(json['url'] ?? json['link_url']),
      );
}
