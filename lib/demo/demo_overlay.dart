import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../core/router/app_router.dart';
import '../core/router/app_routes.dart';
import '../core/supabase/supabase_providers.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/error_messages.dart';
import '../core/utils/formatters.dart';
import '../core/widgets/common.dart';
import '../features/dogs/data/dog.dart';
import '../features/dogs/providers.dart';
import '../features/exercise/data/exercise_session.dart';
import '../features/exercise/providers.dart';
import '../l10n/app_language.dart';
import '../l10n/l10n.dart';
import 'demo_app.dart';
import 'mock_server/mock_server.dart';

/// AI 분석 대기 중인 리포트가 있는지 (목업 서버 테이블 변경을 구독)
final _pendingAnalysisProvider = StreamProvider.autoDispose<bool>((ref) {
  final server = ref.watch(mockServerProvider);
  return server.db.watch('analysis_reports', () => server.analysis.hasPending);
});

/// 모든 화면 위에 떠 있는 DEMO 버튼. 끌어서 옮길 수 있다.
/// 로그아웃 상태에서는 데모 계정으로 바로 로그인하고, 로그인 상태에서는 데모 컨트롤을 연다.
class DemoOverlay extends ConsumerStatefulWidget {
  const DemoOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DemoOverlay> createState() => _DemoOverlayState();
}

class _DemoOverlayState extends ConsumerState<DemoOverlay> {
  Offset? _dragged;

  /// 데모 컨트롤 시트가 열려 있으면 버튼을 숨긴다 (Navigator 위에 떠 있어 시트를 가리므로)
  bool _controlsOpen = false;

  @override
  Widget build(BuildContext context) {
    final loggedIn = ref.watch(currentUserIdProvider) != null;
    final live = loggedIn && ref.watch(liveSessionProvider).valueOrNull != null;
    final media = MediaQuery.of(context);
    // 로그인 화면은 입력칸을 가리지 않게 맨 위, 로그인 뒤에는 앱 바·하단 탭·하단 버튼을 피해 왼쪽 가운데 아래
    final position = _dragged ?? (loggedIn ? Offset(8, media.size.height * 0.62) : Offset(16, media.padding.top + 16));

    return Stack(
      children: [
        widget.child,
        if (!_controlsOpen)
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) => setState(() {
                final next = position + details.delta;
                _dragged = Offset(
                  next.dx.clamp(0, media.size.width - 80),
                  next.dy.clamp(media.padding.top, media.size.height - media.padding.bottom - 48),
                );
              }),
              child: _DemoPill(
                label: loggedIn ? 'DEMO' : context.l10n.demoPillStart,
                live: live,
                onTap: loggedIn ? _openControls : () => ref.read(demoAuthProvider).signInDemo(),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openControls() async {
    // 이 위젯은 Navigator 바깥(MaterialApp.builder)에 있어 라우터의 Navigator로 시트를 띄운다
    final navigatorContext = ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
    if (navigatorContext == null) return;
    setState(() => _controlsOpen = true);
    await showModalBottomSheet<void>(
      context: navigatorContext,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const DemoControlSheet(),
    );
    if (mounted) setState(() => _controlsOpen = false);
  }
}

class _DemoPill extends StatelessWidget {
  const _DemoPill({required this.label, required this.live, required this.onTap});

  final String label;
  final bool live;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: context.l10n.demoControlTitle,
      child: Material(
        color: scheme.inverseSurface.withValues(alpha: 0.92),
        shape: const StadiumBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.science_rounded, size: 16, color: AppColors.honey),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: scheme.onInverseSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                if (live) ...[
                  const SizedBox(width: 6),
                  const PulsingDot(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 데모 컨트롤: 실제로는 매장 기기·AI 서버·다른 회원이 만드는 일을 버튼으로 일으킨다.
class DemoControlSheet extends ConsumerStatefulWidget {
  const DemoControlSheet({super.key});

  @override
  ConsumerState<DemoControlSheet> createState() => _DemoControlSheetState();
}

class _DemoControlSheetState extends ConsumerState<DemoControlSheet> {
  MockServer get _server => ref.read(mockServerProvider);

  /// 목업 서버 동작을 실행하고, 성공하면 시트를 닫고 안내를 띄운다([close]가 false면 열어 둔다).
  /// DB 함수와 같은 오류 코드를 던지므로 앱과 같은 안내 문구를 보여 준다.
  void _act(String done, void Function() action, {String? goTo, bool close = true}) {
    try {
      action();
    } on PostgrestException catch (error) {
      context.showMessage(friendlyError(error));
      return;
    }
    if (close) _closeWith(done, goTo: goTo);
  }

  void _closeWith(String message, {String? goTo}) {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    if (goTo != null) router.go(goTo);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final language = ref.watch(appLanguageProvider);
    final server = ref.watch(mockServerProvider);
    final dog = ref.watch(selectedDogProvider).valueOrNull;
    final live = ref.watch(liveSessionProvider).valueOrNull;
    final pendingAnalysis = ref.watch(_pendingAnalysisProvider).valueOrNull ?? false;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.science_rounded, color: AppColors.honeyDeep),
                const SizedBox(width: 8),
                Text(l10n.demoControlTitle, style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.demoIntro,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            // 발표 중 언어를 바로 바꾸는 줄 (마이페이지 › 설정 › 언어와 같은 선택 시트)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_rounded),
              title: Text(l10n.languageMenuTitle),
              trailing: Text(language.nativeName, style: theme.textTheme.labelLarge),
              onTap: () => showLanguagePicker(context),
            ),
            _SectionTitle(
              title: l10n.demoSectionTreadmill,
              detail: dog == null ? l10n.demoAddDogFirst : l10n.demoTreadmillDetail(dog.name),
            ),
            if (live != null)
              _LiveSessionControls(session: live, onAct: _act)
            else
              FilledButton.icon(
                onPressed: dog == null ? null : () => _startExercise(dog),
                icon: const Icon(Icons.directions_run_rounded),
                label: Text(l10n.demoStartWorkout),
              ),
            const SizedBox(height: 12),
            Text(l10n.demoSpeedTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            SegmentedButton<double>(
              segments: [
                ButtonSegment(value: 1, label: Text(l10n.demoSpeedReal)),
                ButtonSegment(value: 10, label: Text(l10n.demoSpeed10x)),
                ButtonSegment(value: 30, label: Text(l10n.demoSpeed30x)),
              ],
              selected: {server.treadmill.speedFactor},
              onSelectionChanged: (value) => setState(() => server.treadmill.speedFactor = value.first),
            ),
            _SectionTitle(title: l10n.demoSectionAi, detail: l10n.demoAiDetail),
            OutlinedButton.icon(
              onPressed: pendingAnalysis ? () => _act(l10n.demoAiFinished, server.analysis.completeAllPending) : null,
              icon: const Icon(Icons.auto_graph_rounded),
              label: Text(pendingAnalysis ? l10n.demoFinishPending : l10n.demoNoPending),
            ),
            _SectionTitle(title: l10n.demoSectionOwners, detail: l10n.demoOwnersDetail),
            OutlinedButton.icon(
              onPressed: dog == null ? null : () => _receiveCheer(dog),
              icon: const Icon(Icons.favorite_rounded),
              label: Text(l10n.demoReceiveCheer),
            ),
            _SectionTitle(title: l10n.demoSectionData),
            OutlinedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(l10n.demoReset),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.demoAccount(DemoAccount.email, DemoAccount.password),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  void _startExercise(Dog dog) {
    _act(
      context.l10n.demoWorkoutStarted(dog.name),
      () => _server.treadmill.startForDog(dog.id),
      goTo: AppRoutes.exercise,
    );
  }

  void _receiveCheer(Dog dog) {
    if (!_server.db.hasConsent(dog.ownerId, 'ranking')) {
      context.showMessage(context.l10n.demoCheerNeedsConsent);
      return;
    }
    final nickname = _server.cheerFromAnotherUser(dog.id);
    if (nickname == null) {
      context.showMessage(context.l10n.demoCheerAllDone);
      return;
    }
    _closeWith(context.l10n.demoCheerReceived(nickname, particle(dog.name, '를', '을')));
  }

  Future<void> _reset() async {
    final confirmed = await confirmDialog(
      context,
      title: context.l10n.demoResetTitle,
      message: context.l10n.demoResetMessage,
      confirmLabel: context.l10n.demoResetConfirm,
    );
    if (!confirmed || !mounted) return;
    final restart = ref.read(demoRestartProvider);
    Navigator.of(context).pop();
    restart();
  }
}

class _LiveSessionControls extends ConsumerWidget {
  const _LiveSessionControls({required this.session, required this.onAct});

  final ExerciseSession session;
  final void Function(String done, void Function() action, {String? goTo, bool close}) onAct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final treadmill = ref.read(mockServerProvider).treadmill;
    final paused = session.status == SessionStatus.paused;
    final target = session.targetDurationSeconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            [
              session.status.label,
              '${Fmt.timer(session.durationSeconds)}${target == null ? '' : ' / ${Fmt.timer(target)}'}',
              '${session.distanceMeters.round()}m',
              '${session.currentSpeed.toStringAsFixed(1)}km/h',
            ].join(' · '),
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onAct(
                  paused ? l10n.demoResumed : l10n.demoPaused,
                  () => treadmill.setPaused(session.id, paused: !paused),
                  close: false,
                ),
                child: Text(paused ? l10n.demoResume : l10n.demoPause),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.coral),
                onPressed: () => onAct(
                  l10n.demoEmergencyDone,
                  // 기기가 서버에 남기는 중단 사유 (한국어 기본값 + 데모 영어 값)
                  () => treadmill.finish(
                    session.id,
                    completed: false,
                    stopReason: '비상정지 버튼으로 중단',
                    stopReasonEn: 'Stopped with the emergency stop button',
                  ),
                ),
                child: Text(l10n.demoEmergencyStop),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () => onAct(l10n.demoFinishedDone, () => treadmill.completeNow(session.id)),
                child: Text(l10n.demoFinishNow),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.detail});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          if (detail != null) ...[
            const SizedBox(height: 2),
            Text(detail!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}
