import 'package:dori_lahza/core/pagination/paginated.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';

class Review {
  const Review({
    required this.id,
    required this.rating,
    this.comment,
    required this.authorName,
    required this.authorInitials,
    this.authorAvatar,
    this.createdAt,
    this.serviceName,
    this.staffName,
    this.reply,
  });

  final int id;
  final int rating;
  final String? comment;
  final String authorName;
  final String authorInitials;
  final String? authorAvatar;
  final DateTime? createdAt;
  final String? serviceName;
  final String? staffName;

  /// The place's answer to this review.
  final ReviewReply? reply;
}

class ReviewReply {
  const ReviewReply({required this.text, this.createdAt});
  final String text;
  final DateTime? createdAt;
}

/// A page of reviews plus `meta.average` / `meta.distribution`.
class ReviewsPage {
  const ReviewsPage({required this.page, required this.summary, required this.distribution});

  final Paginated<Review> page;
  final RatingSummary summary;

  /// Star (1–5) → number of reviews.
  final Map<int, int> distribution;
}
