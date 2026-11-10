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

const _breedSuggestions = [
  '말티즈',
  '푸들',
  '토이 푸들',
  '포메라니안',
  '시츄',
  '비숑 프리제',
  '치와와',
  '요크셔테리어',
  '닥스훈트',
  '웰시코기',
  '골든 리트리버',
  '래브라도 리트리버',
  '진돗개',
  '시바견',
  '슈나우저',
  '비글',
  '보더콜리',
  '프렌치 불독',
  '퍼그',
  '사모예드',
  '스피츠',
  '말티푸',
  '믹스견',
];

/// 반려견 등록·수정 (화면 3 DogRegistrationScreen)
class DogRegistrationScreen extends ConsumerWidget {
  const DogRegistrationScreen({super.key, this.dogId});

  /// null이면 신규 등록
  final String? dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = dogId;
    if (id == null) {
      return const _DogForm(dog: null, profile: null);
    }
    final dog = ref.watch(dogDetailProvider(id));
    final profile = ref.watch(dogHealthProfileProvider(id));
    if (dog.hasError || profile.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('반려견 정보 수정')),
        body: ErrorView(
          message: friendlyError(dog.error ?? profile.error!),
          onRetry: () => ref
            ..invalidate(dogDetailProvider(id))
            ..invalidate(dogHealthProfileProvider(id)),
        ),
      );
    }
    if (!dog.hasValue || !profile.hasValue) {
      return Scaffold(appBar: AppBar(title: const Text('반려견 정보 수정')), body: const LoadingView());
    }
    return _DogForm(dog: dog.value, profile: profile.value);
  }
}

class _DogForm extends ConsumerStatefulWidget {
  const _DogForm({required this.dog, required this.profile});

  final Dog? dog;
  final DogHealthProfile? profile;

  @override
  ConsumerState<_DogForm> createState() => _DogFormState();
}

class _DogFormState extends ConsumerState<_DogForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _vetNotesController;
  late String _breed;
  DateTime? _birthDate;
  DogSex? _sex;
  bool _neutered = false;
  late List<HealthItem> _diseases;
  late List<HealthItem> _surgeries;
  late List<HealthItem> _medications;
  late List<HealthItem> _restrictions;
  Uint8List? _imageBytes;
  String _imageExtension = 'jpg';
  bool _saving = false;

  bool get _isEdit => widget.dog != null;

  @override
  void initState() {
    super.initState();
    final dog = widget.dog;
    final profile = widget.profile;
    _nameController = TextEditingController(text: dog?.name ?? '');
    _weightController = TextEditingController(text: dog?.weightKg == null ? '' : _trimNumber(dog!.weightKg!));
    _vetNotesController = TextEditingController(text: profile?.veterinaryNotes ?? '');
    _breed = dog?.breed ?? '';
    _birthDate = dog?.birthDate;
    _sex = dog?.sex;
    _neutered = dog?.neutered ?? false;
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
    super.dispose();
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
    if (!_formKey.currentState!.validate()) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    setState(() => _saving = true);
    final repo = ref.read(dogRepositoryProvider);
    final draft = DogDraft(
      name: _nameController.text,
      breed: _breed,
      birthDate: _birthDate,
      sex: _sex,
      neutered: _neutered,
      weightKg: double.tryParse(_weightController.text.trim()),
    );

    try {
      final dog = _isEdit ? await repo.updateDog(widget.dog!.id, draft) : await repo.createDog(userId, draft);
      await repo.saveHealthProfile(
        DogHealthProfile(
          dogId: dog.id,
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
            const SizedBox(height: 12),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _breed),
              optionsBuilder: (value) {
                final query = value.text.trim();
                if (query.isEmpty) return const Iterable<String>.empty();
                return _breedSuggestions.where((breed) => breed.contains(query));
              },
              onSelected: (value) => _breed = value,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                maxLength: 50,
                onChanged: (value) => _breed = value,
                decoration: const InputDecoration(labelText: '견종', hintText: '예: 말티즈', counterText: ''),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickBirthDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '생년월일',
                  suffixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                  helperText: _birthDate == null ? null : '현재 ${Fmt.dogAge(_birthDate!)}',
                ),
                child: Text(_birthDate == null ? '선택해 주세요' : Fmt.dateShort(_birthDate!)),
              ),
            ),
            const SizedBox(height: 16),
            Text('성별', style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            SegmentedButton<DogSex>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              segments: [for (final sex in DogSex.values) ButtonSegment(value: sex, label: Text(sex.label))],
              selected: {if (_sex != null) _sex!},
              onSelectionChanged: (value) => setState(() => _sex = value.firstOrNull),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('중성화 수술을 했어요'),
              value: _neutered,
              onChanged: (value) => setState(() => _neutered = value),
            ),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?'))],
              decoration: const InputDecoration(labelText: '체중', suffixText: 'kg'),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                final weight = double.tryParse(text);
                if (weight == null || weight <= 0 || weight >= 150) return '올바른 체중을 입력해 주세요.';
                return null;
              },
            ),
            const SizedBox(height: 28),
            Text('건강 정보', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '예약할 때 주의할 점을 알려 드리는 데 쓰여요. 정확하게 입력해 주세요.',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _HealthItemsEditor(
              title: '기저질환',
              emptyText: '등록된 질환이 없어요.',
              nameLabel: '질환명',
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
