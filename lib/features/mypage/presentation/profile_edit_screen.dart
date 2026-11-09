import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../auth/data/auth_repository.dart';
import '../../profile/data/app_user.dart';
import '../../profile/data/user_repository.dart';

/// 프로필 수정 + 로그인 계정 관리 (문서 3.5 회원 관리)
class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 및 로그인 계정')),
      body: AsyncValueView<AppUser?>(
        value: ref.watch(currentUserProfileProvider),
        onRetry: () => ref.invalidate(currentUserProfileProvider),
        data: (user) => user == null ? const SizedBox.shrink() : _ProfileForm(user: user),
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.user});

  final AppUser user;

  @override
  ConsumerState<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _profileKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(text: widget.user.name);
  late final TextEditingController _phoneController = TextEditingController(text: widget.user.phone ?? '');
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _savingProfile = false;
  bool _savingPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_profileKey.currentState!.validate()) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    setState(() => _savingProfile = true);
    try {
      await ref.read(userRepositoryProvider).updateProfile(
            userId,
            name: _nameController.text,
            phone: formatPhone(_phoneController.text),
          );
      ref.invalidate(currentUserProfileProvider);
      if (mounted) {
        context.showMessage('프로필을 저장했어요.');
        context.pop();
      }
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordKey.currentState!.validate()) return;
    setState(() => _savingPassword = true);
    try {
      await ref.read(authRepositoryProvider).updatePassword(_passwordController.text);
      _passwordController.clear();
      _confirmController.clear();
      if (mounted) context.showMessage('비밀번호를 변경했어요.');
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = ref.watch(authRepositoryProvider).currentEmail;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        Text('프로필', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Form(
          key: _profileKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: Validators.name,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '휴대전화 번호'),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _savingProfile ? null : _saveProfile,
                child: _savingProfile
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : const Text('프로필 저장'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Text('로그인 계정', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: InfoRow(icon: Icons.mail_outline_rounded, label: '이메일', value: email ?? '-'),
        ),
        const SizedBox(height: 16),
        Form(
          key: _passwordKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '새 비밀번호', helperText: '영문과 숫자를 포함해 8자 이상'),
                validator: Validators.password,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '새 비밀번호 확인'),
                validator: (value) => value != _passwordController.text ? '비밀번호가 일치하지 않아요.' : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _savingPassword ? null : _changePassword,
                child: _savingPassword
                    ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4))
                    : const Text('비밀번호 변경'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
