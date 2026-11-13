class TeamMemberModel {
  final int id;
  final String name;
  final String title;
  final String bio;
  final String? avatar;
  final String initials;
  final String? color;
  final bool usesPlaceHours;
  final List<TeamMemberHour> hours;
  final double ratingAverage;
  final int ratingCount;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    this.avatar,
    required this.initials,
    this.color,
    required this.usesPlaceHours,
    required this.hours,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'] as Map? ?? {};

    return TeamMemberModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      avatar: json['avatar'],
      initials: json['initials'] ?? '',
      color: json['color'],
      usesPlaceHours: json['uses_place_hours'] ?? false,
      hours: (json['hours'] as List? ?? [])
          .map((e) => TeamMemberHour.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      ratingAverage: (rating['average'] as num? ?? 0).toDouble(),
      ratingCount: rating['count'] ?? 0,
    );
  }
}

class TeamMemberHour {
  final String day;
  final String label;
  final bool isOpen;
  final List<String> ranges;

  TeamMemberHour({
    required this.day,
    required this.label,
    required this.isOpen,
    required this.ranges,
  });

  factory TeamMemberHour.fromJson(Map<String, dynamic> json) {
    return TeamMemberHour(
      day: json['day'] ?? '',
      label: json['label'] ?? '',
      isOpen: json['open'] ?? false,
      ranges: (json['ranges'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}
