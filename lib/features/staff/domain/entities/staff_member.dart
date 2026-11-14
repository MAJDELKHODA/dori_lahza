import 'package:dori_lahza/features/reviews/domain/entities/review.dart';
import 'package:dori_lahza/shared/domain/entities/common.dart';

class StaffMember {
  const StaffMember({
    required this.id,
    required this.name,
    this.title,
    this.bio,
    this.avatar,
    required this.initials,
    this.color,
    this.hours = const [],
    this.services = const [],
    this.rating = const RatingSummary(),
    this.latestReviews = const [],
  });

  final int id;
  final String name;
  final String? title;
  final String? bio;
  final String? avatar;
  final String initials;
  final String? color;
  final List<DayHours> hours;
  final List<StaffService> services;
  final RatingSummary rating;
  final List<Review> latestReviews;
}

/// Short service entry inside a staff profile.
class StaffService {
  const StaffService({required this.id, required this.name, required this.durationMinutes, required this.finalPrice});

  final int id;
  final String name;
  final int durationMinutes;
  final double finalPrice;
}
