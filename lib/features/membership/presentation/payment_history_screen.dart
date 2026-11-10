import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../data/membership_models.dart';
import '../providers.dart';

/// 결제 및 환불 내역 (문서 3.2, 3.5)
class PaymentHistoryScreen extends ConsumerWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('결제·환불 내역')),
      body: AsyncValueView<List<Payment>>(
        value: ref.watch(paymentsProvider),
        onRetry: () => ref.invalidate(paymentsProvider),
        data: (payments) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(paymentsProvider);
            await ref.read(paymentsProvider.future);
          },
          child: payments.isEmpty
              ? const EmptyState(icon: Icons.receipt_long_rounded, title: '결제 내역이 없어요')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  itemCount: payments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _PaymentTile(payment: payments[index]),
                ),
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = switch (payment.status) {
      PaymentStatus.paid => scheme.activeTone,
      PaymentStatus.refunded || PaymentStatus.partialRefunded => scheme.calmTone,
      PaymentStatus.failed => scheme.alertTone,
      _ => scheme.neutralTone,
    };
    final date = payment.paidAt ?? payment.createdAt;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.mintMist, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.mintDeep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.orderName ?? '이용권 결제', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  [Fmt.dateShort(date), if (payment.method != null) payment.method!].join(' · '),
                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                ),
                if (payment.refundedAmount > 0)
                  Text(
                    '환불 ${Fmt.won(payment.refundedAmount)}'
                    '${payment.refundedAt != null ? ' (${Fmt.dateShort(payment.refundedAt!)})' : ''}',
                    style: TextStyle(fontSize: 12.5, color: scheme.calmTone.foreground, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.won(payment.amount), style: AppText.numeric(16, color: scheme.onSurface)),
              const SizedBox(height: 4),
              StatusBadge(label: payment.status.label, tone: tone, dense: true),
            ],
          ),
        ],
      ),
    );
  }
}
