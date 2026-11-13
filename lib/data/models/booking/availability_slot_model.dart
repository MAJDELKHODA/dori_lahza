class AvailabilitySlotModel {
  final String time;
  final String startsAt;
  final String endsAt;
  final List<AvailableStaff> staff;
  final int seatsLeft;

  AvailabilitySlotModel({
    required this.time,
    required this.startsAt,
    required this.endsAt,
    required this.staff,
    required this.seatsLeft,
  });

  factory AvailabilitySlotModel.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlotModel(
      time: json['time'] ?? '',
      startsAt: json['starts_at'] ?? '',
      endsAt: json['ends_at'] ?? '',
      staff: (json['staff'] as List? ?? [])
          .map(
            (item) => AvailableStaff.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
      seatsLeft: json['seats_left'] ?? 0,
    );
  }
}

class AvailableStaff {
  final int id;
  final String name;

  AvailableStaff({required this.id, required this.name});

  factory AvailableStaff.fromJson(Map<String, dynamic> json) {
    return AvailableStaff(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
