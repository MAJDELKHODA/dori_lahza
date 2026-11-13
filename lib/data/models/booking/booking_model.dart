class BookingModel {
  final int id;
  final String number;
  final String code;
  final String qr;

  final String status;
  final String statusLabel;
  final String source;
  final String sourceLabel;

  final String startsAt;
  final String endsAt;
  final String date;
  final String dayLabel;
  final String time;
  final String endTime;
  final int durationMinutes;

  final int serviceId;
  final String serviceName;

  final int? staffId;
  final String? staffName;

  final double price;
  final double discount;
  final double total;
  final String currency;
  final String currencySymbol;

  final String? couponCode;
  final String paymentMethod;
  final String paymentMethodLabel;

  final String customerName;
  final String phone;
  final String? notes;

  final bool canCancel;
  final bool canReschedule;
  final bool cancelIsLate;
  final bool canReview;

  final List<BookingTimelineStep> timeline;

  BookingModel({
    required this.id,
    required this.number,
    required this.code,
    required this.qr,
    required this.status,
    required this.statusLabel,
    required this.source,
    required this.sourceLabel,
    required this.startsAt,
    required this.endsAt,
    required this.date,
    required this.dayLabel,
    required this.time,
    required this.endTime,
    required this.durationMinutes,
    required this.serviceId,
    required this.serviceName,
    this.staffId,
    this.staffName,
    required this.price,
    required this.discount,
    required this.total,
    required this.currency,
    required this.currencySymbol,
    this.couponCode,
    required this.paymentMethod,
    required this.paymentMethodLabel,
    required this.customerName,
    required this.phone,
    this.notes,
    required this.canCancel,
    required this.canReschedule,
    required this.cancelIsLate,
    required this.canReview,
    required this.timeline,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      number: json['number']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      qr: json['qr']?.toString() ?? '',

      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      sourceLabel: json['source_label']?.toString() ?? '',

      startsAt: json['starts_at']?.toString() ?? '',
      endsAt: json['ends_at']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      dayLabel: json['day_label']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,

      serviceId: (json['service_id'] as num?)?.toInt() ?? 0,
      serviceName: json['service_name']?.toString() ?? '',

      staffId: (json['staff_id'] as num?)?.toInt(),
      staffName: json['staff_name']?.toString(),

      price: (json['price'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'ILS',
      currencySymbol: json['currency_symbol']?.toString() ?? '₪',

      couponCode: json['coupon_code']?.toString(),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentMethodLabel: json['payment_method_label']?.toString() ?? '',

      customerName: json['customer_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      notes: json['notes']?.toString(),

      canCancel: json['can_cancel'] == true,
      canReschedule: json['can_reschedule'] == true,
      cancelIsLate: json['cancel_is_late'] == true,
      canReview: json['can_review'] == true,

      timeline: (json['timeline'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) =>
                BookingTimelineStep.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(),
    );
  }
}

class BookingTimelineStep {
  final String status;
  final String label;
  final bool done;
  final String? at;
  final String? note;

  BookingTimelineStep({
    required this.status,
    required this.label,
    required this.done,
    this.at,
    this.note,
  });

  factory BookingTimelineStep.fromJson(Map<String, dynamic> json) {
    return BookingTimelineStep(
      status: json['status']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      done: json['done'] == true,
      at: json['at']?.toString(),
      note: json['note']?.toString(),
    );
  }
}
