import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../membership/providers.dart';
import '../data/booking_models.dart';
import '../providers.dart';
import 'widgets/booking_widgets.dart';

enum _BookingTab { upcoming, past }

/// 예약 탭 — 예약 내역 조회와 새 예약 진입
class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  _BookingTab _tab = _BookingTab.upcoming;

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('예약'),
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.payments),
            child: const Text('결제·환불 내역'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(myBookingsProvider)
            ..invalidate(membershipsProvider);
          await ref.read(myBookingsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            const _NewBookingCard(),
            const SizedBox(height: 24),
            SegmentedButton<_BookingTab>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: _BookingTab.upcoming, label: Text('예정된 예약')),
                ButtonSegment(value: _BookingTab.past, label: Text('지난 예약')),
              ],
              selected: {_tab},
              onSelectionChanged: (value) => setState(() => _tab = value.first),
            ),
            const SizedBox(height: 16),
            AsyncValueView<List<Booking>>(
              value: bookings,
              onRetry: () => ref.invalidate(myBookingsProvider),
              data: (list) {
                final now = DateTime.now();
                final items = _tab == _BookingTab.upcoming
                    ? (list.where((b) => b.isUpcoming(now)).toList()..sort((a, b) => a.startAt.compareTo(b.startAt)))
                    : list.where((b) => !b.isUpcoming(now)).toList();
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.event_note_rounded,
                    title: _tab == _BookingTab.upcoming ? '예정된 예약이 없어요' : '지난 예약이 없어요',
                    message: _tab == _BookingTab.upcoming ? '원하는 시간에 트레드밀을 예약해 보세요.' : null,
                  );
                }
                return Column(
                  children: [
                    for (final booking in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BookingCard(
                          booking: booking,
                          onTap: () => context.push(AppRoutes.bookingDetail(booking.id)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NewBookingCard extends ConsumerWidget {
  const _NewBookingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberships = ref.watch(membershipsProvider).valueOrNull ?? const [];
    final usable = memberships.where((m) => m.isUsable()).toList();
    final remaining = usable.fold<int>(0, (sum, m) => sum + m.remainingSessions);

    return Container(
      decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(28)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.push(AppRoutes.membership),
            child: Row(
              children: [
                const Icon(Icons.confirmation_number_rounded, color: AppColors.burgundy),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '사용 가능한 이용권',
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.burgundyDeep),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '$remaining', style: AppText.numeric(22, color: AppColors.burgundyDeep)),
                      const TextSpan(
                        text: ' 회',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.burgundyDeep),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.burgundy),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.bookingNew),
            icon: const Icon(Icons.add_rounded),
            label: const Text('새 운동 예약'),
          ),
        ],
      ),
    );
  }
}
