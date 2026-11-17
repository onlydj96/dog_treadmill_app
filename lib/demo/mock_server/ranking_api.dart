import 'dart:math';

import '../../core/utils/json.dart';
import '../../l10n/l10n.dart';
import 'mock_db.dart';

/// 한 범위의 월간 순위 한 줄 (DB: private.ranking_standings)
class Standing {
  Standing(this.dogId);

  final String dogId;
  int points = 0;
  int sessionCount = 0;
  double distanceMeters = 0;

  /// 마지막으로 점수를 받은 시각 (동점이면 먼저 도달한 쪽이 위)
  String? reachedAt;
  int place = 0;
  int participantCount = 0;
}

/// 랭킹·배지 규칙. docs/ranking.md와 20261116000100_ranking_and_badges.sql을 같은 계산으로 옮겼다.
class RankingApi {
  RankingApi(this.db);

  final MockDb db;

  /// private.nickname_change_interval
  static const nicknameChangeInterval = Duration(days: 30);

  static const _forbiddenNicknameWords = [
    'pawfit', '포핏', '파우핏', '관리자', '운영자', '운영팀', '매니저', '공식', 'admin', 'official', //
    '시발', '씨발', '병신', '개새', '좆', '존나', '느금', '니미', '섹스', 'fuck', 'shit', 'sex',
  ];

  DateTime currentMonth() => Kst.monthStart(Kst.date(db.now()));

  // ---------------------------------------------------------------------
  // 표시 문구
  // ---------------------------------------------------------------------

  static String? sizeLabel(String? size) => switch (size) {
        'small' => '소형견',
        'medium' => '중형견',
        'large' => '대형견',
        _ => null,
      };

  /// "시츄", "믹스견(말티푸)", "믹스견" (DB: private.dog_breed_label)
  static String? breedLabel(Json dog) {
    final breed = (dog['breed'] as String?)?.trim();
    final hasName = breed != null && breed.isNotEmpty;
    if (dog['is_mixed'] == true) return hasName ? '믹스견($breed)' : '믹스견';
    return hasName ? breed : null;
  }

  /// 영어 체급 라벨 (DB: get_leaderboard 등의 `_en` 필드 규칙)
  static String? sizeLabelEn(String? size) => switch (size) {
        'small' => 'Small dogs',
        'medium' => 'Medium dogs',
        'large' => 'Large dogs',
        _ => null,
      };

  /// "Shih Tzu", "Mixed (Maltipoo)", "Mixed breed". 카탈로그 견종은 영어 이름, 직접 적은 견종은 입력 그대로.
  String? breedLabelEn(Json dog) {
    final typed = (dog['breed'] as String?)?.trim();
    final hasName = typed != null && typed.isNotEmpty;
    final catalogName = db.byId('breeds', dog['breed_id'] as String?)?['name_en'] as String?;
    final name = catalogName ?? (hasName ? typed : null);
    if (dog['is_mixed'] == true) return name == null ? 'Mixed breed' : 'Mixed ($name)';
    return name;
  }

  /// 받침 유무로 조사를 붙인다. josa('콩이', '를', '을') → '콩이를' (DB: private.josa)
  static String josa(String word, String withoutBatchim, String withBatchim) {
    if (word.isEmpty) return word;
    final code = word.codeUnitAt(word.length - 1);
    final hasBatchim = code >= 0xAC00 && code <= 0xD7A3 && (code - 0xAC00) % 28 != 0;
    return word + (hasBatchim ? withBatchim : withoutBatchim);
  }

  String scopeLabel(String scope, String scopeKey) => switch (scope) {
        'all' => '전체',
        'size' => sizeLabel(scopeKey) ?? scopeKey,
        _ => db.byId('branches', scopeKey)?['name'] as String? ?? '',
      };

  String scopeLabelEn(String scope, String scopeKey) => switch (scope) {
        'all' => 'Overall',
        'size' => sizeLabelEn(scopeKey) ?? scopeKey,
        _ => db.byId('branches', scopeKey)?['name_en'] as String? ?? scopeLabel(scope, scopeKey),
      };

  static int _scopeOrder(String scope) => switch (scope) {
        'all' => 0,
        'branch' => 1,
        _ => 2,
      };

  // ---------------------------------------------------------------------
  // 운동 점수 적립 (private.award_session_points, 운동 종료 트리거)
  // ---------------------------------------------------------------------

  void awardSessionPoints(Json session) {
    final status = session['status'];
    if (status != 'completed' && status != 'stopped') return;
    final sessionId = session.str('id');
    if (db.table('exercise_points').any((p) => p['session_id'] == sessionId && p['kind'] == 'session')) return;

    final dogId = session.str('dog_id');
    final ownerId = db.byId('dogs', dogId)?['owner_id'] as String?;
    if (ownerId == null) return;

    final booking = db.byId('bookings', session['booking_id'] as String?);
    final treadmill = db.byId('treadmills', session['treadmill_id'] as String?);
    final branchId = (booking?['branch_id'] ?? treadmill?['branch_id']) as String?;
    final date = Kst.date(session.dateTimeOrNull('started_at') ?? session.dateTimeOrNull('ended_at') ?? db.now());
    final dateText = toDateString(date);
    final duration = session.intOr('duration_seconds');
    final distance = session.dblOr('distance_meters');

    var attendance = 0;
    var achievement = 0;
    var distancePoints = 0;
    String? note;
    if (duration < 300) {
      note = 'too_short';
    } else if (db.table('exercise_points').any((p) =>
        p['dog_id'] == dogId &&
        p['kind'] == 'session' &&
        p['exercise_date'] == dateText &&
        p['voided_at'] == null &&
        p.intOr('attendance_points') > 0)) {
      // 반려견당 하루 한 번만 점수를 준다
      note = 'daily_limit';
    } else {
      final target = session.intOr('target_duration_seconds');
      attendance = 10;
      achievement = min(10, (10.0 * duration / (target > 0 ? target : 1800)).floor());
      distancePoints = min(20, (distance / 100).floor());
    }

    final weekStart = toDateString(Kst.weekStart(date));
    db.insert('exercise_points', {
      'dog_id': dogId,
      'owner_id': ownerId,
      'session_id': sessionId,
      'kind': 'session',
      'branch_id': branchId,
      'exercise_date': dateText,
      'period_month': toDateString(Kst.monthStart(date)),
      'week_start': weekStart,
      'qualified': duration >= 300,
      'attendance_points': attendance,
      'achievement_points': achievement,
      'distance_points': distancePoints,
      'bonus_points': 0,
      'points': attendance + achievement + distancePoints,
      'distance_meters': distance,
      'duration_seconds': duration,
      'note': note,
      'earned_at': iso(session.dateTimeOrNull('ended_at') ?? db.now()),
      'voided_at': null,
    });

    if (attendance > 0) _refreshWeeklyBonus(dogId, weekStart);
    final endedAt = session.dateTimeOrNull('ended_at');
    evaluateBadges(dogId, sessionId: sessionId, at: endedAt != null && endedAt.isBefore(db.now()) ? endedAt : null);
  }

  /// 한 주(월~일)에 점수 받은 운동이 2회가 되면 보너스 20점 (private.refresh_weekly_bonus)
  void _refreshWeeklyBonus(String dogId, String weekStart) {
    final scored = db
        .where(
          'exercise_points',
          (p) =>
              p['dog_id'] == dogId &&
              p['kind'] == 'session' &&
              p['week_start'] == weekStart &&
              p['voided_at'] == null &&
              p.intOr('attendance_points') > 0,
        )
        .toList()
      ..sort((a, b) => a.str('earned_at').compareTo(b.str('earned_at')));
    final bonus = db.find(
      'exercise_points',
      (p) =>
          p['dog_id'] == dogId && p['kind'] == 'weekly_bonus' && p['week_start'] == weekStart && p['voided_at'] == null,
    );

    if (scored.length >= 2 && bonus == null) {
      final second = scored[1];
      db.insert('exercise_points', {
        'dog_id': dogId,
        'owner_id': second['owner_id'],
        'session_id': second['session_id'],
        'kind': 'weekly_bonus',
        'branch_id': second['branch_id'],
        'exercise_date': second['exercise_date'],
        'period_month': second['period_month'],
        'week_start': weekStart,
        'qualified': false,
        'attendance_points': 0,
        'achievement_points': 0,
        'distance_points': 0,
        'bonus_points': 20,
        'points': 20,
        'distance_meters': 0,
        'duration_seconds': 0,
        'note': null,
        'earned_at': second['earned_at'],
        'voided_at': null,
      });
    } else if (scored.length < 2 && bonus != null) {
      db.update('exercise_points', bonus, {'voided_at': iso(db.now())});
    }
  }

  // ---------------------------------------------------------------------
  // 배지 (private.dog_badge_stats, private.evaluate_dog_badges)
  // ---------------------------------------------------------------------

  /// 누적 지표: 무효 처리되지 않은 5분 이상 운동 기준
  Json badgeStats(String dogId) {
    final rows = db
        .where(
          'exercise_points',
          (p) => p['dog_id'] == dogId && p['kind'] == 'session' && p['qualified'] == true && p['voided_at'] == null,
        )
        .toList();

    var distance = 0.0;
    var openRuns = 0;
    final branches = <String>{};
    final weeks = <DateTime>{};
    for (final p in rows) {
      distance += p.dblOr('distance_meters');
      weeks.add(Kst.weekStart(Kst.parseDate(p.str('exercise_date'))));
      final branchId = p['branch_id'] as String?;
      if (branchId != null) branches.add(branchId);

      final branch = db.byId('branches', branchId);
      final startedAt = db.byId('exercise_sessions', p['session_id'] as String?)?.dateTimeOrNull('started_at');
      if (branch != null && startedAt != null && branch['is_24_hours'] != true) {
        final second = Kst.secondOfDay(startedAt);
        final opens = Kst.minutesOf(branch.str('opens_at')) * 60;
        if (second >= opens && second < opens + 30 * 60) openRuns++;
      }
    }

    // 연속 운동 주: 이어진 주 묶음의 (길이, 마지막 주)
    final streaks = <(int, DateTime)>[];
    for (final week in weeks.toList()..sort()) {
      if (streaks.isNotEmpty && week.difference(streaks.last.$2).inDays == 7) {
        streaks.last = (streaks.last.$1 + 1, week);
      } else {
        streaks.add((1, week));
      }
    }
    final lastWeek = Kst.weekStart(Kst.date(db.now())).subtract(const Duration(days: 7));
    final current = streaks.where((s) => !s.$2.isBefore(lastWeek)).lastOrNull;

    return {
      'sessions': rows.length,
      'distance_meters': distance,
      'branches': branches.length,
      'open_runs': openRuns,
      'streak_weeks': current?.$1 ?? 0,
      'best_streak_weeks': streaks.fold<int>(0, (best, s) => max(best, s.$1)),
    };
  }

  bool _hasBadge(String dogId, String code) =>
      db.table('dog_badges').any((b) => b['dog_id'] == dogId && b['badge_code'] == code);

  /// 새로 달성한 배지를 주고 알린다. 연속 출석은 최장 기록 기준.
  void evaluateBadges(String dogId, {String? sessionId, DateTime? at}) {
    final dog = db.byId('dogs', dogId);
    if (dog == null) return;
    final stats = badgeStats(dogId);
    final badges = db.where('badges', (b) => b['is_active'] == true && b['metric'] != null).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));

    for (final badge in badges) {
      final metric = badge.str('metric');
      final value = (stats[metric == 'streak_weeks' ? 'best_streak_weeks' : metric] as num?) ?? 0;
      final code = badge.str('code');
      if (value < badge.dblOr('goal') || _hasBadge(dogId, code)) continue;
      db.insert('dog_badges', {
        'dog_id': dogId,
        'badge_code': code,
        'earned_at': iso(at ?? db.now()),
        'session_id': sessionId,
      });
      db.notify(
        dog['owner_id'] as String?,
        'ranking',
        '새 배지를 받았어요',
        '${dog['name']}의 「${badge['name']}」 배지가 도착했어요. 배지함에서 확인해 보세요.',
        data: {'dog_id': dogId, 'badge_code': code},
        msg: 'badge_earned',
        args: {
          ...MockDb.dogNameArgs(dog),
          'badge_code': code,
          'badge_name': badge['name'],
          'badge_name_en': badge['name_en'],
        },
      );
    }
  }

  // ---------------------------------------------------------------------
  // 월간 순위
  // ---------------------------------------------------------------------

  /// 참여 대상: 최신 랭킹 동의가 granted이고 삭제되지 않은 반려견 중 그 달 점수가 0보다 큰 반려견.
  /// [extraDogId]는 동의하지 않았어도 함께 넣는다 ("참여하면 n위").
  List<Standing> standings(DateTime month, String scope, String scopeKey, {String? extraDogId}) {
    final monthText = toDateString(month);
    final totals = <String, Standing>{};
    for (final p in db.where(
      'exercise_points',
      (p) =>
          p['period_month'] == monthText &&
          p['voided_at'] == null &&
          (scope != 'branch' || p['branch_id'] == scopeKey.toLowerCase()),
    )) {
      final standing = totals.putIfAbsent(p.str('dog_id'), () => Standing(p.str('dog_id')));
      final points = p.intOr('points');
      standing.points += points;
      if (p['kind'] == 'session') {
        if (p['qualified'] == true) standing.sessionCount++;
        standing.distanceMeters += p.dblOr('distance_meters');
      }
      final earned = p.str('earned_at');
      if (points > 0 && (standing.reachedAt == null || earned.compareTo(standing.reachedAt!) > 0)) {
        standing.reachedAt = earned;
      }
    }

    final eligible = totals.values.where((s) {
      if (s.points <= 0) return false;
      final dog = db.byId('dogs', s.dogId);
      if (dog == null || dog['deleted_at'] != null) return false;
      if (scope == 'size' && dog['size_class'] != scopeKey) return false;
      return s.dogId == extraDogId || db.hasConsent(dog['owner_id'] as String?, 'ranking');
    }).toList()
      ..sort(_compareStanding);

    for (var i = 0; i < eligible.length; i++) {
      final current = eligible[i];
      final previous = i == 0 ? null : eligible[i - 1];
      final tied = previous != null && previous.points == current.points && previous.reachedAt == current.reachedAt;
      current
        ..place = tied ? previous.place : i + 1
        ..participantCount = eligible.length;
    }
    return eligible;
  }

  static int _compareStanding(Standing a, Standing b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byTime = (a.reachedAt ?? '').compareTo(b.reachedAt ?? '');
    if (byTime != 0) return byTime;
    return a.dogId.compareTo(b.dogId);
  }

  void _assertScope(String scope, String scopeKey) {
    final valid = switch (scope) {
      'all' => scopeKey == 'all',
      'size' => const {'small', 'medium', 'large'}.contains(scopeKey),
      'branch' => db.byId('branches', scopeKey) != null,
      _ => false,
    };
    if (!valid) rpcError('INVALID_RANKING_SCOPE', '22023');
  }

  /// public.get_leaderboard
  List<Json> leaderboard({required DateTime month, required String scope, required String scopeKey, int limit = 50}) {
    final uid = db.requireUser();
    _assertScope(scope, scopeKey);
    final monthText = toDateString(month);
    final previousText = toDateString(DateTime.utc(month.year, month.month - 1));

    return [
      for (final s in standings(month, scope, scopeKey).take(limit.clamp(1, 100)))
        _leaderboardRow(s, uid: uid, monthText: monthText, previousText: previousText),
    ];
  }

  Json _leaderboardRow(Standing s, {required String uid, required String monthText, required String previousText}) {
    final dog = db.byId('dogs', s.dogId)!;
    final owner = db.byId('users', dog['owner_id'] as String?);
    final cheers = db.where('ranking_cheers', (c) => c['dog_id'] == s.dogId && c['period_month'] == monthText).toList();
    final title =
        (db.where('monthly_awards', (a) => a['dog_id'] == s.dogId && a['period_month'] == previousText).toList()
              ..sort(_compareAward))
            .firstOrNull;
    final mainBranch = _mainBranch(s.dogId, monthText);
    return {
      'rank': s.place,
      'dog_id': s.dogId,
      'dog_name': dog['name'],
      'dog_name__en': dog['name__en'],
      'breed_label': breedLabel(dog),
      'breed_label_en': breedLabelEn(dog),
      'size_class': dog['size_class'],
      'photo_path': owner?['ranking_show_photo'] == true ? dog['profile_image_path'] : null,
      'nickname': owner?['nickname'],
      'nickname__en': owner?['nickname__en'],
      'main_branch_name': mainBranch?['name'],
      'main_branch_name_en': mainBranch?['name_en'],
      'points': s.points,
      'session_count': s.sessionCount,
      'distance_meters': s.distanceMeters,
      'cheer_count': cheers.length,
      'cheered_by_me': cheers.any((c) => c['user_id'] == uid),
      'is_mine': dog['owner_id'] == uid,
      'title_period': title?['period_month'],
      'title_scope': title?['scope'],
      'title_label': title == null ? null : scopeLabel(title.str('scope'), title.str('scope_key')),
      'title_label_en': title == null ? null : scopeLabelEn(title.str('scope'), title.str('scope_key')),
      'title_rank': title?['rank'],
      'participant_count': s.participantCount,
    };
  }

  /// 순위 → 전체·지점·체급 순
  static int _compareAward(Json a, Json b) {
    final byRank = a.intOr('rank').compareTo(b.intOr('rank'));
    if (byRank != 0) return byRank;
    return _scopeOrder(a.str('scope')).compareTo(_scopeOrder(b.str('scope')));
  }

  /// 이번 달 점수를 가장 많이 받은 지점 (이름이 같으면 이름순)
  Json? _mainBranch(String dogId, String monthText) {
    final byBranch = <Json, int>{};
    for (final p in db.where(
      'exercise_points',
      (p) => p['dog_id'] == dogId && p['period_month'] == monthText && p['voided_at'] == null,
    )) {
      final branch = db.byId('branches', p['branch_id'] as String?);
      if (branch != null) byBranch[branch] = (byBranch[branch] ?? 0) + p.intOr('points');
    }
    final entries = byBranch.entries.toList()
      ..sort((a, b) {
        final byPoints = b.value.compareTo(a.value);
        return byPoints != 0 ? byPoints : a.key.str('name').compareTo(b.key.str('name'));
      });
    return entries.firstOrNull?.key;
  }

  /// public.get_my_ranking: 참여하지 않았어도 "참여하면 n위"를 계산한다.
  Json myRanking(String dogId, DateTime month) {
    final uid = db.requireUser();
    final dog = db.find('dogs', (d) => d['id'] == dogId && d['owner_id'] == uid && d['deleted_at'] == null) ??
        rpcError('DOG_NOT_FOUND', 'P0002');
    final monthText = toDateString(month);
    final rows = db
        .where(
            'exercise_points', (p) => p['dog_id'] == dogId && p['period_month'] == monthText && p['voided_at'] == null)
        .toList();

    // (범위, 키, 정렬 순서, 지점 점수): 전체 → 운동한 지점(점수 많은 순) → 체급
    final scopes = <(String, String, int, int)>[('all', 'all', 0, 0)];
    final size = dog['size_class'] as String?;
    if (size != null) scopes.add(('size', size, 2, 0));
    final branchPoints = <String, int>{};
    for (final p in rows) {
      final branchId = p['branch_id'] as String?;
      if (branchId != null) branchPoints[branchId] = (branchPoints[branchId] ?? 0) + p.intOr('points');
    }
    scopes
      ..addAll([for (final e in branchPoints.entries) ('branch', e.key, 1, e.value)])
      ..sort((a, b) {
        if (a.$3 != b.$3) return a.$3.compareTo(b.$3);
        if (a.$4 != b.$4) return b.$4.compareTo(a.$4);
        return a.$2.compareTo(b.$2);
      });

    final ranks = <Json>[];
    for (final (scope, key, _, _) in scopes) {
      final list = standings(month, scope, key, extraDogId: dogId);
      final index = list.indexWhere((s) => s.dogId == dogId);
      if (index < 0) continue;
      final me = list[index];
      final above = index == 0 ? null : list[index - 1];
      ranks.add({
        'scope': scope,
        'scope_key': key,
        'label': scopeLabel(scope, key),
        'label_en': scopeLabelEn(scope, key),
        'rank': me.place,
        'participant_count': me.participantCount,
        'points': me.points,
        'points_to_next': above == null ? null : above.points - me.points + 1,
        'top_percent': (me.place * 100 / me.participantCount).ceil(),
      });
    }

    final sessions = rows.where((p) => p['kind'] == 'session');
    return {
      'dog_id': dogId,
      'period_month': monthText,
      'participating': db.hasConsent(uid, 'ranking'),
      'nickname': db.byId('users', uid)?['nickname'],
      'nickname__en': db.byId('users', uid)?['nickname__en'],
      'streak_weeks': badgeStats(dogId)['streak_weeks'],
      'ranks': ranks,
      'points': rows.fold<int>(0, (sum, p) => sum + p.intOr('points')),
      'session_count': sessions.where((p) => p['qualified'] == true).length,
      'distance_meters': sessions.fold<double>(0, (sum, p) => sum + p.dblOr('distance_meters')),
      'weekly_bonus_count': rows.where((p) => p['kind'] == 'weekly_bonus').length,
    };
  }

  /// public.get_branch_battle: 지점별 모든 회원의 운동 거리 합계
  List<Json> branchBattle(DateTime month) {
    db.requireUser();
    final monthText = toDateString(month);
    final rows = [
      for (final branch in db.where('branches', (b) => b['is_active'] == true))
        () {
          final points = db
              .where(
                'exercise_points',
                (p) => p['branch_id'] == branch['id'] && p['period_month'] == monthText && p['voided_at'] == null,
              )
              .toList();
          final sessions = points.where((p) => p['kind'] == 'session');
          final qualified = sessions.where((p) => p['qualified'] == true);
          return <String, dynamic>{
            'branch_id': branch['id'],
            'branch_name': branch['name'],
            'branch_name_en': branch['name_en'],
            'distance_meters': sessions.fold<double>(0, (sum, p) => sum + p.dblOr('distance_meters')),
            'session_count': qualified.length,
            'dog_count': qualified.map((p) => p['dog_id']).toSet().length,
            'points': points.fold<int>(0, (sum, p) => sum + p.intOr('points')),
          };
        }(),
    ]..sort((a, b) {
        final byDistance = b.dblOr('distance_meters').compareTo(a.dblOr('distance_meters'));
        return byDistance != 0 ? byDistance : a.str('branch_name').compareTo(b.str('branch_name'));
      });

    for (var i = 0; i < rows.length; i++) {
      final tied = i > 0 && rows[i - 1].dblOr('distance_meters') == rows[i].dblOr('distance_meters');
      rows[i]['rank'] = tied ? rows[i - 1]['rank'] : i + 1;
    }
    return rows;
  }

  List<Json> _badgeRows(String dogId, {bool activeOnly = false}) {
    final rows = db.where('dog_badges', (b) {
      if (b['dog_id'] != dogId) return false;
      return !activeOnly || db.find('badges', (d) => d['code'] == b['badge_code'])?['is_active'] == true;
    }).toList()
      ..sort((a, b) {
        final byTime = b.str('earned_at').compareTo(a.str('earned_at'));
        return byTime != 0 ? byTime : a.str('badge_code').compareTo(b.str('badge_code'));
      });
    return [
      for (final b in rows)
        {
          'code': b['badge_code'],
          'earned_at': b['earned_at'],
          'name_en': db.find('badges', (d) => d['code'] == b['badge_code'])?['name_en'],
          'description_en': db.find('badges', (d) => d['code'] == b['badge_code'])?['description_en'],
        },
    ];
  }

  List<Json> _awardRows(String dogId) {
    final rows = db.where('monthly_awards', (a) => a['dog_id'] == dogId).toList()
      ..sort((a, b) {
        final byMonth = b.str('period_month').compareTo(a.str('period_month'));
        if (byMonth != 0) return byMonth;
        final byRank = a.intOr('rank').compareTo(b.intOr('rank'));
        return byRank != 0 ? byRank : a.str('scope').compareTo(b.str('scope'));
      });
    return [
      for (final a in rows)
        {
          'period_month': a['period_month'],
          'scope': a['scope'],
          'scope_key': a['scope_key'],
          'scope_label': scopeLabel(a.str('scope'), a.str('scope_key')),
          'scope_label_en': scopeLabelEn(a.str('scope'), a.str('scope_key')),
          'rank': a['rank'],
          'points': a['points'],
        },
    ];
  }

  /// public.get_ranking_dog_profile: 참여 중인 반려견 또는 내 반려견만
  Json dogProfile(String dogId, DateTime month) {
    final uid = db.requireUser();
    final dog =
        db.find('dogs', (d) => d['id'] == dogId && d['deleted_at'] == null) ?? rpcError('DOG_NOT_FOUND', 'P0002');
    final ownerId = dog['owner_id'] as String?;
    final owner = db.byId('users', ownerId);
    final isMine = ownerId == uid;
    final participating = db.hasConsent(ownerId, 'ranking');
    if (!isMine && !participating) rpcError('DOG_NOT_FOUND', 'P0002');

    final monthText = toDateString(month);
    final standing =
        standings(month, 'all', 'all', extraDogId: isMine ? dogId : null).where((s) => s.dogId == dogId).firstOrNull;
    final cheers = db.where('ranking_cheers', (c) => c['dog_id'] == dogId && c['period_month'] == monthText).toList();
    return {
      'dog_id': dogId,
      'dog_name': dog['name'],
      'dog_name__en': dog['name__en'],
      'breed_label': breedLabel(dog),
      'breed_label_en': breedLabelEn(dog),
      'size_class': dog['size_class'],
      'photo_path': isMine || owner?['ranking_show_photo'] == true ? dog['profile_image_path'] : null,
      'nickname': owner?['nickname'],
      'nickname__en': owner?['nickname__en'],
      'is_mine': isMine,
      'participating': participating,
      'period_month': monthText,
      'rank': standing?.place,
      'participant_count': standing?.participantCount,
      'points': standing?.points ?? 0,
      'session_count': standing?.sessionCount ?? 0,
      'distance_meters': standing?.distanceMeters ?? 0,
      'cheer_count': cheers.length,
      'cheered_by_me': cheers.any((c) => c['user_id'] == uid),
      'badges': _badgeRows(dogId, activeOnly: true),
      'awards': _awardRows(dogId),
    };
  }

  /// public.get_dog_achievements: 내 반려견의 배지·진행률·수상 기록
  Json achievements(String dogId) {
    final uid = db.requireUser();
    db.find('dogs', (d) => d['id'] == dogId && d['owner_id'] == uid && d['deleted_at'] == null) ??
        rpcError('DOG_NOT_FOUND', 'P0002');
    return {'stats': badgeStats(dogId), 'badges': _badgeRows(dogId), 'awards': _awardRows(dogId)};
  }

  /// public.cheer_dog: 같은 반려견은 한 달에 한 번. [asUserId]는 데모 컨트롤의 "다른 보호자가 응원" 용도.
  int cheer(String dogId, {String? asUserId}) {
    final uid = asUserId ?? db.requireUser();
    final monthText = toDateString(currentMonth());
    final dog = db.find('dogs', (d) => d['id'] == dogId && d['deleted_at'] == null);
    if (dog == null || !db.hasConsent(dog['owner_id'] as String?, 'ranking')) rpcError('DOG_NOT_FOUND', 'P0002');
    if (dog['owner_id'] == uid) rpcError('CANNOT_CHEER_OWN_DOG', '22023');

    bool sameCheer(Json c) => c['period_month'] == monthText && c['dog_id'] == dogId;
    if (!db.table('ranking_cheers').any((c) => sameCheer(c) && c['user_id'] == uid)) {
      db.insert('ranking_cheers', {'period_month': monthText, 'dog_id': dogId, 'user_id': uid});
      final cheerer = db.hasConsent(uid, 'ranking') ? db.byId('users', uid) : null;
      final nickname = cheerer?['nickname'] as String?;
      db.notify(
        dog['owner_id'] as String?,
        'ranking',
        '응원이 도착했어요',
        '${nickname == null ? '다른 보호자가' : '$nickname님이'} ${josa(dog.str('name'), '를', '을')} 응원했어요.',
        data: {'dog_id': dogId},
        msg: 'cheer_received',
        args: {...MockDb.dogNameArgs(dog), 'nickname': nickname, 'nickname__en': cheerer?['nickname__en']},
      );
    }
    return db.where('ranking_cheers', sameCheer).length;
  }

  // ---------------------------------------------------------------------
  // 닉네임
  // ---------------------------------------------------------------------

  /// private.generate_nickname: "씩씩한발바닥0427". 영어 화면에서 가입하면 "BraveWag042" (가입 트리거의 locale 분기).
  String generateNickname() {
    if (L10n.isEnglish) return _generateNicknameEn();
    const adjectives = ['씩씩한', '날쌘', '다정한', '용감한', '부지런한', '신나는', '튼튼한', '반짝이는', '느긋한', '명랑한'];
    const nouns = ['발바닥', '꼬리', '산책러', '러너', '댕댕이', '멍멍이', '발도장', '콧등'];
    for (var i = 0; i < 50; i++) {
      final candidate = adjectives[db.random.nextInt(adjectives.length)] +
          nouns[db.random.nextInt(nouns.length)] +
          db.random.nextInt(10000).toString().padLeft(4, '0');
      if (!_nicknameTaken(candidate)) return candidate;
    }
    return '보호자${db.newId().replaceAll('-', '').substring(0, 8)}';
  }

  /// 형용사 + 명사 + 숫자 3자리 (12자 이하, [A-Za-z0-9_]). 실패하면 'Owner' + 16진수 7자.
  String _generateNicknameEn() {
    const adjectives = ['Brave', 'Swift', 'Sunny', 'Happy', 'Jolly', 'Lucky', 'Zippy', 'Perky', 'Chill', 'Merry'];
    const nouns = ['Paw', 'Tail', 'Pup', 'Dog', 'Nose', 'Run', 'Step', 'Wag'];
    for (var i = 0; i < 50; i++) {
      final candidate = adjectives[db.random.nextInt(adjectives.length)] +
          nouns[db.random.nextInt(nouns.length)] +
          db.random.nextInt(1000).toString().padLeft(3, '0');
      if (candidate.length <= 12 && !_nicknameTaken(candidate)) return candidate;
    }
    return 'Owner${db.newId().replaceAll('-', '').substring(0, 7)}';
  }

  bool _nicknameTaken(String nickname, {String? exceptUserId}) => db
      .table('users')
      .any((u) => u['id'] != exceptUserId && (u['nickname'] as String?)?.toLowerCase() == nickname.toLowerCase());

  /// public.set_nickname: 형식·금칙어·중복·30일 주기를 검증한다.
  String setNickname(String nickname) {
    final uid = db.requireUser();
    final value = nickname.trim();
    if (value.length < 2 || value.length > 12 || !RegExp(r'^[가-힣A-Za-z0-9_]+$').hasMatch(value)) {
      rpcError('NICKNAME_INVALID', '22023');
    }
    if (_forbiddenNicknameWords.any(value.toLowerCase().contains)) rpcError('NICKNAME_FORBIDDEN', '22023');

    final user = db.byId('users', uid) ?? rpcError('AUTH_REQUIRED', '42501');
    if (user['nickname'] == value) return value;
    final updatedAt = user.dateTimeOrNull('nickname_updated_at');
    if (updatedAt != null && updatedAt.isAfter(db.now().subtract(nicknameChangeInterval))) {
      rpcError('NICKNAME_COOLDOWN', '22023');
    }
    if (_nicknameTaken(value, exceptUserId: uid)) rpcError('NICKNAME_TAKEN', '23505');

    db.update('users', user, {'nickname': value, 'nickname__en': null, 'nickname_updated_at': iso(db.now())});
    return value;
  }

  // ---------------------------------------------------------------------
  // 월간 마감 · 명예의 전당
  // ---------------------------------------------------------------------

  /// private.close_ranking_month: 전체·체급·지점별 1~3위 기록, 시상대 배지, 수상 알림
  int closeMonth(DateTime month, {DateTime? closedAt}) {
    final monthText = toDateString(month);
    if (!month.isBefore(currentMonth())) rpcError('RANKING_MONTH_NOT_FINISHED', '22023');
    if (db.table('ranking_closings').any((c) => c['period_month'] == monthText)) return 0;

    final at = iso(closedAt ?? db.now());
    final closing = db.insert('ranking_closings', {'period_month': monthText, 'closed_at': at, 'award_count': 0});
    final scopes = <(String, String)>[
      ('all', 'all'),
      ('size', 'small'),
      ('size', 'medium'),
      ('size', 'large'),
      for (final branch in db.table('branches'))
        if (db.table('exercise_points').any((p) => p['branch_id'] == branch['id'] && p['period_month'] == monthText))
          ('branch', branch.str('id')),
    ];

    final awardsByDog = <String, List<Json>>{};
    for (final (scope, key) in scopes) {
      for (final s in standings(month, scope, key).where((s) => s.place <= 3)) {
        final award = db.insert('monthly_awards', {
          'period_month': monthText,
          'scope': scope,
          'scope_key': key,
          'rank': s.place,
          'dog_id': s.dogId,
          'owner_id': db.byId('dogs', s.dogId)!['owner_id'],
          'points': s.points,
          'created_at': at,
        });
        awardsByDog.putIfAbsent(s.dogId, () => []).add(award);
      }
    }
    db.update('ranking_closings', closing, {
      'award_count': awardsByDog.values.fold<int>(0, (sum, list) => sum + list.length),
    });

    for (final MapEntry(key: dogId, value: awards) in awardsByDog.entries) {
      final dog = db.byId('dogs', dogId)!;
      if (!_hasBadge(dogId, 'podium')) {
        db.insert('dog_badges', {'dog_id': dogId, 'badge_code': 'podium', 'earned_at': at, 'session_id': null});
      }
      awards.sort((a, b) {
        final byScope = _scopeOrder(a.str('scope')).compareTo(_scopeOrder(b.str('scope')));
        return byScope != 0 ? byScope : a.intOr('rank').compareTo(b.intOr('rank'));
      });
      final summary = awards.map((a) => '${scopeLabel(a.str('scope'), a.str('scope_key'))} ${a['rank']}위').join(' · ');
      db.notify(
        dog['owner_id'] as String?,
        'ranking',
        '${month.month}월 랭킹 시상대에 올랐어요',
        '${josa(dog.str('name'), '가', '이')} ${month.month}월 랭킹 $summary에 올랐어요. 명예의 전당에서 확인해 보세요.',
        data: {'period_month': monthText, 'dog_id': dogId},
        msg: 'monthly_award',
        args: {
          ...MockDb.dogNameArgs(dog),
          'month': month.month,
          'awards': [
            for (final a in awards)
              {
                'scope': a['scope'],
                'label': scopeLabel(a.str('scope'), a.str('scope_key')),
                'label_en': scopeLabelEn(a.str('scope'), a.str('scope_key')),
                'rank': a['rank'],
              },
          ],
        },
      );
    }
    return awardsByDog.values.fold<int>(0, (sum, list) => sum + list.length);
  }

  /// 마감하지 않은 지난 달을 모두 마감한다 (DB: pg_cron이 매일 00:10에 실행하는 private.close_due_ranking_months)
  void closeDueMonths() {
    final current = currentMonth();
    final months = db
        .table('exercise_points')
        .map((p) => p.str('period_month'))
        .toSet()
        .map(Kst.parseDate)
        .where((m) => m.isBefore(current))
        .toList()
      ..sort();
    for (final month in months) {
      // 다음 달 1일 00:10 (한국 시간)
      closeMonth(month, closedAt: Kst.at(DateTime.utc(month.year, month.month + 1), 10));
    }
  }

  /// public.get_hall_of_fame: 마감한 최근 달의 1~3위. 참여를 철회했거나 삭제된 반려견은 가린다.
  List<Json> hallOfFame({int months = 6}) {
    final uid = db.requireUser();
    final closed = db.table('ranking_closings').map((c) => c.str('period_month')).toList()
      ..sort((a, b) => b.compareTo(a));
    final picked = closed.take(months.clamp(1, 24)).toSet();

    final rows = <Json>[];
    for (final award in db.where('monthly_awards', (a) => picked.contains(a['period_month']))) {
      final dog = db.byId('dogs', award.str('dog_id'));
      final owner = db.byId('users', award.str('owner_id'));
      if (dog == null || owner == null) continue;
      final isMine = award['owner_id'] == uid;
      final visible = dog['deleted_at'] == null && (isMine || db.hasConsent(award.str('owner_id'), 'ranking'));
      rows.add({
        'period_month': award['period_month'],
        'scope': award['scope'],
        'scope_key': award['scope_key'],
        'scope_label': scopeLabel(award.str('scope'), award.str('scope_key')),
        'scope_label_en': scopeLabelEn(award.str('scope'), award.str('scope_key')),
        'rank': award['rank'],
        'dog_id': visible ? dog['id'] : null,
        'dog_name': visible ? dog['name'] : null,
        'dog_name__en': visible ? dog['name__en'] : null,
        'breed_label': visible ? breedLabel(dog) : null,
        'breed_label_en': visible ? breedLabelEn(dog) : null,
        'photo_path': visible && (owner['ranking_show_photo'] == true || isMine) ? dog['profile_image_path'] : null,
        'nickname': visible ? owner['nickname'] : null,
        'nickname__en': visible ? owner['nickname__en'] : null,
        'points': award['points'],
        'is_mine': isMine,
        'is_hidden': !visible,
      });
    }
    rows.sort((a, b) {
      final byMonth = b.str('period_month').compareTo(a.str('period_month'));
      if (byMonth != 0) return byMonth;
      final byScope = _scopeOrder(a.str('scope')).compareTo(_scopeOrder(b.str('scope')));
      if (byScope != 0) return byScope;
      final byLabel = a.str('scope_label').compareTo(b.str('scope_label'));
      if (byLabel != 0) return byLabel;
      final byRank = a.intOr('rank').compareTo(b.intOr('rank'));
      return byRank != 0 ? byRank : b.intOr('points').compareTo(a.intOr('points'));
    });
    return rows;
  }
}
