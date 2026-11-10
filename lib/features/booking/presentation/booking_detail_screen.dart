import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/common.dart';
import '../data/booking_models.dart';
import '../providers.dart';
import 'widgets/booking_widgets.dart';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingDetailProvider(bookingId));
    return Scaffold(
      appBar: AppBar(title: const Text('예약 상세')),
      body: AsyncValueView<Booking>(
        value: booking,
        onRetry: () => ref.invalidate(bookingDetailProvider(bookingId)),
        data: (booking) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(bookingDetailProvider(bookingId));
            await ref.read(bookingDetailProvider(bookingId).future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              _Header(booking: booking),
              const SizedBox(height: 16),
              _StatusSteps(status: booking.status),
              const SizedBox(height: 16),
              _InfoCard(booking: booking),
              const SizedBox(height: 20),
              _Actions(booking: booking),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntersectionBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingStatusBadge(status: booking.status),
            const SizedBox(height: 14),
            Text(
              Fmt.dateFull(booking.startAt),
              style: theme.textTheme.titleMedium?.copyWith(color: AppColors.mintLight),
            ),
            const SizedBox(height: 4),
            Text(
              Fmt.timeRange(booking.startAt, booking.endAt),
              style: AppText.numeric(28, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              '${booking.program?.name ?? '트레드밀 운동'} · ${booking.dog?.name ?? ''}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// 예약 → 확정 → 체크인 → 이용 완료 진행 단계
class _StatusSteps extends StatelessWidget {
  const _StatusSteps({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (status == BookingStatus.cancelled || status == BookingStatus.noShow) {
      return AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: scheme.onSurfaceVariant),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status == BookingStatus.cancelled ? '취소된 예약이에요.' : '방문하지 않아 미방문 처리된 예약이에요.',
              ),
            ),
          ],
        ),
      );
    }

    const steps = [
      (BookingStatus.pending, '접수'),
      (BookingStatus.confirmed, '확정'),
      (BookingStatus.checkedIn, '체크인'),
      (BookingStatus.completed, '이용 완료'),
    ];
    final currentIndex = steps.indexWhere((s) => s.$1 == status);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= currentIndex ? scheme.primary : scheme.surfaceContainerHigh,
                    ),
                    child: Icon(
                      i < currentIndex ? Icons.check_rounded : Icons.circle,
                      size: i < currentIndex ? 16 : 8,
                      color: i <= currentIndex ? scheme.onPrimary : scheme.outline,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[i].$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: i == currentIndex ? FontWeight.w800 : FontWeight.w500,
                      color: i <= currentIndex ? scheme.onSurface : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final branch = booking.branch;
    final program = booking.program;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(icon: Icons.pets_rounded, label: '반려견', value: booking.dog?.name ?? '-'),
          InfoRow(
            icon: Icons.storefront_rounded,
            label: '지점',
            value: branch == null ? '-' : '${branch.name}\n${branch.address}',
          ),
          InfoRow(icon: Icons.directions_run_rounded, label: '트레드밀', value: booking.treadmill?.deviceName ?? '-'),
          InfoRow(
            icon: Icons.fitness_center_rounded,
            label: '프로그램',
            value: program == null ? '-' : '${program.name} · ${program.durationMinutes}분 · ${program.intensity.label}',
          ),
          InfoRow(
            icon: Icons.confirmation_number_outlined,
            label: '결제',
            value: booking.usesMembership ? '이용권 1회 사용' : '현장 결제',
          ),
          if (booking.note != null) InfoRow(icon: Icons.edit_note_rounded, label: '요청 사항', value: booking.note!),
          if (booking.status == BookingStatus.cancelled)
            InfoRow(
              icon: Icons.block_rounded,
              label: '취소',
              value: [
                if (booking.cancelledAt != null) Fmt.dateTime(booking.cancelledAt!),
                if (booking.cancelReason != null) booking.cancelReason!,
              ].join('\n'),
            ),
        ],
      ),
    );
  }
}

class _Actions extends ConsumerStatefulWidget {
  const _Actions({required this.booking});

  final Booking booking;

  @override
  ConsumerState<_Actions> createState() => _ActionsState();
}

class _ActionsState extends ConsumerState<_Actions> {
  bool _busy = false;

  Future<void> _cancel() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const _CancelReasonSheet(),
    );
    if (reason == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(bookingRepositoryProvider).cancelBooking(widget.booking.id, reason: reason);
      refreshBookingData(ref, bookingId: widget.booking.id);
      if (mounted) context.showMessage('예약을 취소했어요.');
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reschedule() async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RescheduleSheet(booking: widget.booking),
    );
    if (changed == true && mounted) {
      refreshBookingData(ref, bookingId: widget.booking.id);
      context.showMessage('예약 시간을 변경했어요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final scheme = Theme.of(context).colorScheme;

    if (booking.status == BookingStatus.completed) {
      return FilledButton.icon(
        onPressed: () => context.push(AppRoutes.exerciseHistory),
        icon: const Icon(Icons.insights_rounded),
        label: const Text('운동 기록 보기'),
      );
    }

    if (!booking.status.isActive) return const SizedBox.shrink();

    if (!booking.canModify()) {
      return Text(
        booking.status == BookingStatus.checkedIn
            ? '체크인이 완료되었어요. 운동이 시작되면 운동 탭에서 실시간으로 확인할 수 있어요.'
            : '예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요. 지점으로 문의해 주세요.',
        style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _busy ? null : _cancel,
                child: const Text('예약 취소'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: _busy ? null : _reschedule,
                child: const Text('시간 변경'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '예약 시작 1시간 전까지 변경·취소할 수 있어요.'
          '${booking.usesMembership ? ' 취소하면 이용권 횟수가 복구돼요.' : ''}',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        ),
      ],
    );
  }
}

class _CancelReasonSheet extends StatefulWidget {
  const _CancelReasonSheet();

  @override
  State<_CancelReasonSheet> createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends State<_CancelReasonSheet> {
  static const _reasons = ['일정이 변경되었어요', '반려견 컨디션이 좋지 않아요', '다른 시간으로 다시 예약할게요', '기타'];
  String _selected = _reasons.first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('예약을 취소할까요?', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('취소 사유를 선택해 주세요.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final reason in _reasons)
                  ChoiceChip(
                    label: Text(reason),
                    selected: _selected == reason,
                    onSelected: (_) => setState(() => _selected = reason),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_selected),
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
              child: const Text('예약 취소하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RescheduleSheet extends ConsumerStatefulWidget {
  const _RescheduleSheet({required this.booking});

  final Booking booking;

  @override
  ConsumerState<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends ConsumerState<_RescheduleSheet> {
  late DateTime _date;
  TimeSlot? _slot;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final start = widget.booking.startAt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(start.year, start.month, start.day);
    _date = bookingDay.isBefore(today) ? today : bookingDay;
  }

  Future<void> _submit() async {
    final slot = _slot;
    if (slot == null) return;
    setState(() => _submitting = true);
    try {
      await ref.read(bookingRepositoryProvider).rescheduleBooking(widget.booking.id, slot.start);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        context.showMessage(friendlyError(error));
        ref.invalidate(availableSlotsProvider);
        setState(() {
          _submitting = false;
          _slot = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final programId = booking.programId;
    final theme = Theme.of(context);

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.78,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Text('예약 시간 변경', style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                '현재 ${Fmt.dateTime(booking.startAt)} · ${booking.branch?.name ?? ''}',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            DateStrip(
              selected: _date,
              onSelected: (date) => setState(() {
                _date = date;
                _slot = null;
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: kPagePadding,
                child: programId == null
                    ? const Text('프로그램 정보가 없어 시간을 변경할 수 없어요. 지점으로 문의해 주세요.')
                    : AsyncValueView<List<TimeSlot>>(
                        value: ref.watch(availableSlotsProvider(
                          (branchId: booking.branchId, programId: programId, date: _date),
                        )),
                        onRetry: () => ref.invalidate(availableSlotsProvider),
                        data: (slots) => SlotGrid(
                          slots: slots,
                          selectedStart: _slot?.start,
                          onSelected: (slot) => setState(() => _slot = slot),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FilledButton(
                onPressed: _slot == null || _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      )
                    : Text(_slot == null ? '변경할 시간을 선택해 주세요' : '${Fmt.time(_slot!.start)} 예약으로 변경'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
