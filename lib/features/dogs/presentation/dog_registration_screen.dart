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
import '../../../l10n/l10n.dart';
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
    final title = id == null ? context.l10n.dogRegisterTitle : context.l10n.dogEditTitle;
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
      if (breed.nameKo == name || breed.nameEn == name) return breed;
    }
    return null;
  }

  bool get _conditionsAnswered => _noConditions || _conditionCodes.isNotEmpty;

  String? get _breedHelperText {
    final breed = _catalogBreed;
    if (breed != null) {
      return [
        context.l10n.dogSizeDog(breed.size.label),
        if (breed.isBrachycephalic) context.l10n.dogBrachycephalic,
      ].join(' · ');
    }
    if (!_isMixed && _breed.trim().isNotEmpty) return context.l10n.dogBreedNotListed;
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
    _breed = dog?.breedName ?? '';
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
    if (yearsText.isEmpty && monthsText.isEmpty) return context.l10n.dogAgeRequired;
    final years = int.tryParse(yearsText.isEmpty ? '0' : yearsText);
    if (years == null || years > 30) return context.l10n.dogAgeMax;
    final total = _estimatedMonths;
    if (total != null && total < 1) return context.l10n.dogAgeMin;
    return null;
  }

  String? _validateAgeMonths(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final months = int.tryParse(text);
    if (months == null || months > 11) return context.l10n.dogAgeMonthsRange;
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
              title: Text(context.l10n.dogPickGallery),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.dogPickCamera),
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
      if (mounted) context.showMessage(context.l10n.dogPhotoLoadFailed);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 2, now.month, now.day),
      firstDate: DateTime(now.year - 30),
      lastDate: now,
      helpText: context.l10n.dogBirthDatePickerHelp,
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
      context.showMessage(context.l10n.dogRequiredCheck);
      return;
    }
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _saving = true);
    final repo = ref.read(dogRepositoryProvider);
    final draft = DogDraft(
      name: _nameController.text,
      breed: catalogBreed?.nameKo ?? _breed,
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
            ? context.l10n.dogSavedPhotoFailed(photoError)
            : _isEdit
                ? context.l10n.dogUpdated
                : context.l10n.dogRegistered(particle(dog.name, '가', '이')),
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
      appBar: AppBar(title: Text(_isEdit ? context.l10n.dogEditTitle : context.l10n.dogRegisterTitle)),
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
            Text(context.l10n.dogSectionBasic, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              maxLength: 30,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: context.l10n.dogNameLabel, counterText: ''),
              validator: (value) => (value == null || value.trim().isEmpty) ? context.l10n.dogNameRequired : null,
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.dogMixedSwitch),
              subtitle: Text(context.l10n.dogMixedSwitchHint),
              value: _isMixed,
              onChanged: (value) => setState(() => _isMixed = value),
            ),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _breed),
              optionsBuilder: (value) {
                final query = value.text.trim();
                if (query.isEmpty) return const Iterable<String>.empty();
                if (L10n.isEnglish) {
                  final lower = query.toLowerCase();
                  return widget.breeds
                      .where((breed) => breed.nameKo.contains(query) || (breed.nameEn ?? '').toLowerCase().contains(lower))
                      .map((breed) => breed.name);
                }
                return widget.breeds.map((breed) => breed.name).where((name) => name.contains(query));
              },
              onSelected: (value) => setState(() => _breed = value),
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                maxLength: 50,
                onChanged: (value) => setState(() => _breed = value),
                decoration: InputDecoration(
                  labelText: _isMixed ? context.l10n.dogBreedLabelMixed : context.l10n.dogBreedLabel,
                  hintText: _isMixed ? context.l10n.dogBreedHintMixed : context.l10n.dogBreedHint,
                  counterText: '',
                  helperText: _breedHelperText,
                ),
                validator: (value) =>
                    !_isMixed && (value == null || value.trim().isEmpty) ? context.l10n.dogBreedRequired : null,
              ),
            ),
            if (_catalogBreed == null) ...[
              const SizedBox(height: 16),
              _FieldLabel(context.l10n.dogSizeLabel),
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
                errorText: _showErrors && _size == null ? context.l10n.dogSizeRequired : null,
                hint: context.l10n.dogSizeInfoHint(DogSize.values.map((s) => '${s.label} ${s.weightHint}').join(' · ')),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.dogBrachySwitch),
                subtitle: Text(context.l10n.dogBrachySwitchHint),
                value: _brachycephalic,
                onChanged: (value) => setState(() => _brachycephalic = value),
              ),
            ],
            const SizedBox(height: 16),
            _FieldLabel(context.l10n.dogAgeLabel),
            const SizedBox(height: 8),
            SegmentedButton<_AgeInput>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: _AgeInput.birthDate, label: Text(context.l10n.dogBirthDate)),
                ButtonSegment(value: _AgeInput.estimate, label: Text(context.l10n.dogAgeEstimate)),
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
                    labelText: context.l10n.dogBirthDate,
                    suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                    helperText: _birthDate == null ? null : context.l10n.dogCurrentAge(Fmt.dogAge(_birthDate!)),
                    errorText: _showErrors && _birthDate == null ? context.l10n.dogBirthDateRequired : null,
                  ),
                  child: Text(_birthDate == null ? context.l10n.dogPleaseSelect : Fmt.dateShort(_birthDate!)),
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
                      decoration: InputDecoration(labelText: context.l10n.dogAge, suffixText: context.l10n.dogAgeYearsSuffix),
                      validator: _validateAgeYears,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _ageMonthsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                      decoration: InputDecoration(labelText: context.l10n.dogAgeMonthsLabel, suffixText: context.l10n.dogAgeMonthsSuffix),
                      validator: _validateAgeMonths,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            _FieldLabel(context.l10n.dogSex),
            const SizedBox(height: 8),
            SegmentedButton<DogSex>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: [for (final sex in DogSex.values) ButtonSegment(value: sex, label: Text(sex.label))],
              selected: {if (_sex != null) _sex!},
              onSelectionChanged: (value) => setState(() => _sex = value.firstOrNull),
            ),
            const SizedBox(height: 16),
            _FieldLabel(context.l10n.dogNeuteredLabel),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: true, label: Text(context.l10n.dogNeuteredYes)),
                ButtonSegment(value: false, label: Text(context.l10n.dogNeuteredNo)),
              ],
              selected: {if (_neutered != null) _neutered!},
              onSelectionChanged: (value) => setState(() => _neutered = value.firstOrNull),
            ),
            if (_showErrors && _neutered == null) _ChoiceHint(errorText: context.l10n.dogNeuteredRequired),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?'))],
              decoration: InputDecoration(labelText: context.l10n.dogWeightLabel, suffixText: 'kg'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return context.l10n.dogWeightEnter;
                final weight = double.tryParse(text);
                if (weight == null || weight <= 0 || weight >= 150) return context.l10n.dogWeightInvalid;
                return null;
              },
            ),
            const SizedBox(height: 28),
            Text(context.l10n.dogSectionHealth, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              context.l10n.dogHealthIntro,
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _ConditionPicker(
              conditions: widget.conditions,
              selected: _conditionCodes,
              noConditions: _noConditions,
              errorText: _showErrors && !_conditionsAnswered ? context.l10n.dogConditionsRequired : null,
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
              title: context.l10n.dogDiseasesTitle,
              emptyText: context.l10n.dogDiseasesEmpty,
              nameLabel: context.l10n.dogDiseaseNameLabel,
              detailLabel: context.l10n.dogDiseaseDetailLabel,
              items: _diseases,
              onChanged: (items) => setState(() => _diseases = items),
            ),
            _HealthItemsEditor(
              title: context.l10n.dogSurgeriesTitle,
              emptyText: context.l10n.dogSurgeriesEmpty,
              nameLabel: context.l10n.dogSurgeryNameLabel,
              detailLabel: context.l10n.dogSurgeryDetailLabel,
              withDate: true,
              items: _surgeries,
              onChanged: (items) => setState(() => _surgeries = items),
            ),
            _HealthItemsEditor(
              title: context.l10n.dogMedicationsTitle,
              emptyText: context.l10n.dogMedicationsEmpty,
              nameLabel: context.l10n.dogMedicationNameLabel,
              detailLabel: context.l10n.dogMedicationDetailLabel,
              items: _medications,
              onChanged: (items) => setState(() => _medications = items),
            ),
            _HealthItemsEditor(
              title: context.l10n.dogRestrictionsTitle,
              emptyText: context.l10n.dogRestrictionsEmpty,
              nameLabel: context.l10n.dogRestrictionNameLabel,
              detailLabel: context.l10n.dogRestrictionDetailLabel,
              items: _restrictions,
              onChanged: (items) => setState(() => _restrictions = items),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _vetNotesController,
              maxLength: 2000,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: context.l10n.dogVetNotes,
                hintText: context.l10n.dogVetNotesHint,
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
                  : Text(_isEdit ? context.l10n.dogSubmitSave : context.l10n.dogSubmitRegister),
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
            Text(context.l10n.dogConditionsTitleRequired, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              context.l10n.dogConditionsHelp,
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
                  label: Text(context.l10n.dogConditionNone),
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
        title: context.l10n.dogHealthItemAddTitle(title),
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
                  label: Text(context.l10n.commonAdd),
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
                        deleteButtonTooltipMessage: context.l10n.commonDelete,
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
                label: Text(_date == null ? context.l10n.dogDatePickOptional : Fmt.dateShort(_date!)),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(80, 44)),
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            Navigator.of(context).pop(
              HealthItem(name: name, detail: _detailController.text.trim(), date: _date),
            );
          },
          child: Text(context.l10n.commonAdd),
        ),
      ],
    );
  }
}
