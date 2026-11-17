import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';

class Membership {
  const Membership({
    required this.id,
    required String planName,
    required this.totalSessions,
    required this.remainingSessions,
    required this.startsAt,
    required this.expiresAt,
    required this.status,
    this.planNameEn,
  }) : _planName = planName;

  factory Membership.fromJson(Json json) => Membership(
        id: json.str('id'),
        planName: json.str('plan_name'),
        totalSessions: json.intOr('total_sessions'),
        remainingSessions: json.intOr('remaining_sessions'),
        startsAt: json.dateTime('starts_at'),
        expiresAt: json.dateTime('expires_at'),
        status: json.str('status'),
        planNameEn: json.objOrNull('plan')?.strOrNull('name_en'),
      );

  final String id;

  /// 구매 시점에 복사해 둔 상품명 (DB: memberships.plan_name)
  final String _planName;

  /// 상품의 영어 이름 (membership_plans.name_en). 상품이 지워졌거나 영어 이름이 없으면 null.
  final String? planNameEn;
  final int totalSessions;
  final int remainingSessions;
  final DateTime startsAt;
  final DateTime expiresAt;
  final String status;

  /// 현재 언어의 상품명
  String get planName => L10n.pick(_planName, planNameEn);

  int get usedSessions => totalSessions - remainingSessions;

  bool isUsable([DateTime? now]) {
    final current = now ?? DateTime.now();
    return status == 'active' && remainingSessions > 0 && expiresAt.isAfter(current);
  }

  /// 특정 예약 시간에 사용할 수 있는지 (DB create_booking 검증과 동일 기준)
  bool isUsableFor(DateTime start, DateTime end) =>
      status == 'active' && remainingSessions > 0 && !startsAt.isAfter(start) && !expiresAt.isBefore(end);

  String get statusLabel {
    final l10n = L10n.current;
    if (status == 'refunded') return l10n.membershipStatusRefunded;
    if (status == 'cancelled') return l10n.membershipStatusCancelled;
    if (status == 'expired' || expiresAt.isBefore(DateTime.now())) return l10n.membershipStatusExpired;
    if (remainingSessions <= 0) return l10n.membershipStatusUsedUp;
    return l10n.membershipStatusAvailable;
  }
}

class MembershipPlan {
  const MembershipPlan({
    required this.id,
    required String name,
    required this.totalSessions,
    required this.validityDays,
    required this.price,
    String? description,
    this.nameEn,
    this.descriptionEn,
  })  : _name = name,
        _description = description;

  factory MembershipPlan.fromJson(Json json) => MembershipPlan(
        id: json.str('id'),
        name: json.str('name'),
        description: json.strOrNull('description'),
        totalSessions: json.intOr('total_sessions'),
        validityDays: json.intOr('validity_days'),
        price: json.intOr('price'),
        nameEn: json.strOrNull('name_en'),
        descriptionEn: json.strOrNull('description_en'),
      );

  final String id;
  final String _name;
  final String? _description;

  /// 영어 값 (DB: membership_plans.name_en / description_en). 없으면 한국어 값을 쓴다.
  final String? nameEn;
  final String? descriptionEn;

  /// 현재 언어의 상품명
  String get name => L10n.pick(_name, nameEn);

  /// 현재 언어의 설명
  String? get description => L10n.pickOrNull(_description, descriptionEn);
  final int totalSessions;
  final int validityDays;
  final int price;

  int get pricePerSession => totalSessions == 0 ? price : (price / totalSessions).round();
}

enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  cancelled('cancelled'),
  refunded('refunded'),
  partialRefunded('partial_refunded'),
  failed('failed');

  const PaymentStatus(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        PaymentStatus.pending => L10n.current.paymentStatusPending,
        PaymentStatus.paid => L10n.current.paymentStatusPaid,
        PaymentStatus.cancelled => L10n.current.paymentStatusCancelled,
        PaymentStatus.refunded => L10n.current.paymentStatusRefunded,
        PaymentStatus.partialRefunded => L10n.current.paymentStatusPartialRefunded,
        PaymentStatus.failed => L10n.current.paymentStatusFailed,
      };

  static PaymentStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => PaymentStatus.pending);
}

class Payment {
  const Payment({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    String? orderName,
    String? orderNameEn,
    this.method,
    this.refundedAmount = 0,
    this.paidAt,
    this.refundedAt,
  })  : _orderName = orderName,
        _orderNameEn = orderNameEn;

  factory Payment.fromJson(Json json) => Payment(
        id: json.str('id'),
        amount: json.intOr('amount'),
        status: PaymentStatus.fromDb(json.str('status')),
        orderName: json.strOrNull('order_name'),
        orderNameEn: json.strOrNull('order_name_en'),
        method: json.strOrNull('method'),
        refundedAmount: json.intOr('refunded_amount'),
        paidAt: json.dateTimeOrNull('paid_at'),
        refundedAt: json.dateTimeOrNull('refunded_at'),
        createdAt: json.dateTime('created_at'),
      );

  final String id;
  final int amount;
  final PaymentStatus status;
  final String? _orderName;
  final String? _orderNameEn;
  final String? method;
  final int refundedAmount;
  final DateTime? paidAt;
  final DateTime? refundedAt;
  final DateTime createdAt;

  /// 주문명 (영어 화면이면 order_name_en, 없으면 기본 값)
  String? get orderName => L10n.pickOrNull(_orderName, _orderNameEn);
}
