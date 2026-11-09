import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/common.dart';
import '../../consents/data/consent.dart';
import '../data/auth_repository.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final Map<ConsentType, bool> _consents = {for (final type in ConsentType.values) type: false};
  bool _obscure = true;
  bool _submitting = false;

  bool get _allAgreed => _consents.values.every((v) => v);

  bool get _requiredAgreed => ConsentType.values.where((t) => t.isRequired).every((t) => _consents[t] ?? false);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_requiredAgreed) {
      context.showMessage('필수 약관에 동의해 주세요.');
      return;
    }
    setState(() => _submitting = true);
    try {
      final signedIn = await ref.read(authRepositoryProvider).signUp(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            phone: formatPhone(_phoneController.text),
            consents: Map.of(_consents),
          );
      if (!mounted) return;
      if (!signedIn) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('인증 메일을 보냈어요'),
            content: Text('${_emailController.text.trim()}으로 보낸 메일의 링크를 눌러 가입을 완료한 뒤 로그인해 주세요.'),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(minimumSize: const Size(80, 44)),
                child: const Text('확인'),
              ),
            ],
          ),
        );
        if (mounted) context.pop();
      }
      // 바로 로그인된 경우 라우터가 홈으로 이동시킨다.
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text('보호자 정보', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(labelText: '이름'),
                validator: Validators.name,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: const InputDecoration(labelText: '휴대전화 번호', hintText: '010-1234-5678'),
                validator: Validators.phone,
              ),
              const SizedBox(height: 24),
              Text('로그인 정보', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: '이메일'),
                validator: Validators.email,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  helperText: '영문과 숫자를 포함해 8자 이상',
                  suffixIcon: IconButton(
                    tooltip: _obscure ? '비밀번호 보기' : '비밀번호 숨기기',
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                validator: Validators.password,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                validator: (value) => value != _passwordController.text ? '비밀번호가 일치하지 않아요.' : null,
              ),
              const SizedBox(height: 28),
              _ConsentSection(
                consents: _consents,
                allAgreed: _allAgreed,
                onToggleAll: (value) => setState(() {
                  for (final type in ConsentType.values) {
                    _consents[type] = value;
                  }
                }),
                onToggle: (type, value) => setState(() => _consents[type] = value),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                    : const Text('가입하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.consents,
    required this.allAgreed,
    required this.onToggleAll,
    required this.onToggle,
  });

  final Map<ConsentType, bool> consents;
  final bool allAgreed;
  final ValueChanged<bool> onToggleAll;
  final void Function(ConsentType type, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          CheckboxListTile(
            value: allAgreed,
            onChanged: (value) => onToggleAll(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('전체 동의', style: TextStyle(fontWeight: FontWeight.w800)),
            subtitle: const Text('선택 항목을 포함한 모든 항목에 동의합니다.'),
          ),
          const Divider(indent: 20, endIndent: 20),
          for (final type in ConsentType.values)
            ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              tilePadding: const EdgeInsets.only(left: 4, right: 16),
              leading: Checkbox(
                value: consents[type],
                onChanged: (value) => onToggle(type, value ?? false),
              ),
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: type.isRequired ? '[필수] ' : '[선택] ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: type.isRequired ? AppColors.vermilion : scheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(text: type.title),
                  ],
                ),
                style: const TextStyle(fontSize: 14.5),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              children: [
                Text(
                  type.description,
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13, height: 1.5),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
