import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demo/demo_app.dart';

/// 데모 앱 진입점: 실제 앱과 같은 화면을 목업 서버(lib/demo/mock_server)로 돌린다.
/// Supabase·.env 없이 실행되고 실제 서버 데이터를 건드리지 않는다.
///
/// ```
/// flutter run -t lib/main_demo.dart
/// ```
///
/// 실제 앱(lib/main.dart)은 이 파일과 lib/demo/를 import하지 않으므로, 실제 앱 빌드에는 데모 코드가 들어가지 않는다.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');
  final preferences = await SharedPreferences.getInstance();
  runApp(DemoApp(preferences: preferences));
}
