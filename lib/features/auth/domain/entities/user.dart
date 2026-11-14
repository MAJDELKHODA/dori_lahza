class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.initials,
    this.reliability,
  });

  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String initials;

  /// Only returned by `auth/me`.
  final Reliability? reliability;

  User copyWith({String? name, String? phone, Reliability? reliability}) => User(
        id: id,
        name: name ?? this.name,
        email: email,
        phone: phone ?? this.phone,
        avatar: avatar,
        initials: initials,
        reliability: reliability ?? this.reliability,
      );
}

/// Commitment score (0–100) in this place. Late cancellations and no-shows
/// lower it.
class Reliability {
  const Reliability({required this.score, this.label, this.completed, this.cancelledLate, this.noShows});

  final int score;
  final String? label;
  final int? completed;
  final int? cancelledLate;
  final int? noShows;

  ReliabilityLevel get level => score >= 80
      ? ReliabilityLevel.high
      : score >= 50
          ? ReliabilityLevel.medium
          : ReliabilityLevel.low;
}

enum ReliabilityLevel { high, medium, low }
