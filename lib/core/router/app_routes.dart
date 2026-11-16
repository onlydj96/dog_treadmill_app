/// 라우트 경로
abstract final class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';

  // 하단 탭 (문서 3장: Home / Reservation / Exercise / Health / My Page)
  static const home = '/home';
  static const booking = '/booking';
  static const exercise = '/exercise';
  static const health = '/health';
  static const my = '/my';

  static const notifications = '/notifications';

  static const bookingNew = '/bookings/new';
  static String bookingDetail(String id) => '/bookings/$id';

  static const exerciseHistory = '/exercise-history';

  static String report(String id) => '/reports/$id';
  static String video({required String path, required String title}) =>
      Uri(path: '/video', queryParameters: {'path': path, 'title': title}).toString();

  static const dogs = '/dogs';
  static const dogNew = '/dogs/new';
  static String dogDetail(String id) => '/dogs/$id';
  static String dogEdit(String id) => '/dogs/$id/edit';
  static String dogBadges(String id) => '/dogs/$id/badges';

  // 랭킹 (탭: leaderboard 기본 / battle / hall)
  static const ranking = '/ranking';
  static String rankingTab(String tab) => Uri(path: ranking, queryParameters: {'tab': tab}).toString();

  /// 매장 태블릿·TV용 지점 랭킹 보드
  static String storeBoard(String branchId) => '/board/$branchId';

  static const membership = '/membership';
  static const payments = '/payments';

  static const profileEdit = '/settings/profile';
  static const notificationSettings = '/settings/notifications';
  static const consents = '/settings/consents';

  static const notices = '/notices';
  static const faq = '/faq';
  static const inquiries = '/inquiries';
  static const inquiryNew = '/inquiries/new';
}
