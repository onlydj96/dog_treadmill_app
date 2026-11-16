import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/common.dart';
import '../../consents/data/consent.dart';
import '../../consents/data/consent_repository.dart';
import '../../profile/data/app_user.dart';
import '../../profile/data/user_repository.dart';
import '../providers.dart';

/// 랭킹 참여·닉네임·사진 공개 설정. 참여하면 true를 돌려준다.
Future<bool?> showRankingSettingsSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _RankingSettingsSheet(),
  );
}

class _RankingSettingsSheet extends ConsumerWidget {
  const _RankingSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProfileProvider);
    final consents = ref.watch(consentsProvider);
    final participating = ref.watch(rankingConsentGrantedProvider);
    final error = user.error ?? consents.error;

    return SafeArea(
      child: Padding(
        // 키보드가 올라오면 시트도 함께 올린다
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: switch ((user.valueOrNull, participating)) {
          (final AppUser user, final bool participating) => _SettingsForm(user: user, participating: participating),
          _ when error != null => ErrorView(
              message: friendlyError(error),
              onRetry: () {
                ref
                  ..invalidate(currentUserProfileProvider)
                  ..invalidate(consentsProvider);
              },
            ),
          _ => const SizedBox(height: 240, child: LoadingView()),
        },
      ),
    );
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.user, required this.participating});

  final AppUser user;
  final bool participating;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nickname = TextEditingController(text: widget.user.nickname);
  late bool _showPhoto = widget.user.rankingShowPhoto;
  bool _saving = false;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    setState(() => _saving = true);
    try {
      final users = ref.read(userRepositoryProvider);
      final nickname = _nickname.text.trim();
      if (nickname != widget.user.nickname) await users.setNickname(nickname);
      if (_showPhoto != widget.user.rankingShowPhoto) {
        await users.updateRankingShowPhoto(userId, show: _showPhoto);
      }
      if (!widget.participating) {
        await ref.read(consentRepositoryProvider).record(userId, ConsentType.ranking, granted: true);
      }
      ref
        ..invalidate(currentUserProfileProvider)
        ..invalidate(consentsProvider);
      refreshRankingProviders(ref);
      if (!mounted) return;
      context.showMessage(widget.participating ? '랭킹 설정을 저장했어요.' : '랭킹에 참여했어요! 이번 달 순위에 바로 반영돼요.');
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _leave() async {
    final confirmed = await confirmDialog(
      context,
      title: '랭킹에서 나갈까요?',
      message: '순위표와 명예의 전당에서 닉네임과 반려견 정보가 바로 가려져요. '
          '점수와 배지는 그대로 쌓이고, 다시 참여하면 이번 달 순위에 바로 반영돼요.',
      confirmLabel: '나가기',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(consentRepositoryProvider).record(userId, ConsentType.ranking, granted: false);
      ref.invalidate(consentsProvider);
      refreshRankingProviders(ref);
      if (!mounted) return;
      context.showMessage('랭킹에서 나갔어요.');
      Navigator.of(context).pop(false);
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final changeableAt = widget.user.nicknameChangeableAt();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.participating ? '랭킹 설정' : '랭킹에 참여해 볼까요?', style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              '이번 달 가장 꾸준한 반려견은 누구일까요? 운동할수록 점수가 쌓이고, '
              '매달 1~3위는 명예의 전당에 올라요.',
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: scheme.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('다른 회원에게 보이는 정보', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    '· 닉네임\n· 반려견 이름·견종·체구, 프로필 사진(선택)\n· 이번 달 점수·운동 횟수, 배지, 수상 기록',
                    style: TextStyle(color: scheme.onSurfaceVariant, height: 1.6),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '실명·이메일·연락처는 공개되지 않아요.',
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _nickname,
              enabled: changeableAt == null && !_saving,
              maxLength: 12,
              decoration: InputDecoration(
                labelText: '닉네임',
                prefixText: '@',
                // 길이 규칙은 도움말에 있으므로 글자 수 표시는 숨긴다
                counterText: '',
                helperText: changeableAt == null
                    ? '2~12자 한글·영문·숫자·밑줄(_) · 30일에 한 번 바꿀 수 있어요'
                    : '${Fmt.dateShort(changeableAt)}부터 다시 바꿀 수 있어요',
                helperMaxLines: 2,
              ),
              validator: Validators.nickname,
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('반려견 사진 공개', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('끄면 랭킹에 기본 아이콘으로 보여요'),
              value: _showPhoto,
              onChanged: _saving ? null : (value) => setState(() => _showPhoto = value),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                    )
                  : Text(widget.participating ? '저장' : '랭킹 참여하기'),
            ),
            if (widget.participating) ...[
              const SizedBox(height: 4),
              TextButton(
                onPressed: _saving ? null : _leave,
                style: TextButton.styleFrom(foregroundColor: scheme.onSurfaceVariant),
                child: const Text('랭킹에서 나가기'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
