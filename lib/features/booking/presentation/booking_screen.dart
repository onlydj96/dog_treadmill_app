import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../../dogs/data/dog.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../../dogs/providers.dart';
import '../../membership/data/membership_models.dart';
import '../../membership/providers.dart';
import '../data/booking_models.dart';
import '../providers.dart';
import 'widgets/booking_widgets.dart';

/// 새 운동 예약 (문서 3.2)
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _noteController = TextEditingController();
  String? _dogId;
  String? _branchId;
  String? _programId;
  late DateTime _date;
  TimeSlot? _slot;
  String? _membershipId;
  bool _membershipTouched = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _resetSlot() {
    _slot = null;
  }

  /// 선택한 시간에 쓸 이용권 (직접 고르지 않았으면 만료가 가장 빠른 이용권 자동 적용)
  Membership? _effectiveMembership(List<Membership> usable) {
    if (usable.isEmpty) return null;
    if (!_membershipTouched) return usable.first;
    if (_membershipId == null) return null;
    for (final membership in usable) {
      if (membership.id == _membershipId) return membership;
    }
    return null;
  }

  List<Membership> _usableMemberships(List<Membership> all) {
    final slot = _slot;
    if (slot == null) return all.where((m) => m.isUsable()).toList();
    return all.where((m) => m.isUsableFor(slot.start, slot.end)).toList()
      ..sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
  }

  Future<void> _submit({
    required String dogId,
    required String branchId,
    required String programId,
    required Membership? membership,
  }) async {
    final slot = _slot;
    if (slot == null) return;
    setState(() => _submitting = true);
    try {
      final bookingId = await ref.read(bookingRepositoryProvider).createBooking(
            dogId: dogId,
            branchId: branchId,
            programId: programId,
            startAt: slot.start,
            membershipId: membership?.id,
            note: _noteController.text,
          );
      refreshBookingData(ref);
      if (!mounted) return;
      context.showMessage(
        membership != null ? context.l10n.bookingConfirmedToast : context.l10n.bookingReceivedToast,
      );
      context.pushReplacement(AppRoutes.bookingDetail(bookingId));
    } catch (error) {
      if (!mounted) return;
      context.showMessage(friendlyError(error));
      if (error is PostgrestException && (error.message == 'SLOT_FULL' || error.message == 'SLOT_IN_PAST')) {
        ref.invalidate(availableSlotsProvider);
        setState(_resetSlot);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dogs = ref.watch(dogsProvider);
    final branches = ref.watch(branchesProvider);
    final programs = ref.watch(programsProvider);
    final memberships = ref.watch(membershipsProvider).valueOrNull ?? const <Membership>[];
    final l10n = context.l10n;

    final dogList = dogs.valueOrNull ?? const <Dog>[];
    final dogId = _dogId ?? ref.watch(activeDogIdProvider);
    final dog = dogList.where((d) => d.id == dogId).firstOrNull;
    final branchList = branches.valueOrNull ?? const <Branch>[];
    final branchId = _branchId ?? branchList.firstOrNull?.id;
    final programList = programs.valueOrNull ?? const <ExerciseProgram>[];
    final program = programList.where((p) => p.id == _programId).firstOrNull;
    final branch = branchList.where((b) => b.id == branchId).firstOrNull;
    final usable = _usableMemberships(memberships);
    final membership = _effectiveMembership(usable);

    VoidCallback? onSubmit;
    if (dog != null && branch != null && program != null && _slot != null && !_submitting) {
      onSubmit = () => _submit(dogId: dog.id, branchId: branch.id, programId: program.id, membership: membership);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingNewTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _StepHeader(number: 1, title: l10n.bookingStepDog),
          AsyncValueView<List<Dog>>(
            value: dogs,
            onRetry: () => ref.invalidate(dogsProvider),
            data: (list) {
              if (list.isEmpty) {
                return Padding(
                  padding: kPagePadding,
                  child: AppCard(
                    child: Row(
                      children: [
                        Expanded(child: Text(l10n.bookingNeedDogMessage)),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.dogNew),
                          child: Text(l10n.bookingNeedDogAction),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: kPagePadding,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final selected = item.id == dogId;
                    return ChoiceChip(
                      selected: selected,
                      showCheckmark: false,
                      avatar: DogAvatar(dog: item, size: 28),
                      label: Text(item.name),
                      onSelected: (_) => setState(() {
                        _dogId = item.id;
                        _resetSlot();
                      }),
                    );
                  },
                ),
              );
            },
          ),
          if (dog != null) _RestrictionNotice(dogId: dog.id),
          _StepHeader(number: 2, title: l10n.bookingStepBranch),
          AsyncValueView<List<Branch>>(
            value: branches,
            onRetry: () => ref.invalidate(branchesProvider),
            data: (list) => Padding(
              padding: kPagePadding,
              child: Column(
                children: [
                  for (final item in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SelectableCard(
                        selected: item.id == branchId,
                        onTap: () => setState(() {
                          _branchId = item.id;
                          _resetSlot();
                        }),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text(item.address, style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            if (item.is24Hours)
                              StatusBadge(
                                label: item.hoursLabel,
                                tone: Theme.of(context).colorScheme.calmTone,
                                icon: Icons.schedule_rounded,
                                dense: true,
                              )
                            else
                              Text(item.hoursLabel, style: AppText.numeric(13, weight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _StepHeader(number: 3, title: l10n.bookingStepProgram),
          AsyncValueView<List<ExerciseProgram>>(
            value: programs,
            onRetry: () => ref.invalidate(programsProvider),
            data: (list) => Padding(
              padding: kPagePadding,
              child: Column(
                children: [
                  for (final item in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ProgramCard(
                        program: item,
                        selected: item.id == _programId,
                        onTap: () => setState(() {
                          _programId = item.id;
                          _resetSlot();
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _StepHeader(number: 4, title: l10n.bookingStepDate),
          DateStrip(
            selected: _date,
            onSelected: (date) => setState(() {
              _date = date;
              _resetSlot();
            }),
          ),
          _StepHeader(number: 5, title: l10n.bookingStepTime),
          Padding(
            padding: kPagePadding,
            child: (branchId == null || program == null)
                ? _Hint(text: l10n.bookingTimeHint)
                : AsyncValueView<List<TimeSlot>>(
                    value: ref.watch(
                      availableSlotsProvider((branchId: branchId, programId: program.id, date: _date)),
                    ),
                    onRetry: () => ref.invalidate(availableSlotsProvider),
                    data: (slots) => SlotGrid(
                      slots: slots,
                      selectedStart: _slot?.start,
                      onSelected: (slot) => setState(() => _slot = slot),
                    ),
                  ),
          ),
          _StepHeader(number: 6, title: l10n.bookingStepPayment),
          Padding(
            padding: kPagePadding,
            child: Column(
              children: [
                for (final item in usable)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _SelectableCard(
                      selected: membership?.id == item.id,
                      onTap: () => setState(() {
                        _membershipTouched = true;
                        _membershipId = item.id;
                      }),
                      child: Row(
                        children: [
                          const Icon(Icons.confirmation_number_rounded, color: AppColors.mintDeep),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.planName, style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(l10n.bookingPassValidUntil(Fmt.dateShort(item.expiresAt)), style: const TextStyle(fontSize: 12.5)),
                              ],
                            ),
                          ),
                          Text(l10n.bookingPassRemaining(item.remainingSessions), style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: _AppPaymentOption(),
                ),
                _SelectableCard(
                  selected: membership == null,
                  onTap: () => setState(() {
                    _membershipTouched = true;
                    _membershipId = null;
                  }),
                  child: Row(
                    children: [
                      const Icon(Icons.storefront_rounded, color: AppColors.mintDeep),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.bookingPayOnSite, style: const TextStyle(fontWeight: FontWeight.w800)),
                            Text(l10n.bookingPayOnSiteBody, style: const TextStyle(fontSize: 12.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _StepHeader(number: 7, title: l10n.bookingStepNote),
          Padding(
            padding: kPagePadding,
            child: TextField(
              controller: _noteController,
              maxLength: 500,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(hintText: l10n.bookingNoteHint),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: _Hint(text: l10n.bookingSelfServiceHint),
          ),
        ],
      ),
      bottomNavigationBar: _SummaryBar(
        summary: (dog != null && program != null && _slot != null)
            ? l10n.bookingSummary(
                dog.name,
                Fmt.dateTime(_slot!.start),
                program.name,
                l10n.bookingDurationMinutes(program.durationMinutes),
                membership != null ? l10n.bookingSummaryPayWithPass : l10n.bookingPayOnSite,
              )
            : l10n.bookingSummaryIncomplete,
        submitting: _submitting,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.mintDeep, shape: BoxShape.circle),
            child: Text('$number', style: AppText.numeric(13, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({required this.selected, required this.onTap, required this.child});

  final bool selected;

  /// null이면 고를 수 없는 항목(예: 준비 중인 앱 결제)으로 흐리게 보여 준다.
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;
    final card = Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 1.6 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: selected ? scheme.onPrimaryContainer : scheme.onSurface),
            child: child,
          ),
        ),
      ),
    );
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      selected: selected,
      child: enabled ? card : Opacity(opacity: 0.6, child: card),
    );
  }
}

/// 앱 결제(PG). 아직 연동 전이라 형식만 두고 고를 수 없게 한다.
/// PG를 연동하면 선택할 수 있게 열고, 결제 완료 시 예약을 확정한다.
class _AppPaymentOption extends StatelessWidget {
  const _AppPaymentOption();

  @override
  Widget build(BuildContext context) {
    return _SelectableCard(
      selected: false,
      onTap: null,
      child: Row(
        children: [
          const Icon(Icons.smartphone_rounded, color: AppColors.mintDeep),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.bookingAppPaymentTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(context.l10n.bookingAppPaymentBody, style: const TextStyle(fontSize: 12.5)),
              ],
            ),
          ),
          StatusBadge(label: context.l10n.bookingComingSoon, tone: Theme.of(context).colorScheme.neutralTone, dense: true),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, required this.selected, required this.onTap});

  final ExerciseProgram program;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // 선택 카드 배경(연민트)과 겹치지 않도록 강도는 청록 → 허니 → 코랄 순으로 진해진다.
    final tone = switch (program.intensity) {
      ProgramIntensity.low => scheme.calmTone,
      ProgramIntensity.medium => scheme.cautionTone,
      ProgramIntensity.high => scheme.alertTone,
    };
    return _SelectableCard(
      selected: selected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(program.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              StatusBadge(label: program.intensity.label, tone: tone, dense: true),
            ],
          ),
          if (program.description != null) ...[
            const SizedBox(height: 4),
            Text(program.description!, style: const TextStyle(fontSize: 13, height: 1.45)),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16),
              const SizedBox(width: 4),
              Text(context.l10n.bookingDurationMinutes(program.durationMinutes), style: AppText.numeric(14, weight: FontWeight.w600)),
              if (program.targetSpeedKmh != null) ...[
                const SizedBox(width: 14),
                const Icon(Icons.speed_rounded, size: 16),
                const SizedBox(width: 4),
                Text(Fmt.speed(program.targetSpeedKmh), style: AppText.numeric(14, weight: FontWeight.w600)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 반려견에게 등록된 운동 제한 사항 안내
class _RestrictionNotice extends ConsumerWidget {
  const _RestrictionNotice({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(dogHealthProfileProvider(dogId)).valueOrNull;
    final restrictions = profile?.exerciseRestrictions ?? const [];
    if (restrictions.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: scheme.cautionTone.background, borderRadius: BorderRadius.circular(16)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.health_and_safety_rounded, color: scheme.cautionTone.foreground, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.bookingRestrictionNotice(restrictions.map((e) => e.name).join(', ')),
                style: TextStyle(color: scheme.cautionTone.foreground, fontSize: 13, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.45))),
      ],
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.summary, required this.submitting, required this.onSubmit});

  final String summary;
  final bool submitting;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(summary,
                  style: TextStyle(
                      fontSize: 13, height: 1.45, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: onSubmit,
                child: submitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      )
                    : Text(context.l10n.bookingSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
