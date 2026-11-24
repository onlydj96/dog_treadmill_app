/// 트레드밀에 붙이는(또는 기기 화면에 띄우는) QR의 내용: `pawfit://treadmill?code=<토큰>`.
///
/// 토큰은 서버(private.treadmill_qr_codes)에만 있고 앱은 읽은 값을 그대로 서버에 넘긴다.
/// 서버의 private.treadmill_qr_payload와 같은 형식이다.
abstract final class TreadmillQr {
  static const scheme = 'pawfit';
  static const host = 'treadmill';

  static String payload(String token) => '$scheme://$host?code=$token';

  /// QR 내용에서 토큰을 꺼낸다. PawFit 트레드밀 QR이 아니면 null.
  static String? tokenOf(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != scheme || uri.host != host) return null;
    final code = uri.queryParameters['code']?.trim();
    return (code == null || code.isEmpty) ? null : code;
  }
}
