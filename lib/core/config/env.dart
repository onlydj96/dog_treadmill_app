/// 빌드 시 `--dart-define-from-file=.env`로 주입되는 환경 설정.
///
/// `.env` 예시:
/// ```
/// SUPABASE_URL=https://<project-ref>.supabase.co
/// SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
/// ```
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const _publishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// 새 Publishable key를 우선 사용하고, 없으면 기존 anon key를 사용한다.
  static String get supabaseKey => _publishableKey.isNotEmpty ? _publishableKey : _anonKey;

  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}
