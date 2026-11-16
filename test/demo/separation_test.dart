import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// 실제 앱과 데모 앱의 경계: 실제 앱 코드는 데모 코드(lib/demo, lib/main_demo.dart)를 import하지 않는다.
// 그래서 실제 앱(lib/main.dart) 빌드에는 목업 서버·샘플 데이터가 들어가지 않는다.

void main() {
  test('실제 앱 코드는 데모 코드를 import하지 않는다', () {
    final demoImport = RegExp(r'''import\s+['"][^'"]*(\bdemo/|main_demo\.dart)''');
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path.replaceAll(r'\', '/');
      if (path.startsWith('lib/demo/') || path == 'lib/main_demo.dart') continue;
      if (demoImport.hasMatch(entity.readAsStringSync())) offenders.add(path);
    }
    expect(offenders, isEmpty, reason: '데모 전용 코드는 lib/main_demo.dart에서만 연결한다');
  });
}
