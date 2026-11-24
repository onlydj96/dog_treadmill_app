import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Supabase 접속 설정 (URL, publishable 키).
///
/// 읽는 순서:
/// 1. 빌드할 때 `--dart-define` / `--dart-define-from-file`로 넣은 값 (배포·CI 빌드용)
/// 2. 앱에 함께 묶이는 `config/supabase.env` (git에 올리지 않는 로컬 파일). 그냥 `flutter run`만 해도 읽힌다.
///
/// `config/supabase.env` 예시 ([config/supabase.env.example]):
/// ```
/// SUPABASE_URL=https://<project-ref>.supabase.co
/// SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
/// ```
/// publishable 키는 원래 앱 안에 들어가는 공개용 키다. 데이터는 RLS가 지킨다.
/// 저장소가 공개라서 파일만 git 밖에 둔다.
abstract final class Env {
  static const fileAsset = 'config/supabase.env';

  static const _definedUrl = String.fromEnvironment('SUPABASE_URL');
  static const _definedPublishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const _definedAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static Map<String, String> _file = const {};

  /// `config/supabase.env`를 읽는다. 파일이 없으면 dart-define 값만 쓴다 (없으면 설정 안내 화면).
  static Future<void> load({AssetBundle? bundle}) async {
    try {
      _file = parse(await (bundle ?? rootBundle).loadString(fileAsset, cache: false));
    } on FlutterError {
      _file = const {}; // 파일이 없음
    }
  }

  /// `KEY=VALUE` 줄을 읽는다. 빈 줄과 `#` 주석은 건너뛰고, 값을 감싼 따옴표는 벗긴다.
  static Map<String, String> parse(String text) {
    final values = <String, String>{};
    for (final raw in text.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final eq = line.indexOf('=');
      if (eq <= 0) continue;
      var value = line.substring(eq + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      values[line.substring(0, eq).trim()] = value;
    }
    return values;
  }

  static String _value(String defined, String key) => defined.isNotEmpty ? defined : (_file[key] ?? '');

  static String get supabaseUrl => _value(_definedUrl, 'SUPABASE_URL');

  /// 새 Publishable key를 우선 사용하고, 없으면 기존 anon key를 사용한다.
  static String get supabaseKey {
    final publishable = _value(_definedPublishableKey, 'SUPABASE_PUBLISHABLE_KEY');
    return publishable.isNotEmpty ? publishable : _value(_definedAnonKey, 'SUPABASE_ANON_KEY');
  }

  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}
