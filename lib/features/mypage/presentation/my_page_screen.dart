import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/app_language.dart';
import '../../../l10n/l10n.dart';
import '../../auth/data/auth_repository.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../../dogs/providers.dart';
import '../../profile/data/user_repository.dart';
import '../../ranking/presentation/ranking_settings_sheet.dart';

/// 마이페이지 (문서 3.5, 화면 12 MyPageScreen)
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDialog(
      context,
      title: context.l10n.myPageLogOut,
      message: context.l10n.myPageLogOutMessage,
      confirmLabel: context.l10n.myPageLogOut,
    );
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
      title: context.l10n.myPageDeleteAccount,
      message: context.l10n.myPageDeleteMessage,
      confirmLabel: context.l10n.myPageDeleteConfirm,
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
      appBar: AppBar(title: Text(context.l10n.myPageTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          AppCard(
            onTap: () => context.push(AppRoutes.profileEdit),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.mintMist,
                  child: Text(
                    (profile?.displayName ?? context.l10n.commonOwnerFallbackName).characters.first,
                    style: const TextStyle(color: AppColors.mintDeep, fontWeight: FontWeight.w800, fontSize: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.myPageGreeting(profile?.displayName ?? context.l10n.commonOwnerFallbackName),
                        style: theme.textTheme.titleMedium,
                      ),
                      if (profile != null && profile.nickname.isNotEmpty)
                        Text(
                          '@${profile.nickname}',
                          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
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
          SectionHeader(title: context.l10n.myPageMyDogs, actionLabel: context.l10n.commonManage, onAction: () => context.push(AppRoutes.dogs)),
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
                        Text(context.l10n.commonAdd, style: TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MenuGroup(
            title: context.l10n.myPageUsageGroup,
            items: [
              _MenuItem(Icons.confirmation_number_outlined, context.l10n.myPageMembership, () => context.push(AppRoutes.membership)),
              _MenuItem(Icons.receipt_long_outlined, context.l10n.myPagePayments, () => context.push(AppRoutes.payments)),
              _MenuItem(Icons.event_note_outlined, context.l10n.myPageBookings, () => context.go(AppRoutes.booking)),
              _MenuItem(Icons.insights_outlined, context.l10n.myPageWorkoutHistory, () => context.push(AppRoutes.exerciseHistory)),
            ],
          ),
          _MenuGroup(
            title: context.l10n.myPageRankingGroup,
            items: [
              _MenuItem(Icons.leaderboard_outlined, context.l10n.myPageRankingHall, () => context.push(AppRoutes.ranking)),
              _MenuItem(Icons.badge_outlined, context.l10n.myPageRankingSettings, () => showRankingSettingsSheet(context)),
            ],
          ),
          _MenuGroup(
            title: context.l10n.myPageSettingsGroup,
            items: [
              _MenuItem(Icons.manage_accounts_outlined, context.l10n.myPageProfile, () => context.push(AppRoutes.profileEdit)),
              _MenuItem(Icons.notifications_outlined, context.l10n.notificationSettingsTitle, () => context.push(AppRoutes.notificationSettings)),
              _MenuItem(Icons.privacy_tip_outlined, context.l10n.consentScreenTitle, () => context.push(AppRoutes.consents)),
              _MenuItem(
                Icons.language_rounded,
                context.l10n.languageMenuTitle,
                () => showLanguagePicker(context),
                trailing: ref.watch(appLanguageProvider).nativeName,
              ),
            ],
          ),
          _MenuGroup(
            title: context.l10n.myPageSupportGroup,
            items: [
              _MenuItem(Icons.campaign_outlined, context.l10n.noticeTitle, () => context.push(AppRoutes.notices)),
              _MenuItem(Icons.help_outline_rounded, context.l10n.faqTitle, () => context.push(AppRoutes.faq)),
              _MenuItem(Icons.support_agent_rounded, context.l10n.inquiryTitle, () => context.push(AppRoutes.inquiries)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _signOut(context, ref),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
                child: Text(context.l10n.myPageLogOut),
              ),
              Text('|', style: TextStyle(color: scheme.outlineVariant)),
              TextButton(
                onPressed: () => _deleteAccount(context, ref),
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
                child: Text(context.l10n.myPageDeleteAccount),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.onTap, {this.trailing});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// 오른쪽에 보여 줄 현재 값 (예: 언어 이름)
  final String? trailing;
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
                    trailing: item.trailing == null
                        ? const Icon(Icons.chevron_right_rounded)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.trailing!,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
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
