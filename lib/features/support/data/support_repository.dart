import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';

class Notice {
  const Notice({
    required this.id,
    required String title,
    required String body,
    required this.isPinned,
    required this.publishedAt,
    String? titleEn,
    String? bodyEn,
  })  : _title = title,
        _body = body,
        _titleEn = titleEn,
        _bodyEn = bodyEn;

  factory Notice.fromJson(Json json) => Notice(
        id: json.str('id'),
        title: json.str('title'),
        body: json.str('body'),
        titleEn: json.strOrNull('title_en'),
        bodyEn: json.strOrNull('body_en'),
        isPinned: json.boolOr('is_pinned'),
        publishedAt: json.dateTime('published_at'),
      );

  final String id;
  final String _title;
  final String _body;
  final String? _titleEn;
  final String? _bodyEn;

  /// 현재 언어의 제목·본문 (영어 값이 없으면 한국어)
  String get title => L10n.pick(_title, _titleEn);
  String get body => L10n.pick(_body, _bodyEn);
  final bool isPinned;
  final DateTime publishedAt;
}

class Faq {
  const Faq({
    required this.id,
    required String category,
    required String question,
    required String answer,
    String? categoryEn,
    String? questionEn,
    String? answerEn,
  })  : _category = category,
        _question = question,
        _answer = answer,
        _categoryEn = categoryEn,
        _questionEn = questionEn,
        _answerEn = answerEn;

  factory Faq.fromJson(Json json) => Faq(
        id: json.str('id'),
        category: json.str('category'),
        question: json.str('question'),
        answer: json.str('answer'),
        categoryEn: json.strOrNull('category_en'),
        questionEn: json.strOrNull('question_en'),
        answerEn: json.strOrNull('answer_en'),
      );

  final String id;
  final String _category;
  final String _question;
  final String _answer;
  final String? _categoryEn;
  final String? _questionEn;
  final String? _answerEn;

  /// 현재 언어의 분류·질문·답변 (영어 값이 없으면 한국어)
  String get category => L10n.pick(_category, _categoryEn);
  String get question => L10n.pick(_question, _questionEn);
  String get answer => L10n.pick(_answer, _answerEn);
}

enum InquiryCategory {
  booking('booking'),
  payment('payment'),
  exercise('exercise'),
  analysis('analysis'),
  account('account'),
  etc('etc');

  const InquiryCategory(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        InquiryCategory.booking => L10n.current.inquiryCategoryBooking,
        InquiryCategory.payment => L10n.current.inquiryCategoryPayment,
        InquiryCategory.exercise => L10n.current.inquiryCategoryExercise,
        InquiryCategory.analysis => L10n.current.inquiryCategoryAnalysis,
        InquiryCategory.account => L10n.current.inquiryCategoryAccount,
        InquiryCategory.etc => L10n.current.inquiryCategoryEtc,
      };

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
        'answered' => L10n.current.inquiryStatusAnswered,
        'closed' => L10n.current.inquiryStatusClosed,
        _ => L10n.current.inquiryStatusPending,
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
