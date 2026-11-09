import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/common.dart';
import '../../auth/data/auth_repository.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../../dogs/providers.dart';
import '../../profile/data/user_repository.dart';

/// 마이페이지 (문서 3.5, 화면 12 MyPageScreen)
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDialog(context, title: '로그아웃', message: '로그아웃할까요?', confirmLabel: '로그아웃');
    if (!confirmed) return;
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (error) {
      if (context.mounted) context.showMessage(friendlyError(error));
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDialog(
      context,
      title: '회원 탈퇴',
      message: '탈퇴하면 반려견 정보, 예약, 운동·분석 기록과 남은 이용권이 모두 삭제되며 복구할 수 없어요. '
          '결제 기록은 관련 법령에 따라 일정 기간 보관됩니다.\n\n정말 탈퇴할까요?',
      confirmLabel: '탈퇴하기',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
    } catch (error) {
      if (context.mounted) context.showMessage(friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;
    final email = ref.watch(authRepositoryProvider).currentEmail;
    final dogs = ref.watch(dogsProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('마이페이지')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          AppCard(
            onTap: () => context.push(AppRoutes.profileEdit),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.peach,
                  child: Text(
                    (profile?.displayName ?? '보').characters.first,
                    style: const TextStyle(color: AppColors.burgundy, fontWeight: FontWeight.w800, fontSize: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${profile?.displayName ?? '보호자'}님', style: theme.textTheme.titleMedium),
                      if (email != null) Text(email, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
                      if (profile?.phone != null)
                        Text(profile!.phone!, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(title: '내 반려견', actionLabel: '관리', onAction: () => context.push(AppRoutes.dogs)),
          SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final dog in dogs)
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.push(AppRoutes.dogDetail(dog.id)),
                      child: SizedBox(
                        width: 64,
                        child: Column(
                          children: [
                            DogAvatar(dog: dog, size: 60),
                            const SizedBox(height: 6),
                            Text(dog.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push(AppRoutes.dogNew),
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: scheme.outlineVariant, width: 1.5),
                          ),
                          child: Icon(Icons.add_rounded, color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 6),
                        Text('추가', style: TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MenuGroup(
            title: '이용 내역',
            items: [
              _MenuItem(Icons.confirmation_number_outlined, '이용권 및 멤버십', () => context.push(AppRoutes.membership)),
              _MenuItem(Icons.receipt_long_outlined, '결제·환불 내역', () => context.push(AppRoutes.payments)),
              _MenuItem(Icons.event_note_outlined, '예약 내역', () => context.go(AppRoutes.booking)),
              _MenuItem(Icons.insights_outlined, '운동 누적 기록', () => context.push(AppRoutes.exerciseHistory)),
            ],
          ),
          _MenuGroup(
            title: '설정',
            items: [
              _MenuItem(Icons.manage_accounts_outlined, '프로필 및 로그인 계정', () => context.push(AppRoutes.profileEdit)),
              _MenuItem(Icons.notifications_outlined, '알림 설정', () => context.push(AppRoutes.notificationSettings)),
              _MenuItem(Icons.privacy_tip_outlined, '개인정보 및 영상 이용 동의', () => context.push(AppRoutes.consents)),
            ],
          ),
          _MenuGroup(
            title: '고객지원',
            items: [
              _MenuItem(Icons.campaign_outlined, '공지사항', () => context.push(AppRoutes.notices)),
              _MenuItem(Icons.help_outline_rounded, '자주 묻는 질문', () => context.push(AppRoutes.faq)),
              _MenuItem(Icons.support_agent_rounded, '1:1 문의', () => context.push(AppRoutes.inquiries)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _signOut(context, ref),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
                child: const Text('로그아웃'),
              ),
              Text('|', style: TextStyle(color: scheme.outlineVariant)),
              TextButton(
                onPressed: () => _deleteAccount(context, ref),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
                child: const Text('회원 탈퇴'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.onTap);

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});

  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: title),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (final item in items)
                  ListTile(
                    leading: Icon(item.icon),
                    title: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: item.onTap,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
