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
import '../../../l10n/l10n.dart';
import '../../../l10n/server_text.dart';
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
      appBar: AppBar(title: Text(context.l10n.bookingDetailTitle)),
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
              '${booking.program?.name ?? context.l10n.bookingDefaultProgramName} · ${booking.dog?.name ?? ''}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// 예약 확정 → 체크인 → 이용 완료 진행 단계.
/// 예약은 만들 때 바로 확정되므로 승인 단계는 없다. 'pending'(앱 결제 진행 중, 예정)도 첫 단계로 보여 준다.
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
                status == BookingStatus.cancelled ? context.l10n.bookingNoteCancelled : context.l10n.bookingNoteNoShow,
              ),
            ),
          ],
        ),
      );
    }

    final l10n = context.l10n;
    final steps = [
      (BookingStatus.confirmed, l10n.bookingStepConfirmed),
      (BookingStatus.checkedIn, l10n.bookingStepCheckedIn),
      (BookingStatus.completed, l10n.bookingStepCompleted),
    ];
    final current = status == BookingStatus.pending ? BookingStatus.confirmed : status;
    final currentIndex = steps.indexWhere((s) => s.$1 == current);

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
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(icon: Icons.pets_rounded, label: l10n.bookingInfoDog, value: booking.dog?.name ?? '-'),
          InfoRow(
            icon: Icons.storefront_rounded,
            label: l10n.bookingInfoLocation,
            value: branch == null ? '-' : '${branch.name}\n${branch.address}',
          ),
          InfoRow(
            icon: Icons.directions_run_rounded,
            label: l10n.bookingInfoTreadmill,
            value: booking.treadmill?.deviceName ?? '-',
          ),
          InfoRow(
            icon: Icons.fitness_center_rounded,
            label: l10n.bookingInfoProgram,
            value: program == null
                ? '-'
                : [program.name, l10n.bookingDurationMinutes(program.durationMinutes), program.intensity.label].join(' · '),
          ),
          InfoRow(
            icon: Icons.confirmation_number_outlined,
            label: l10n.bookingInfoPayment,
            value: booking.usesMembership ? l10n.bookingPayWithPass : l10n.bookingPayOnSite,
          ),
          if (booking.note != null) InfoRow(icon: Icons.edit_note_rounded, label: l10n.bookingInfoNote, value: booking.note!),
          if (booking.status == BookingStatus.cancelled)
            InfoRow(
              icon: Icons.block_rounded,
              label: l10n.bookingInfoCancellation,
              value: [
                if (booking.cancelledAt != null) Fmt.dateTime(booking.cancelledAt!),
                if (booking.cancelReason != null) localizedCancelReason(booking.cancelReason!),
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
      if (mounted) context.showMessage(context.l10n.bookingCancelledToast);
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
      context.showMessage(context.l10n.bookingRescheduledToast);
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
        label: Text(context.l10n.bookingViewWorkoutHistory),
      );
    }

    if (!booking.status.isActive) return const SizedBox.shrink();

    final hintStyle = TextStyle(color: scheme.onSurfaceVariant, fontSize: 13, height: 1.5);
    final machine = booking.treadmill?.deviceName;
    final l10n = context.l10n;
    final atMachine = machine == null ? l10n.bookingAtAssignedMachine : l10n.bookingAtMachine(machine);
    final payOnSite = booking.usesMembership ? '' : l10n.bookingPayOnSiteNotice;

    // 무인 매장: 체크인 후 보호자가 트레드밀 기기에서 직접 운동을 시작한다.
    if (booking.status == BookingStatus.checkedIn) {
      return Text(l10n.bookingGuideCheckedIn(atMachine, payOnSite), style: hintStyle);
    }

    final now = DateTime.now();
    final canCheckIn = booking.canCheckIn(now);
    final canModify = booking.canModify(now);
    final ended = !now.isBefore(booking.endAt);

    final String guide;
    if (ended) {
      guide = l10n.bookingGuideEnded;
    } else if (canCheckIn) {
      guide = l10n.bookingGuideCheckInOpen(payOnSite);
    } else if (canModify) {
      final opensAt = Fmt.time(booking.checkInOpensAt);
      guide = booking.usesMembership
          ? l10n.bookingGuideModifiableWithPass(opensAt)
          : l10n.bookingGuideModifiable(opensAt);
    } else {
      guide = l10n.bookingGuideLocked(Fmt.time(booking.checkInOpensAt));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canCheckIn) ...[
          CheckInButton(booking: booking),
          const SizedBox(height: 12),
        ],
        if (canModify) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy ? null : _cancel,
                  child: Text(l10n.bookingCancelAction),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _busy ? null : _reschedule,
                  child: Text(l10n.bookingRescheduleAction),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Text(guide, style: hintStyle),
        // 무인 매장이라 지점 전화 대신 1:1 문의로 안내한다.
        if (!canModify && !canCheckIn)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.push(AppRoutes.inquiryNew),
              child: Text(l10n.bookingInquiryAction),
            ),
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
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final reasons = cancelReasonPresets(l10n);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.bookingCancelSheetTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(l10n.bookingCancelSheetSubtitle, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < reasons.length; i++)
                  ChoiceChip(
                    label: Text(reasons[i]),
                    selected: _selected == i,
                    onSelected: (_) => setState(() => _selected = i),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(cancelReasonForServer(_selected)),
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral),
              child: Text(l10n.bookingCancelConfirmAction),
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
              child: Text(context.l10n.bookingRescheduleTitle, style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                context.l10n.bookingRescheduleCurrent(Fmt.dateTime(booking.startAt), booking.branch?.name ?? ''),
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
                    ? Text(context.l10n.bookingRescheduleNoProgram)
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
                    : Text(
                        _slot == null
                            ? context.l10n.bookingReschedulePick
                            : context.l10n.bookingRescheduleSubmit(Fmt.time(_slot!.start)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
