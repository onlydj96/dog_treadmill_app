import '../../../core/utils/json.dart';

class Membership {
  const Membership({
    required this.id,
    required this.planName,
    required this.totalSessions,
    required this.remainingSessions,
    required this.startsAt,
    required this.expiresAt,
    required this.status,
  });

  factory Membership.fromJson(Json json) => Membership(
        id: json.str('id'),
        planName: json.str('plan_name'),
        totalSessions: json.intOr('total_sessions'),
        remainingSessions: json.intOr('remaining_sessions'),
        startsAt: json.dateTime('starts_at'),
        expiresAt: json.dateTime('expires_at'),
        status: json.str('status'),
      );

  final String id;
  final String planName;
  final int totalSessions;
  final int remainingSessions;
  final DateTime startsAt;
  final DateTime expiresAt;
  final String status;

  int get usedSessions => totalSessions - remainingSessions;

  bool isUsable([DateTime? now]) {
    final current = now ?? DateTime.now();
    return status == 'active' && remainingSessions > 0 && expiresAt.isAfter(current);
  }

  /// 특정 예약 시간에 사용할 수 있는지 (DB create_booking 검증과 동일 기준)
  bool isUsableFor(DateTime start, DateTime end) =>
      status == 'active' && remainingSessions > 0 && !startsAt.isAfter(start) && !expiresAt.isBefore(end);

  String get statusLabel {
    if (status == 'refunded') return '환불';
    if (status == 'cancelled') return '취소';
    if (status == 'expired' || expiresAt.isBefore(DateTime.now())) return '만료';
    if (remainingSessions <= 0) return '소진';
    return '사용 가능';
  }
}

class MembershipPlan {
  const MembershipPlan({
    required this.id,
    required this.name,
    required this.totalSessions,
    required this.validityDays,
    required this.price,
    this.description,
  });

  factory MembershipPlan.fromJson(Json json) => MembershipPlan(
        id: json.str('id'),
        name: json.str('name'),
        description: json.strOrNull('description'),
        totalSessions: json.intOr('total_sessions'),
        validityDays: json.intOr('validity_days'),
        price: json.intOr('price'),
      );

  final String id;
  final String name;
  final String? description;
  final int totalSessions;
  final int validityDays;
  final int price;

  int get pricePerSession => totalSessions == 0 ? price : (price / totalSessions).round();
}

enum PaymentStatus {
  pending('pending', '결제 대기'),
  paid('paid', '결제 완료'),
  cancelled('cancelled', '결제 취소'),
  refunded('refunded', '환불 완료'),
  partialRefunded('partial_refunded', '부분 환불'),
  failed('failed', '결제 실패');

  const PaymentStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static PaymentStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => PaymentStatus.pending);
}

class Payment {
  const Payment({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.orderName,
    this.method,
    this.refundedAmount = 0,
    this.paidAt,
    this.refundedAt,
  });

  factory Payment.fromJson(Json json) => Payment(
        id: json.str('id'),
        amount: json.intOr('amount'),
        status: PaymentStatus.fromDb(json.str('status')),
        orderName: json.strOrNull('order_name'),
        method: json.strOrNull('method'),
        refundedAmount: json.intOr('refunded_amount'),
        paidAt: json.dateTimeOrNull('paid_at'),
        refundedAt: json.dateTimeOrNull('refunded_at'),
        createdAt: json.dateTime('created_at'),
      );

  final String id;
  final int amount;
  final PaymentStatus status;
  final String? orderName;
  final String? method;
  final int refundedAmount;
  final DateTime? paidAt;
  final DateTime? refundedAt;
  final DateTime createdAt;
}
