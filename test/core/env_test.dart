import 'dart:convert';

import 'package:dog_treadmill_app/core/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 문자열 파일만 가진 테스트용 에셋 번들
class _StringBundle extends CachingAssetBundle {
  _StringBundle(this.files);

  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final text = files[key];
    if (text == null) throw FlutterError('Unable to load asset: "$key".');
    return ByteData.sublistView(utf8.encode(text));
  }
}

void main() {
  test('config/supabase.env 형식: 주석·빈 줄은 건너뛰고, 따옴표와 앞뒤 공백을 벗긴다', () {
    expect(
      Env.parse('# 주석\r\n\nSUPABASE_URL = https://abc.supabase.co\n'
          'SUPABASE_PUBLISHABLE_KEY="sb_publishable_x=y"\nBROKEN\n=값만\n'),
      {'SUPABASE_URL': 'https://abc.supabase.co', 'SUPABASE_PUBLISHABLE_KEY': 'sb_publishable_x=y'},
    );
  });

  test('flutter run만 해도 config/supabase.env를 읽어 설정된다 (dart-define이 없을 때)', () async {
    await Env.load(bundle: _StringBundle({
      Env.fileAsset: 'SUPABASE_URL=https://abc.supabase.co\nSUPABASE_PUBLISHABLE_KEY=sb_publishable_test\n',
    }));
    expect(Env.supabaseUrl, 'https://abc.supabase.co');
    expect(Env.supabaseKey, 'sb_publishable_test');
    expect(Env.isConfigured, isTrue);
  });

  test('publishable 키가 없으면 예전 anon 키를 쓴다', () async {
    await Env.load(bundle: _StringBundle({
      Env.fileAsset: 'SUPABASE_URL=https://abc.supabase.co\nSUPABASE_ANON_KEY=eyJanon\n',
    }));
    expect(Env.supabaseKey, 'eyJanon');
  });

  test('파일이 없으면 설정되지 않은 것으로 본다 (설정 안내 화면)', () async {
    await Env.load(bundle: _StringBundle(const {}));
    expect(Env.isConfigured, isFalse);
  });
}
