import 'package:dori_lahza/features/queue/domain/entities/queue.dart';
import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/features/services/domain/entities/service.dart';
import 'package:dori_lahza/features/staff/domain/entities/staff_member.dart';

/// Everything the home screen shows, from a single `GET /home`.
class HomeFeed {
  const HomeFeed({
    required this.banners,
    required this.categories,
    required this.featured,
    required this.popular,
    required this.staff,
    required this.latestReviews,
    this.queue,
  });

  final List<HomeBanner> banners;
  final List<Category> categories;
  final List<Service> featured;
  final List<Service> popular;
  final List<StaffMember> staff;
  final List<Review> latestReviews;

  /// Live-queue status, or null when the queue is off.
  final QueueBoard? queue;
}

enum BannerLink { service, category, staff, url, none }

class HomeBanner {
  const HomeBanner({required this.id, this.title, this.image, required this.linkType, this.linkId, this.linkName, this.url});

  final int id;
  final String? title;
  final String? image;
  final BannerLink linkType;
  final int? linkId;
  final String? linkName;
  final String? url;
}
