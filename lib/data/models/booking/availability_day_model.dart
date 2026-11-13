class AvailabilityDayModel {
  final String date;
  final String day;
  final String label;
  final bool isOpen;
  final int slotsCount;
  final String? firstTime;

  AvailabilityDayModel({
    required this.date,
    required this.day,
    required this.label,
    required this.isOpen,
    required this.slotsCount,
    this.firstTime,
  });

  bool get isAvailable => isOpen && slotsCount > 0;

  factory AvailabilityDayModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityDayModel(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      label: json['label'] ?? '',
      isOpen: json['open'] ?? false,
      slotsCount: json['slots_count'] ?? 0,
      firstTime: json['first_time']?.toString(),
    );
  }
}
