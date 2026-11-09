import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json.dart';

class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.isPinned,
    required this.publishedAt,
  });

  factory Notice.fromJson(Json json) => Notice(
        id: json.str('id'),
        title: json.str('title'),
        body: json.str('body'),
        isPinned: json.boolOr('is_pinned'),
        publishedAt: json.dateTime('published_at'),
      );

  final String id;
  final String title;
  final String body;
  final bool isPinned;
  final DateTime publishedAt;
}

class Faq {
  const Faq({required this.id, required this.category, required this.question, required this.answer});

  factory Faq.fromJson(Json json) => Faq(
        id: json.str('id'),
        category: json.str('category'),
        question: json.str('question'),
        answer: json.str('answer'),
      );

  final String id;
  final String category;
  final String question;
  final String answer;
}

enum InquiryCategory {
  booking('booking', '예약'),
  payment('payment', '결제·이용권'),
  exercise('exercise', '운동'),
  analysis('analysis', 'AI 분석'),
  account('account', '계정'),
  etc('etc', '기타');

  const InquiryCategory(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static InquiryCategory fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => InquiryCategory.etc);
}

class Inquiry {
  const Inquiry({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.status,
    required this.createdAt,
    this.answer,
    this.answeredAt,
  });

  factory Inquiry.fromJson(Json json) => Inquiry(
        id: json.str('id'),
        category: InquiryCategory.fromDb(json.str('category')),
        title: json.str('title'),
        body: json.str('body'),
        status: json.str('status'),
        answer: json.strOrNull('answer'),
        answeredAt: json.dateTimeOrNull('answered_at'),
        createdAt: json.dateTime('created_at'),
      );

  final String id;
  final InquiryCategory category;
  final String title;
  final String body;
  final String status;
  final String? answer;
  final DateTime? answeredAt;
  final DateTime createdAt;

  bool get isAnswered => status == 'answered' || (answer != null && answer!.isNotEmpty);

  String get statusLabel => switch (status) {
        'answered' => '답변 완료',
        'closed' => '종료',
        _ => '답변 대기',
      };
}

class SupportRepository {
  SupportRepository(this._client);

  final SupabaseClient _client;

  Future<List<Notice>> fetchNotices({int limit = 50}) async {
    final rows = await _client
        .from('notices')
        .select()
        .order('is_pinned', ascending: false)
        .order('published_at', ascending: false)
        .limit(limit);
    return rows.map(Notice.fromJson).toList();
  }

  Future<List<Faq>> fetchFaqs() async {
    final rows = await _client.from('faqs').select().eq('is_active', true).order('sort_order', ascending: true);
    return rows.map(Faq.fromJson).toList();
  }

  Future<List<Inquiry>> fetchInquiries(String userId) async {
    final rows = await _client.from('inquiries').select().eq('user_id', userId).order('created_at', ascending: false);
    return rows.map(Inquiry.fromJson).toList();
  }

  Future<void> createInquiry({
    required String userId,
    required InquiryCategory category,
    required String title,
    required String body,
  }) async {
    await _client.from('inquiries').insert({
      'user_id': userId,
      'category': category.dbValue,
      'title': title.trim(),
      'body': body.trim(),
    });
  }
}

final supportRepositoryProvider = Provider<SupportRepository>(
  (ref) => SupportRepository(ref.watch(supabaseClientProvider)),
);

final noticesProvider = FutureProvider.autoDispose<List<Notice>>(
  (ref) => ref.watch(supportRepositoryProvider).fetchNotices(),
);

final faqsProvider = FutureProvider.autoDispose<List<Faq>>(
  (ref) => ref.watch(supportRepositoryProvider).fetchFaqs(),
);

final inquiriesProvider = FutureProvider.autoDispose<List<Inquiry>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(supportRepositoryProvider).fetchInquiries(userId);
});
