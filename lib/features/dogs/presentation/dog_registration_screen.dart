import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../data/dog.dart';
import '../providers.dart';
import 'widgets/dog_avatar.dart';

/// 반려견 등록·수정 (화면 3 DogRegistrationScreen)
///
/// 견종·체구·나이·체중·중성화·질병은 AI 운동 강도 산정과 금기 규칙의 입력이라 필수로 받는다.
class DogRegistrationScreen extends ConsumerWidget {
  const DogRegistrationScreen({super.key, this.dogId});

  /// null이면 신규 등록
  final String? dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = dogId;
    final title = id == null ? '반려견 등록' : '반려견 정보 수정';
    final breeds = ref.watch(breedsProvider);
    final conditions = ref.watch(healthConditionsProvider);
    final AsyncValue<Dog?> dog = id == null ? const AsyncData(null) : ref.watch(dogDetailProvider(id));
    final AsyncValue<DogHealthProfile?> profile =
        id == null ? const AsyncData(null) : ref.watch(dogHealthProfileProvider(id));

    final states = <AsyncValue<Object?>>[breeds, conditions, dog, profile];
    final failed = states.where((state) => state.hasError).firstOrNull;
    if (failed != null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ErrorView(
          message: friendlyError(failed.error!),
          onRetry: () {
            ref
              ..invalidate(breedsProvider)
              ..invalidate(healthConditionsProvider);
            if (id != null) {
              ref
                ..invalidate(dogDetailProvider(id))
                ..invalidate(dogHealthProfileProvider(id));
            }
          },
        ),
      );
    }
    if (states.any((state) => !state.hasValue)) {
      return Scaffold(appBar: AppBar(title: Text(title)), body: const LoadingView());
    }
    return _DogForm(
      dog: dog.value,
      profile: profile.value,
      breeds: breeds.requireValue,
      conditions: conditions.requireValue,
    );
  }
}

enum _AgeInput { birthDate, estimate }

class _DogForm extends ConsumerStatefulWidget {
  const _DogForm({
    required this.dog,
    required this.profile,
    required this.breeds,
    required this.conditions,
  });

  final Dog? dog;
  final DogHealthProfile? profile;
  final List<Breed> breeds;
  final List<HealthCondition> conditions;

  @override
  ConsumerState<_DogForm> createState() => _DogFormState();
}

class _DogFormState extends ConsumerState<_DogForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _vetNotesController;
  late final TextEditingController _ageYearsController;
  late final TextEditingController _ageMonthsController;
  late String _breed;
  late bool _isMixed;
  DogSize? _size;
  late bool _brachycephalic;
  late _AgeInput _ageInput;
  DateTime? _birthDate;
  DogSex? _sex;
  bool? _neutered;
  late Set<String> _conditionCodes;
  late bool _noConditions;
  late List<HealthItem> _diseases;
  late List<HealthItem> _surgeries;
  late List<HealthItem> _medications;
  late List<HealthItem> _restrictions;
  Uint8List? _imageBytes;
  String _imageExtension = 'jpg';
  bool _saving = false;

  /// 저장을 한 번 시도한 뒤부터 선택형 필수 항목의 오류를 보여 준다
  bool _showErrors = false;

  bool get _isEdit => widget.dog != null;

  /// 믹스견이 아니고 입력한 이름이 카탈로그와 같으면 카탈로그 견종 (체구·단두종 자동)
  Breed? get _catalogBreed {
    if (_isMixed) return null;
    final name = _breed.trim();
    for (final breed in widget.breeds) {
      if (breed.name == name) return breed;
    }
    return null;
  }

  bool get _conditionsAnswered => _noConditions || _conditionCodes.isNotEmpty;

  String? get _breedHelperText {
    final breed = _catalogBreed;
    if (breed != null) {
      return [
        '${breed.size.label}견',
        if (breed.isBrachycephalic) '단두종',
      ].join(' · ');
    }
    if (!_isMixed && _breed.trim().isNotEmpty) return '목록에 없는 견종이에요. 아래에서 체구를 골라 주세요.';
    return null;
  }

  @override
  void initState() {
    super.initState();
    final dog = widget.dog;
    final profile = widget.profile;
    final estimated = dog?.birthDateEstimated ?? false;
    final estimatedMonths = estimated && dog?.birthDate != null ? Fmt.dogAgeMonths(dog!.birthDate!) : null;
    _nameController = TextEditingController(text: dog?.name ?? '');
    _weightController = TextEditingController(text: dog?.weightKg == null ? '' : _trimNumber(dog!.weightKg!));
    _vetNotesController = TextEditingController(text: profile?.veterinaryNotes ?? '');
    _ageYearsController = TextEditingController(text: estimatedMonths == null ? '' : '${estimatedMonths ~/ 12}');
    _ageMonthsController = TextEditingController(text: estimatedMonths == null ? '' : '${estimatedMonths % 12}');
    _breed = dog?.breed ?? '';
    _isMixed = dog?.isMixed ?? false;
    _size = dog?.size;
    _brachycephalic = dog?.isBrachycephalic ?? false;
    _ageInput = estimated ? _AgeInput.estimate : _AgeInput.birthDate;
    _birthDate = estimated ? null : dog?.birthDate;
    _sex = dog?.sex;
    _neutered = dog?.neutered;
    final codes = profile?.conditionCodes;
    _conditionCodes = {...?codes};
    _noConditions = codes != null && codes.isEmpty;
    _diseases = [...?profile?.diseases];
    _surgeries = [...?profile?.surgeries];
    _medications = [...?profile?.medications];
    _restrictions = [...?profile?.exerciseRestrictions];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _vetNotesController.dispose();
    _ageYearsController.dispose();
    _ageMonthsController.dispose();
    super.dispose();
  }

  int? get _estimatedMonths {
    final years = int.tryParse(_ageYearsController.text.trim().isEmpty ? '0' : _ageYearsController.text.trim());
    final months = int.tryParse(_ageMonthsController.text.trim().isEmpty ? '0' : _ageMonthsController.text.trim());
    if (years == null || months == null) return null;
    return years * 12 + months;
  }

  /// 추정 나이 → 생년월일. 나이를 바꾸지 않았으면 저장된 날짜를 그대로 쓴다.
  DateTime? _resolveBirthDate() {
    if (_ageInput == _AgeInput.birthDate) return _birthDate;
    final months = _estimatedMonths;
    if (months == null) return null;
    final saved = widget.dog;
    if (saved != null &&
        saved.birthDateEstimated &&
        saved.birthDate != null &&
        Fmt.dogAgeMonths(saved.birthDate!) == months) {
      return saved.birthDate;
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month - months, 1);
  }

  String? _validateAgeYears(String? value) {
    final yearsText = value?.trim() ?? '';
    final monthsText = _ageMonthsController.text.trim();
    if (yearsText.isEmpty && monthsText.isEmpty) return '나이를 입력해 주세요.';
    final years = int.tryParse(yearsText.isEmpty ? '0' : yearsText);
    if (years == null || years > 30) return '30살 이하로 입력해 주세요.';
    final total = _estimatedMonths;
    if (total != null && total < 1) return '1개월 이상으로 입력해 주세요.';
    return null;
  }

  String? _validateAgeMonths(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final months = int.tryParse(text);
    if (months == null || months > 11) return '0~11개월';
    return null;
  }

  static String _trimNumber(double value) => value % 1 == 0 ? value.toInt().toString() : value.toString();

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('앨범에서 선택'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('사진 촬영'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final file = await ImagePicker().pickImage(source: source, maxWidth: 1024, imageQuality: 85);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final name = file.name;
      setState(() {
        _imageBytes = bytes;
        _imageExtension = name.contains('.') ? name.split('.').last : 'jpg';
      });
    } catch (error) {
      if (mounted) context.showMessage('사진을 불러오지 못했어요. 권한을 확인해 주세요.');
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 2, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
      helpText: '생년월일 선택',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    setState(() => _showErrors = true);
    final fieldsValid = _formKey.currentState!.validate();
    final catalogBreed = _catalogBreed;
    final birthDate = _resolveBirthDate();
    final choicesValid =
        (catalogBreed != null || _size != null) && birthDate != null && _neutered != null && _conditionsAnswered;
    if (!fieldsValid || !choicesValid) {
      context.showMessage('표시된 필수 항목을 확인해 주세요.');
      return;
    }
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _saving = true);
    final repo = ref.read(dogRepositoryProvider);
    final draft = DogDraft(
      name: _nameController.text,
      breed: catalogBreed?.name ?? _breed,
      breedId: catalogBreed?.id,
      isMixed: _isMixed,
      size: catalogBreed?.size ?? _size,
      isBrachycephalic: catalogBreed?.isBrachycephalic ?? _brachycephalic,
      birthDate: birthDate,
      birthDateEstimated: _ageInput == _AgeInput.estimate,
      sex: _sex,
      neutered: _neutered,
      weightKg: double.tryParse(_weightController.text.trim()),
    );

    try {
      final dog = _isEdit ? await repo.updateDog(widget.dog!.id, draft) : await repo.createDog(userId, draft);
      await repo.saveHealthProfile(
        DogHealthProfile(
          dogId: dog.id,
          conditionCodes: _noConditions ? const [] : (_conditionCodes.toList()..sort()),
          diseases: _diseases,
          surgeries: _surgeries,
          medications: _medications,
          exerciseRestrictions: _restrictions,
          veterinaryNotes: _vetNotesController.text,
        ),
      );

      String? photoError;
      if (_imageBytes != null) {
        try {
          await repo.uploadProfileImage(dog: dog, bytes: _imageBytes!, extension: _imageExtension);
        } catch (error) {
          photoError = friendlyError(error);
        }
      }

      ref
        ..invalidate(dogsProvider)
        ..invalidate(dogDetailProvider(dog.id))
        ..invalidate(dogHealthProfileProvider(dog.id));
      if (!_isEdit) ref.read(selectedDogIdProvider.notifier).select(dog.id);

      if (!mounted) return;
      context.showMessage(
        photoError != null
            ? '정보는 저장했지만 사진을 올리지 못했어요. $photoError'
            : _isEdit
                ? '반려견 정보를 수정했어요.'
                : '${josa(dog.name, '가', '이')} 등록되었어요.',
      );
      context.pop();
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

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? '반려견 정보 수정' : '반려견 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    if (_imageBytes != null)
                      ClipOval(child: Image.memory(_imageBytes!, width: 104, height: 104, fit: BoxFit.cover))
                    else
                      DogAvatar(dog: widget.dog, size: 104),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.mintDeep,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.surface, width: 3),
                        ),
                        child: const Icon(Icons.photo_camera_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('기본 정보', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              maxLength: 30,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: '이름 *', counterText: ''),
              validator: (value) => (value == null || value.trim().isEmpty) ? '이름을 입력해 주세요.' : null,
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('믹스견이에요'),
              subtitle: const Text('두 견종 이상이 섞였거나 견종을 잘 모르는 경우'),
              value: _isMixed,
              onChanged: (value) => setState(() => _isMixed = value),
            ),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _breed),
              optionsBuilder: (value) {
                final query = value.text.trim();
                if (query.isEmpty) return const Iterable<String>.empty();
                return widget.breeds.map((breed) => breed.name).where((name) => name.contains(query));
              },
              onSelected: (value) => setState(() => _breed = value),
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                maxLength: 50,
                onChanged: (value) => setState(() => _breed = value),
                decoration: InputDecoration(
                  labelText: _isMixed ? '섞인 견종 (선택)' : '견종 *',
                  hintText: _isMixed ? '예: 말티즈, 푸들' : '예: 말티즈',
                  counterText: '',
                  helperText: _breedHelperText,
                ),
                validator: (value) =>
                    !_isMixed && (value == null || value.trim().isEmpty) ? '견종을 입력해 주세요. 잘 모르면 믹스견을 선택해 주세요.' : null,
              ),
            ),
            if (_catalogBreed == null) ...[
              const SizedBox(height: 16),
              const _FieldLabel('체구 *'),
              const SizedBox(height: 8),
              SegmentedButton<DogSize>(
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [for (final size in DogSize.values) ButtonSegment(value: size, label: Text(size.label))],
                selected: {if (_size != null) _size!},
                onSelectionChanged: (value) => setState(() => _size = value.firstOrNull),
              ),
              const SizedBox(height: 6),
              _ChoiceHint(
                errorText: _showErrors && _size == null ? '체구를 선택해 주세요.' : null,
                hint: '다 자란 몸무게 기준 · ${DogSize.values.map((s) => '${s.label} ${s.weightHint}').join(' · ')}',
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('주둥이가 짧은 단두종이에요'),
                subtitle: const Text('퍼그·시츄·불독처럼 코가 눌린 얼굴형'),
                value: _brachycephalic,
                onChanged: (value) => setState(() => _brachycephalic = value),
              ),
            ],
            const SizedBox(height: 16),
            const _FieldLabel('나이 *'),
            const SizedBox(height: 8),
            SegmentedButton<_AgeInput>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: _AgeInput.birthDate, label: Text('생년월일')),
                ButtonSegment(value: _AgeInput.estimate, label: Text('추정 나이')),
              ],
              selected: {_ageInput},
              onSelectionChanged: (value) => setState(() => _ageInput = value.first),
            ),
            const SizedBox(height: 12),
            if (_ageInput == _AgeInput.birthDate)
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '생년월일',
                    suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                    helperText: _birthDate == null ? null : '현재 ${Fmt.dogAge(_birthDate!)}',
                    errorText: _showErrors && _birthDate == null ? '생년월일을 선택해 주세요.' : null,
                  ),
                  child: Text(_birthDate == null ? '선택해 주세요' : Fmt.dateShort(_birthDate!)),
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageYearsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                      decoration: const InputDecoration(labelText: '나이', suffixText: '살'),
                      validator: _validateAgeYears,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ageMonthsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                      decoration: const InputDecoration(labelText: '개월 (선택)', suffixText: '개월'),
                      validator: _validateAgeMonths,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            const _FieldLabel('성별'),
            const SizedBox(height: 8),
            SegmentedButton<DogSex>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: [for (final sex in DogSex.values) ButtonSegment(value: sex, label: Text(sex.label))],
              selected: {if (_sex != null) _sex!},
              onSelectionChanged: (value) => setState(() => _sex = value.firstOrNull),
            ),
            const SizedBox(height: 16),
            const _FieldLabel('중성화 *'),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: true, label: Text('했어요')),
                ButtonSegment(value: false, label: Text('안 했어요')),
              ],
              selected: {if (_neutered != null) _neutered!},
              onSelectionChanged: (value) => setState(() => _neutered = value.firstOrNull),
            ),
            if (_showErrors && _neutered == null) const _ChoiceHint(errorText: '중성화 여부를 선택해 주세요.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?'))],
              decoration: const InputDecoration(labelText: '체중 *', suffixText: 'kg'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return '체중을 입력해 주세요.';
                final weight = double.tryParse(text);
                if (weight == null || weight <= 0 || weight >= 150) return '올바른 체중을 입력해 주세요.';
                return null;
              },
            ),
            const SizedBox(height: 28),
            Text('건강 정보', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '운동 강도와 주의사항을 정하는 데 쓰여요. 정확하게 입력해 주세요.',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _ConditionPicker(
              conditions: widget.conditions,
              selected: _conditionCodes,
              noConditions: _noConditions,
              errorText: _showErrors && !_conditionsAnswered ? "해당하는 항목이나 '해당 없음'을 골라 주세요." : null,
              onToggle: (code, selected) => setState(() {
                if (selected) {
                  _conditionCodes.add(code);
                  _noConditions = false;
                } else {
                  _conditionCodes.remove(code);
                }
              }),
              onNoConditions: (selected) => setState(() {
                _noConditions = selected;
                if (selected) _conditionCodes.clear();
              }),
            ),
            _HealthItemsEditor(
              title: '질환 상세',
              emptyText: '적어 둔 진단명이 없어요.',
              nameLabel: '진단명 (예: 슬개골 탈구)',
              detailLabel: '상태·단계 (선택)',
              items: _diseases,
              onChanged: (items) => setState(() => _diseases = items),
            ),
            _HealthItemsEditor(
              title: '수술 및 치료 이력',
              emptyText: '등록된 이력이 없어요.',
              nameLabel: '수술·치료명',
              detailLabel: '병원·메모 (선택)',
              withDate: true,
              items: _surgeries,
              onChanged: (items) => setState(() => _surgeries = items),
            ),
            _HealthItemsEditor(
              title: '복용 중인 약물',
              emptyText: '복용 중인 약물이 없어요.',
              nameLabel: '약 이름',
              detailLabel: '용량·복용 주기 (선택)',
              items: _medications,
              onChanged: (items) => setState(() => _medications = items),
            ),
            _HealthItemsEditor(
              title: '운동 제한 사항',
              emptyText: '운동 제한 사항이 없어요.',
              nameLabel: '제한 내용 (예: 경사 운동 금지)',
              detailLabel: '상세 설명 (선택)',
              items: _restrictions,
              onChanged: (items) => setState(() => _restrictions = items),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _vetNotesController,
              maxLength: 2000,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: '수의사 권고사항',
                hintText: '예: 주 3회, 20분 이내 저속 보행 권장',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : Text(_isEdit ? '저장하기' : '등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant));
  }
}

/// 선택형 입력 아래의 안내 또는 오류 문구 (오류가 있으면 오류를 보여 준다)
class _ChoiceHint extends StatelessWidget {
  const _ChoiceHint({this.errorText, this.hint});

  final String? errorText;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = errorText ?? hint;
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: errorText != null ? scheme.error : scheme.onSurfaceVariant),
      ),
    );
  }
}

/// 질병·주의사항 다중 선택. 아무것도 없으면 '해당 없음'을 명시적으로 고른다.
class _ConditionPicker extends StatelessWidget {
  const _ConditionPicker({
    required this.conditions,
    required this.selected,
    required this.noConditions,
    required this.onToggle,
    required this.onNoConditions,
    this.errorText,
  });

  final List<HealthCondition> conditions;
  final Set<String> selected;
  final bool noConditions;
  final void Function(String code, bool selected) onToggle;
  final ValueChanged<bool> onNoConditions;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final picked = [
      for (final condition in conditions)
        if (selected.contains(condition.code)) condition
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        borderColor: errorText != null ? scheme.error : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('질병·주의사항 *', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              '진단받았거나 치료 중인 항목을 모두 골라 주세요.',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final condition in conditions)
                  FilterChip(
                    label: Text(condition.name),
                    tooltip: condition.description,
                    selected: selected.contains(condition.code),
                    onSelected: (value) => onToggle(condition.code, value),
                  ),
                FilterChip(
                  label: const Text('해당 없음'),
                  selected: noConditions,
                  onSelected: onNoConditions,
                ),
              ],
            ),
            for (final condition in picked)
              if (condition.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${condition.name}: ${condition.description}',
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                  ),
                ),
            if (errorText != null) _ChoiceHint(errorText: errorText),
          ],
        ),
      ),
    );
  }
}

class _HealthItemsEditor extends StatelessWidget {
  const _HealthItemsEditor({
    required this.title,
    required this.emptyText,
    required this.nameLabel,
    required this.detailLabel,
    required this.items,
    required this.onChanged,
    this.withDate = false,
  });

  final String title;
  final String emptyText;
  final String nameLabel;
  final String detailLabel;
  final List<HealthItem> items;
  final ValueChanged<List<HealthItem>> onChanged;
  final bool withDate;

  Future<void> _add(BuildContext context) async {
    final item = await showDialog<HealthItem>(
      context: context,
      builder: (context) => _HealthItemDialog(
        title: '$title 추가',
        nameLabel: nameLabel,
        detailLabel: detailLabel,
        withDate: withDate,
      ),
    );
    if (item != null) onChanged([...items, item]);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
                TextButton.icon(
                  onPressed: () => _add(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('추가'),
                ),
              ],
            ),
            if (items.isEmpty)
              Text(emptyText, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant))
            else
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var i = 0; i < items.length; i++)
                      InputChip(
                        label: Text(
                          [
                            items[i].name,
                            if (items[i].detail != null && items[i].detail!.isNotEmpty) items[i].detail!,
                            if (items[i].date != null) Fmt.dateShort(items[i].date!),
                          ].join(' · '),
                        ),
                        onDeleted: () => onChanged([...items]..removeAt(i)),
                        deleteButtonTooltipMessage: '삭제',
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HealthItemDialog extends StatefulWidget {
  const _HealthItemDialog({
    required this.title,
    required this.nameLabel,
    required this.detailLabel,
    required this.withDate,
  });

  final String title;
  final String nameLabel;
  final String detailLabel;
  final bool withDate;

  @override
  State<_HealthItemDialog> createState() => _HealthItemDialogState();
}

class _HealthItemDialogState extends State<_HealthItemDialog> {
  final _nameController = TextEditingController();
  final _detailController = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _nameController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              maxLength: 50,
              decoration: InputDecoration(labelText: widget.nameLabel, counterText: ''),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _detailController,
              maxLength: 100,
              decoration: InputDecoration(labelText: widget.detailLabel, counterText: ''),
            ),
            if (widget.withDate) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? now,
                    firstDate: DateTime(now.year - 30),
                    lastDate: now,
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(_date == null ? '날짜 선택 (선택)' : Fmt.dateShort(_date!)),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(80, 44)),
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.of(context).pop(
              HealthItem(name: name, detail: _detailController.text.trim(), date: _date),
            );
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
