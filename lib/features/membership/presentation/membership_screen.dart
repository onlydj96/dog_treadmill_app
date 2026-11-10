import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../data/membership_models.dart';
import '../providers.dart';

/// 이용권 관리 (화면 11 MembershipScreen)
class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이용권'),
        actions: [
          TextButton(onPressed: () => context.push(AppRoutes.payments), child: const Text('결제 내역')),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(membershipsProvider)
            ..invalidate(membershipPlansProvider);
          await ref.read(membershipsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const SectionHeader(title: '보유 이용권'),
            AsyncValueView<List<Membership>>(
              value: ref.watch(membershipsProvider),
              onRetry: () => ref.invalidate(membershipsProvider),
              data: (memberships) {
                if (memberships.isEmpty) {
                  return const InlineEmptyCard(
                    icon: Icons.confirmation_number_outlined,
                    message: '보유한 이용권이 없어요. 아래 상품을 구매하면 앱에서 바로 예약에 사용할 수 있어요.',
                  );
                }
                final sorted = [...memberships]..sort((a, b) {
                    final usable = (b.isUsable() ? 1 : 0) - (a.isUsable() ? 1 : 0);
                    return usable != 0 ? usable : a.expiresAt.compareTo(b.expiresAt);
                  });
                return Column(
                  children: [
                    for (final membership in sorted)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MembershipCard(membership: membership),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: '이용권 상품'),
            AsyncValueView<List<MembershipPlan>>(
              value: ref.watch(membershipPlansProvider),
              onRetry: () => ref.invalidate(membershipPlansProvider),
              data: (plans) => Column(
                children: [
                  for (final plan in plans)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PlanCard(
                        plan: plan,
                        onTap: () => showModalBottomSheet<void>(
                          context: context,
                          builder: (context) => _PurchaseSheet(plan: plan),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.storefront_rounded, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '상품을 누르면 결제 방법을 볼 수 있어요. 앱 결제는 준비 중이라 지금은 매장에서 구매할 수 있고, '
                    '구매하면 바로 보유 이용권에 반영돼요.',
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.45),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.membership});

  final Membership membership;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final usable = membership.isUsable();
    final daysLeft = membership.expiresAt.difference(DateTime.now()).inDays;
    final ratio = membership.totalSessions == 0 ? 0.0 : membership.remainingSessions / membership.totalSessions;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: usable ? AppColors.charcoal : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  membership.planName,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: usable ? Colors.white : scheme.onSurfaceVariant,
                  ),
                ),
              ),
              StatusBadge(
                label: usable && daysLeft <= 14 ? 'D-$daysLeft' : membership.statusLabel,
                tone: usable
                    ? const StatusTone(foreground: AppColors.mintInk, background: AppColors.mintMist)
                    : scheme.neutralTone,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${membership.remainingSessions}',
                style: AppText.numeric(40, color: usable ? Colors.white : scheme.onSurfaceVariant, height: 1),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  '/ ${membership.totalSessions}회 남음',
                  style:
                      TextStyle(color: usable ? AppColors.mintLight : scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              color: usable ? AppColors.mint : scheme.outline,
              backgroundColor: usable ? Colors.white.withValues(alpha: 0.18) : scheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${Fmt.dateShort(membership.startsAt)} ~ ${Fmt.dateShort(membership.expiresAt)}',
            style: TextStyle(
              fontSize: 13,
              color: usable ? Colors.white.withValues(alpha: 0.8) : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onTap});

  final MembershipPlan plan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.mintMist, borderRadius: BorderRadius.circular(16)),
            child: Text('${plan.totalSessions}회', style: AppText.numeric(15, color: AppColors.mintInk)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
                if (plan.description != null)
                  Text(plan.description!, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
                Text('유효기간 ${plan.validityDays}일', style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.won(plan.price), style: AppText.numeric(16, color: scheme.onSurface)),
              if (plan.totalSessions > 1)
                Text(
                  '회당 ${Fmt.won(plan.pricePerSession)}',
                  style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                ),
            ],
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// 이용권 구매 방법. 앱 결제(PG)는 아직 연동 전이라 형식만 두고, 지금은 매장 구매로 안내한다.
class _PurchaseSheet extends StatelessWidget {
  const _PurchaseSheet({required this.plan});

  final MembershipPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(plan.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '${Fmt.won(plan.price)} · ${plan.totalSessions}회 · 유효기간 ${plan.validityDays}일',
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            _PurchaseMethod(
              icon: Icons.smartphone_rounded,
              title: '앱 결제',
              body: '카드·간편결제로 결제하면 바로 보유 이용권에 추가돼요.',
              badge: StatusBadge(label: '준비 중', tone: scheme.neutralTone, dense: true),
            ),
            const SizedBox(height: 8),
            const _PurchaseMethod(
              icon: Icons.storefront_rounded,
              title: '매장 결제',
              body: '지금은 매장에서 구매할 수 있어요. 구매하면 바로 앱의 보유 이용권에 반영돼요.',
            ),
            const SizedBox(height: 20),
            // PG 연동 후 결제 요청으로 바꾼다.
            const FilledButton(onPressed: null, child: Text('앱 결제 준비 중')),
          ],
        ),
      ),
    );
  }
}

class _PurchaseMethod extends StatelessWidget {
  const _PurchaseMethod({required this.icon, required this.title, required this.body, this.badge});

  final IconData icon;
  final String title;
  final String body;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.mintDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.45)),
              ],
            ),
          ),
          if (badge != null) ...[const SizedBox(width: 8), badge!],
        ],
      ),
    );
  }
}
