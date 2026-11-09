import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../data/booking_models.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status, this.dense = false});

  final BookingStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (tone, icon) = switch (status) {
      BookingStatus.pending => (scheme.cautionTone, Icons.schedule_rounded),
      BookingStatus.confirmed => (scheme.activeTone, Icons.check_circle_rounded),
      BookingStatus.checkedIn => (scheme.calmTone, Icons.how_to_reg_rounded),
      BookingStatus.completed => (scheme.neutralTone, Icons.flag_rounded),
      BookingStatus.cancelled => (scheme.neutralTone, Icons.block_rounded),
      BookingStatus.noShow => (scheme.alertTone, Icons.person_off_rounded),
    };
    return StatusBadge(label: status.label, tone: tone, icon: icon, dense: dense);
  }
}

/// 예약 목록 카드
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, this.onTap});

  final Booking booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final start = booking.startAt.toLocal();
    final dimmed = booking.status == BookingStatus.cancelled || booking.status == BookingStatus.noShow;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: dimmed ? scheme.surfaceContainerHigh : AppColors.peach,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  '${start.month}월',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: dimmed ? scheme.onSurfaceVariant : AppColors.burgundy,
                  ),
                ),
                Text(
                  '${start.day}',
                  style: AppText.numeric(24, color: dimmed ? scheme.onSurfaceVariant : AppColors.burgundyDeep),
                ),
                Text(
                  Fmt.weekday(start),
                  style: TextStyle(fontSize: 11.5, color: dimmed ? scheme.onSurfaceVariant : AppColors.burgundy),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.program?.name ?? '트레드밀 운동',
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    BookingStatusBadge(status: booking.status, dense: true),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  Fmt.timeRange(booking.startAt, booking.endAt),
                  style: AppText.numeric(15, weight: FontWeight.w600, color: scheme.onSurface),
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    if (booking.dog != null) booking.dog!.name,
                    if (booking.branch != null) booking.branch!.name,
                    if (booking.treadmill != null) booking.treadmill!.deviceName,
                  ].join(' · '),
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2주간의 날짜 선택 스트립
class DateStrip extends StatelessWidget {
  const DateStrip({super.key, required this.selected, required this.onSelected, this.days = 14});

  final DateTime selected;
  final ValueChanged<DateTime> onSelected;
  final int days;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: kPagePadding,
        itemCount: days,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = today.add(Duration(days: index));
          final isSelected = DateUtils.isSameDay(date, selected);
          // 한국 달력 관례: 토요일 파랑 계열(보라), 일요일 빨강 계열(버밀리언)
          final foreground = isSelected
              ? Colors.white
              : switch (date.weekday) {
                  DateTime.saturday => scheme.tertiary,
                  DateTime.sunday => scheme.primary,
                  _ => scheme.onSurface,
                };
          return Semantics(
            container: true,
            button: true,
            selected: isSelected,
            label: '${date.month}월 ${date.day}일 ${Fmt.weekday(date)}요일${index == 0 ? ', 오늘' : ''}',
            excludeSemantics: true,
            child: Material(
              color: isSelected ? scheme.primary : scheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: isSelected ? scheme.primary : scheme.outlineVariant),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => onSelected(date),
                child: SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index == 0 ? '오늘' : Fmt.weekday(date),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: foreground),
                      ),
                      const SizedBox(height: 4),
                      Text('${date.day}', style: AppText.numeric(20, color: foreground)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 예약 가능 시간 선택 (잔여 트레드밀 수 표시)
class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.slots,
    required this.selectedStart,
    required this.onSelected,
  });

  final List<TimeSlot> slots;
  final DateTime? selectedStart;
  final ValueChanged<TimeSlot> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('선택한 날짜에 예약 가능한 시간이 없어요.', style: TextStyle(color: scheme.onSurfaceVariant)),
        ),
      );
    }

    final morning = slots.where((s) => s.start.toLocal().hour < 12).toList();
    final afternoon = slots.where((s) => s.start.toLocal().hour >= 12).toList();

    Widget group(String title, List<TimeSlot> items) {
      if (items.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, fontSize: 13)),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final width = (constraints.maxWidth - spacing * 3) / 4;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final slot in items)
                      SizedBox(
                        width: width,
                        child: _SlotCell(
                          slot: slot,
                          selected: selectedStart != null && slot.start.isAtSameMomentAs(selectedStart!),
                          onTap: slot.isAvailable ? () => onSelected(slot) : null,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [group('오전', morning), group('오후', afternoon)],
    );
  }
}

class _SlotCell extends StatelessWidget {
  const _SlotCell({required this.slot, required this.selected, this.onTap});

  final TimeSlot slot;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final local = slot.start.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final label = '$hour12:${local.minute.toString().padLeft(2, '0')}';
    final foreground = selected
        ? Colors.white
        : enabled
            ? scheme.onSurface
            : scheme.onSurfaceVariant.withValues(alpha: 0.5);
    final few = slot.availableCount <= 1;

    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      selected: selected,
      label: '${Fmt.time(slot.start)}, ${enabled ? '잔여 ${slot.availableCount}대' : '마감'}',
      excludeSemantics: true,
      child: Material(
        color: selected
            ? scheme.primary
            : enabled
                ? scheme.surfaceContainerLowest
                : scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Column(
              children: [
                Text(label, style: AppText.numeric(16, color: foreground)),
                const SizedBox(height: 2),
                Text(
                  enabled ? '잔여 ${slot.availableCount}' : '마감',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white.withValues(alpha: 0.85)
                        : enabled && few
                            ? scheme.primary
                            : foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
