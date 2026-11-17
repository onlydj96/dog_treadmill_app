import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/presentation/dog_registration_screen.dart';
import 'package:dog_treadmill_app/features/dogs/providers.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

void main() {
  setUpAll(initTestLocales);

  group('반려견 모델 (English)', () {
    test('성별·체구 라벨과 체중 안내', () {
      useLanguage(AppLanguage.en);
      expect(DogSex.male.label, 'Male');
      expect(DogSex.female.label, 'Female');
      expect(DogSize.small.label, 'Small');
      expect(DogSize.small.weightHint, 'Under 10kg');
      expect(DogSize.medium.weightHint, '10–25kg');
      expect(DogSize.large.weightHint, '25kg and up');
    });

    test('Breed·HealthCondition은 _en이 있으면 영어, 없으면 한국어', () {
      final breed = Breed.fromJson({
        'id': 'shih_tzu',
        'name': '시츄',
        'name_en': 'Shih Tzu',
        'size_class': 'small',
        'is_brachycephalic': true,
      });
      final noEn = Breed.fromJson({'id': 'x', 'name': '진돗개', 'size_class': 'medium'});
      final condition = HealthCondition.fromJson({
        'code': 'obesity',
        'name': '비만',
        'name_en': 'Obesity',
        'description': '수의사 진단',
        'description_en': 'Diagnosed by a vet',
      });
      expect(breed.name, '시츄');
      expect(condition.name, '비만');

      useLanguage(AppLanguage.en);
      expect(breed.name, 'Shih Tzu');
      expect(breed.nameKo, '시츄');
      expect(noEn.name, '진돗개');
      expect(condition.name, 'Obesity');
      expect(condition.description, 'Diagnosed by a vet');
    });

    test('breedLabel: 카탈로그 · 믹스견 · 직접 입력', () {
      final catalog = Dog.fromJson({
        'id': 'd1',
        'name': '콩이',
        'breed': '시츄',
        'breed_id': 'shih_tzu',
        'breed_catalog': {'name_en': 'Shih Tzu'},
      });
      final mixedTyped = Dog.fromJson({'id': 'd2', 'name': '단풍', 'breed': '말티푸', 'is_mixed': true});
      final mixedBlank = Dog.fromJson({'id': 'd3', 'name': '초코', 'is_mixed': true});
      final noCatalog = Dog.fromJson({'id': 'd4', 'name': '보리', 'breed': '시츄', 'breed_catalog': null});

      expect(catalog.breedLabel, '시츄');
      expect(mixedTyped.breedLabel, '믹스견(말티푸)');
      expect(mixedBlank.breedLabel, '믹스견');

      useLanguage(AppLanguage.en);
      expect(catalog.breedLabel, 'Shih Tzu');
      expect(catalog.breed, '시츄'); // 원본은 그대로
      expect(mixedTyped.breedLabel, 'Mixed (말티푸)');
      expect(mixedBlank.breedLabel, 'Mixed breed');
      expect(noCatalog.breedLabel, '시츄');
    });

    test('ageLabel (추정)', () {
      final now = DateTime.now();
      final birth = DateTime(now.year - 3, now.month, 1);
      final dog = Dog(id: 'd', ownerId: 'o', name: 'x', birthDate: birth, birthDateEstimated: true);
      expect(dog.ageLabel, '약 3살');
      useLanguage(AppLanguage.en);
      expect(dog.ageLabel, startsWith('~'));
    });
  });

  testWidgets('등록 화면은 영어로 보이고 영어 견종명으로 검색된다', (tester) async {
    tester.view.physicalSize = const Size(800, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          languageOverride(AppLanguage.en),
          breedsProvider.overrideWith(
            (ref) async => [
              const Breed(
                id: 'shih_tzu',
                name: '시츄',
                nameEn: 'Shih Tzu',
                size: DogSize.small,
                isBrachycephalic: true,
              ),
            ],
          ),
          healthConditionsProvider.overrideWith(
            (ref) async => [const HealthCondition(code: 'obesity', name: '비만', nameEn: 'Obesity')],
          ),
        ],
        child: localizedApp(const DogRegistrationScreen(), language: AppLanguage.en),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add your dog'), findsOneWidget);
    expect(find.text('Basic info'), findsOneWidget);
    expect(find.text('Breed *'), findsOneWidget);
    expect(find.text('Obesity'), findsOneWidget);
    expect(find.text('Add dog'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Breed *'), 'shih');
    await tester.pumpAndSettle();
    expect(find.text('Shih Tzu'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'shih'), 'Shih Tzu');
    await tester.pumpAndSettle();
    expect(find.text('Small dog · Brachycephalic (flat-faced)'), findsOneWidget);
  });
}
