import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../data/support_repository.dart';

/// 공지사항
class NoticesScreen extends ConsumerWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항')),
      body: AsyncValueView<List<Notice>>(
        value: ref.watch(noticesProvider),
        onRetry: () => ref.invalidate(noticesProvider),
        data: (notices) {
          if (notices.isEmpty) {
            return const EmptyState(icon: Icons.campaign_outlined, title: '등록된 공지사항이 없어요');
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            itemCount: notices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final notice = notices[index];
              return AppCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  initiallyExpanded: index == 0,
                  leading: Icon(
                    notice.isPinned ? Icons.push_pin_rounded : Icons.campaign_outlined,
                    color: notice.isPinned ? AppColors.vermilion : scheme.onSurfaceVariant,
                  ),
                  title: Text(notice.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(Fmt.dateShort(notice.publishedAt), style: const TextStyle(fontSize: 12.5)),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  expandedAlignment: Alignment.centerLeft,
                  children: [Text(notice.body, style: const TextStyle(height: 1.6))],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// 자주 묻는 질문
class FaqScreen extends ConsumerStatefulWidget {
  const FaqScreen({super.key});

  @override
  ConsumerState<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends ConsumerState<FaqScreen> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자주 묻는 질문')),
      body: AsyncValueView<List<Faq>>(
        value: ref.watch(faqsProvider),
        onRetry: () => ref.invalidate(faqsProvider),
        data: (faqs) {
          final categories = {for (final faq in faqs) faq.category}.toList();
          final visible = _category == null ? faqs : faqs.where((f) => f.category == _category).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('전체'),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                  for (final category in categories)
                    ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              for (final faq in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      leading: const Text(
                        'Q',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.vermilion),
                      ),
                      title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.w700)),
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                      expandedAlignment: Alignment.centerLeft,
                      children: [Text(faq.answer, style: const TextStyle(height: 1.6))],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.inquiryNew),
                icon: const Icon(Icons.support_agent_rounded),
                label: const Text('원하는 답이 없나요? 1:1 문의하기'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 1:1 문의 내역
class InquiryListScreen extends ConsumerWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('1:1 문의')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.inquiryNew),
        backgroundColor: AppColors.vermilion,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('문의하기', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: AsyncValueView<List<Inquiry>>(
        value: ref.watch(inquiriesProvider),
        onRetry: () => ref.invalidate(inquiriesProvider),
        data: (inquiries) {
          if (inquiries.isEmpty) {
            return const EmptyState(
              icon: Icons.support_agent_rounded,
              title: '문의 내역이 없어요',
              message: '궁금한 점을 남겨 주시면 확인 후 답변드릴게요.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            itemCount: inquiries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final inquiry = inquiries[index];
              return AppCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(inquiry.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        StatusBadge(
                          label: inquiry.statusLabel,
                          tone: inquiry.isAnswered ? scheme.calmTone : scheme.cautionTone,
                          dense: true,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${inquiry.category.label} · ${Fmt.dateShort(inquiry.createdAt)}',
                          style: const TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(inquiry.body, style: const TextStyle(height: 1.6)),
                    if (inquiry.answer != null && inquiry.answer!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('답변', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.vermilion)),
                            const SizedBox(height: 6),
                            Text(inquiry.answer!, style: const TextStyle(height: 1.6)),
                            if (inquiry.answeredAt != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                Fmt.dateShort(inquiry.answeredAt!),
                                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// 1:1 문의 작성
class InquiryFormScreen extends ConsumerStatefulWidget {
  const InquiryFormScreen({super.key});

  @override
  ConsumerState<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends ConsumerState<InquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  InquiryCategory _category = InquiryCategory.booking;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(supportRepositoryProvider).createInquiry(
            userId: userId,
            category: _category,
            title: _titleController.text,
            body: _bodyController.text,
          );
      ref.invalidate(inquiriesProvider);
      if (mounted) {
        context.showMessage('문의를 접수했어요. 답변이 등록되면 문의 내역에서 확인할 수 있어요.');
        context.pop();
      }
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('문의하기')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text('문의 유형', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in InquiryCategory.values)
                  ChoiceChip(
                    label: Text(category.label),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              maxLength: 100,
              decoration: const InputDecoration(labelText: '제목'),
              validator: (value) => (value == null || value.trim().isEmpty) ? '제목을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bodyController,
              maxLength: 2000,
              minLines: 6,
              maxLines: 12,
              decoration: const InputDecoration(labelText: '내용', alignLabelWithHint: true),
              validator: (value) => (value == null || value.trim().isEmpty) ? '내용을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                    )
                  : const Text('문의 접수'),
            ),
          ],
        ),
      ),
    );
  }
}
