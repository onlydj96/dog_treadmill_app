import 'package:flutter/foundation.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';
import '../../dogs/data/dog.dart';

/// 랭킹 기간(월). 한국 시간 기준이며 1일 0시의 로컬 [DateTime]으로 다룬다.
abstract final class RankingMonth {
  /// 지금 한국 시간 기준 이번 달
  static DateTime current({DateTime? now}) {
    final kst = (now ?? DateTime.now()).toUtc().add(const Duration(hours: 9));
    return DateTime(kst.year, kst.month);
  }

  static DateTime of(DateTime date) => DateTime(date.year, date.month);

  static DateTime previous(DateTime month) => DateTime(month.year, month.month - 1);

  static DateTime next(DateTime month) => DateTime(month.year, month.month + 1);

  static bool isCurrent(DateTime month, {DateTime? now}) => of(month) == current(now: now);
}

/// "용산 아이파크몰점" → "용산점", "Yongsan I'Park Mall" → "Yongsan". 칩·칭호처럼 좁은 곳에 쓴다.
String shortBranchName(String name) {
  final trimmed = name.trim();
  final space = trimmed.indexOf(' ');
  if (space <= 0) return trimmed;
  final first = trimmed.substring(0, space);
  // 한글 이름은 "OO점"으로, 영어 이름은 첫 단어만 쓴다
  return RegExp('[\uAC00-\uD7A3]').hasMatch(trimmed) ? '$first\uC810' : first;
}

/// 체급 범위 이름 ("소형견" / "Small dogs"). 탭·칩·프로필에 쓴다.
String sizeScopeLabel(DogSize size) => switch (size) {
      DogSize.small => L10n.current.rankingSizeSmall,
      DogSize.medium => L10n.current.rankingSizeMedium,
      DogSize.large => L10n.current.rankingSizeLarge,
    };

enum RankingScope {
  all('all'),
  branch('branch'),
  size('size');

  const RankingScope(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        RankingScope.all => L10n.current.rankingScopeAll,
        RankingScope.branch => L10n.current.rankingScopeBranch,
        RankingScope.size => L10n.current.rankingScopeSize,
      };

  static RankingScope fromDb(String? value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => RankingScope.all);
}

/// 순위표 조회 조건 (Provider family 키)
@immutable
class RankingQuery {
  const RankingQuery({required this.month, this.scope = RankingScope.all, this.scopeKey = 'all', this.limit = 50});

  final DateTime month;
  final RankingScope scope;

  /// all: 'all', branch: 지점 ID, size: small/medium/large
  final String scopeKey;
  final int limit;

  @override
  bool operator ==(Object other) =>
      other is RankingQuery &&
      other.month == month &&
      other.scope == scope &&
      other.scopeKey == scopeKey &&
      other.limit == limit;

  @override
  int get hashCode => Object.hash(month, scope, scopeKey, limit);
}

/// 지난달 수상 칭호 ("10월 전체 1위")
class RankingTitle {
  const RankingTitle({
    required this.periodMonth,
    required this.scope,
    required String label,
    this.labelEn,
    required this.rank,
  }) : _label = label;

  final DateTime periodMonth;
  final RankingScope scope;
  final String _label;

  /// 서버가 주는 영어 라벨 (title_label_en 등). 없으면 한국어 라벨을 쓴다.
  final String? labelEn;
  final int rank;

  String get label => L10n.pick(_label, labelEn);

  String get text {
    final scopeText = scope == RankingScope.branch ? shortBranchName(label) : label;
    return L10n.current.rankingTitleText(Fmt.month(periodMonth), scopeText, rank);
  }
}

/// 순위표 한 줄 (get_leaderboard). 닉네임·반려견 정보만 있고 실명·연락처는 없다.
class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.dogId,
    required this.dogName,
    required this.nickname,
    required this.points,
    required this.sessionCount,
    required this.distanceMeters,
    required this.participantCount,
    String? breedLabel,
    this.breedLabelEn,
    this.size,
    this.photoPath,
    String? mainBranchName,
    this.mainBranchNameEn,
    this.cheerCount = 0,
    this.cheeredByMe = false,
    this.isMine = false,
    this.title,
  })  : _breedLabel = breedLabel,
        _mainBranchName = mainBranchName;

  factory LeaderboardEntry.fromJson(Json json) {
    final titlePeriod = json.strOrNull('title_period');
    return LeaderboardEntry(
      rank: json.intOr('rank'),
      dogId: json.str('dog_id'),
      dogName: json.str('dog_name'),
      breedLabel: json.strOrNull('breed_label'),
      breedLabelEn: json.strOrNull('breed_label_en'),
      size: DogSize.fromDb(json.strOrNull('size_class')),
      photoPath: json.strOrNull('photo_path'),
      nickname: json.strOrNull('nickname') ?? '',
      mainBranchName: json.strOrNull('main_branch_name'),
      mainBranchNameEn: json.strOrNull('main_branch_name_en'),
      points: json.intOr('points'),
      sessionCount: json.intOr('session_count'),
      distanceMeters: json.dblOr('distance_meters'),
      cheerCount: json.intOr('cheer_count'),
      cheeredByMe: json.boolOr('cheered_by_me'),
      isMine: json.boolOr('is_mine'),
      participantCount: json.intOr('participant_count'),
      title: titlePeriod == null
          ? null
          : RankingTitle(
              periodMonth: DateTime.parse(titlePeriod),
              scope: RankingScope.fromDb(json.strOrNull('title_scope')),
              label: json.strOrNull('title_label') ?? '',
              labelEn: json.strOrNull('title_label_en'),
              rank: json.intOr('title_rank'),
            ),
    );
  }

  final int rank;
  final String dogId;
  final String dogName;
  final String? _breedLabel;
  final String? breedLabelEn;
  final DogSize? size;

  /// 보호자가 사진 공개를 켰을 때만 있다
  final String? photoPath;
  final String nickname;

  /// 이번 달 가장 많이 운동한 지점
  final String? _mainBranchName;
  final String? mainBranchNameEn;

  String? get breedLabel => L10n.pickOrNull(_breedLabel, breedLabelEn);

  String? get mainBranchName => L10n.pickOrNull(_mainBranchName, mainBranchNameEn);
  final int points;
  final int sessionCount;
  final double distanceMeters;
  final int cheerCount;
  final bool cheeredByMe;
  final bool isMine;
  final int participantCount;
  final RankingTitle? title;
}

/// 내 반려견의 한 범위 순위
class ScopeRank {
  const ScopeRank({
    required this.scope,
    required this.scopeKey,
    required String label,
    this.labelEn,
    required this.rank,
    required this.participantCount,
    required this.points,
    required this.topPercent,
    this.pointsToNext,
  }) : _label = label;

  factory ScopeRank.fromJson(Json json) => ScopeRank(
        scope: RankingScope.fromDb(json.strOrNull('scope')),
        scopeKey: json.strOrNull('scope_key') ?? 'all',
        label: json.strOrNull('label') ?? '',
        labelEn: json.strOrNull('label_en'),
        rank: json.intOr('rank'),
        participantCount: json.intOr('participant_count'),
        points: json.intOr('points'),
        pointsToNext: json.intOrNull('points_to_next'),
        topPercent: json.intOr('top_percent', 100),
      );

  final RankingScope scope;
  final String scopeKey;

  /// 전체 / 지점명 / 소형견·중형견·대형견
  final String _label;
  final String? labelEn;
  final int rank;
  final int participantCount;
  final int points;

  /// 바로 위 순위를 앞지르는 데 필요한 점수. 1위면 null.
  final int? pointsToNext;
  final int topPercent;

  String get label => L10n.pick(_label, labelEn);

  /// "용산점 1위", "전체 2위" / "#1 Yongsan", "#2 Overall"
  String get shortText =>
      L10n.current.rankingScopeRankShort(scope == RankingScope.branch ? shortBranchName(label) : label, rank);
}

/// 내 반려견의 월간 점수·순위 (get_my_ranking)
class MyRanking {
  const MyRanking({
    required this.dogId,
    required this.periodMonth,
    required this.participating,
    required this.nickname,
    required this.points,
    required this.sessionCount,
    required this.distanceMeters,
    required this.weeklyBonusCount,
    required this.streakWeeks,
    required this.ranks,
  });

  factory MyRanking.fromJson(Json json) => MyRanking(
        dogId: json.str('dog_id'),
        periodMonth: DateTime.parse(json.str('period_month')),
        participating: json.boolOr('participating'),
        nickname: json.strOrNull('nickname') ?? '',
        points: json.intOr('points'),
        sessionCount: json.intOr('session_count'),
        distanceMeters: json.dblOr('distance_meters'),
        weeklyBonusCount: json.intOr('weekly_bonus_count'),
        streakWeeks: json.intOr('streak_weeks'),
        ranks: json.objList('ranks').map(ScopeRank.fromJson).toList(),
      );

  final String dogId;
  final DateTime periodMonth;

  /// 보호자가 랭킹 참여에 동의했는지. false면 순위는 "참여하면 n위"다.
  final bool participating;
  final String nickname;
  final int points;
  final int sessionCount;
  final double distanceMeters;
  final int weeklyBonusCount;

  /// 이번 주(또는 지난주)까지 이어진 연속 운동 주
  final int streakWeeks;

  /// 전체 → 운동한 지점(점수 많은 순) → 체급
  final List<ScopeRank> ranks;

  ScopeRank? get overall => rankFor(RankingScope.all, 'all');

  /// 이번 달 점수가 가장 많은 지점
  ScopeRank? get mainBranch => ranks.where((r) => r.scope == RankingScope.branch).firstOrNull;

  ScopeRank? get sizeRank => ranks.where((r) => r.scope == RankingScope.size).firstOrNull;

  ScopeRank? rankFor(RankingScope scope, String scopeKey) =>
      ranks.where((r) => r.scope == scope && r.scopeKey == scopeKey).firstOrNull;
}

/// 지점 대항전 (get_branch_battle)
class BranchBattleEntry {
  const BranchBattleEntry({
    required this.rank,
    required this.branchId,
    required String branchName,
    this.branchNameEn,
    required this.distanceMeters,
    required this.sessionCount,
    required this.dogCount,
    required this.points,
  }) : _branchName = branchName;

  factory BranchBattleEntry.fromJson(Json json) => BranchBattleEntry(
        rank: json.intOr('rank'),
        branchId: json.str('branch_id'),
        branchName: json.str('branch_name'),
        branchNameEn: json.strOrNull('branch_name_en'),
        distanceMeters: json.dblOr('distance_meters'),
        sessionCount: json.intOr('session_count'),
        dogCount: json.intOr('dog_count'),
        points: json.intOr('points'),
      );

  final int rank;
  final String branchId;
  final String _branchName;
  final String? branchNameEn;
  final double distanceMeters;
  final int sessionCount;
  final int dogCount;
  final int points;

  String get branchName => L10n.pick(_branchName, branchNameEn);
}

/// 명예의 전당 한 줄 (get_hall_of_fame). 이후 랭킹 참여를 철회했으면 isHidden.
class HallOfFameEntry {
  const HallOfFameEntry({
    required this.periodMonth,
    required this.scope,
    required this.scopeKey,
    required String scopeLabel,
    this.scopeLabelEn,
    required this.rank,
    required this.points,
    this.dogId,
    this.dogName,
    String? breedLabel,
    this.breedLabelEn,
    this.photoPath,
    this.nickname,
    this.isMine = false,
    this.isHidden = false,
  })  : _scopeLabel = scopeLabel,
        _breedLabel = breedLabel;

  factory HallOfFameEntry.fromJson(Json json) => HallOfFameEntry(
        periodMonth: DateTime.parse(json.str('period_month')),
        scope: RankingScope.fromDb(json.strOrNull('scope')),
        scopeKey: json.strOrNull('scope_key') ?? 'all',
        scopeLabel: json.strOrNull('scope_label') ?? '',
        scopeLabelEn: json.strOrNull('scope_label_en'),
        rank: json.intOr('rank'),
        dogId: json.strOrNull('dog_id'),
        dogName: json.strOrNull('dog_name'),
        breedLabel: json.strOrNull('breed_label'),
        breedLabelEn: json.strOrNull('breed_label_en'),
        photoPath: json.strOrNull('photo_path'),
        nickname: json.strOrNull('nickname'),
        points: json.intOr('points'),
        isMine: json.boolOr('is_mine'),
        isHidden: json.boolOr('is_hidden'),
      );

  final DateTime periodMonth;
  final RankingScope scope;
  final String scopeKey;
  final String _scopeLabel;
  final String? scopeLabelEn;
  final int rank;
  final String? dogId;
  final String? dogName;
  final String? _breedLabel;
  final String? breedLabelEn;
  final String? photoPath;
  final String? nickname;
  final int points;
  final bool isMine;
  final bool isHidden;

  String get scopeLabel => L10n.pick(_scopeLabel, scopeLabelEn);

  String? get breedLabel => L10n.pickOrNull(_breedLabel, breedLabelEn);
}

enum BadgeTier {
  bronze('bronze'),
  silver('silver'),
  gold('gold');

  const BadgeTier(this.dbValue);

  final String dbValue;

  static BadgeTier fromDb(String? value) => values.firstWhere((e) => e.dbValue == value, orElse: () => bronze);
}

/// 배지 진행률 지표 (DB badges.metric)
enum BadgeMetric {
  sessions('sessions'),
  distanceMeters('distance_meters'),
  streakWeeks('streak_weeks'),
  branches('branches'),
  openRuns('open_runs');

  const BadgeMetric(this.dbValue);

  final String dbValue;

  static BadgeMetric? fromDb(String? value) {
    for (final metric in values) {
      if (metric.dbValue == value) return metric;
    }
    return null;
  }
}

/// 누적 지표 (무효 처리되지 않은 5분 이상 운동 기준)
class BadgeStats {
  const BadgeStats({
    this.sessions = 0,
    this.distanceMeters = 0,
    this.branches = 0,
    this.openRuns = 0,
    this.streakWeeks = 0,
    this.bestStreakWeeks = 0,
  });

  factory BadgeStats.fromJson(Json? json) {
    if (json == null) return const BadgeStats();
    return BadgeStats(
      sessions: json.intOr('sessions'),
      distanceMeters: json.dblOr('distance_meters'),
      branches: json.intOr('branches'),
      openRuns: json.intOr('open_runs'),
      streakWeeks: json.intOr('streak_weeks'),
      bestStreakWeeks: json.intOr('best_streak_weeks'),
    );
  }

  final int sessions;
  final double distanceMeters;
  final int branches;
  final int openRuns;

  /// 지금 이어지고 있는 연속 운동 주
  final int streakWeeks;

  /// 최장 연속 운동 주 (연속 출석 배지 기준)
  final int bestStreakWeeks;

  double valueFor(BadgeMetric metric) => switch (metric) {
        BadgeMetric.sessions => sessions.toDouble(),
        BadgeMetric.distanceMeters => distanceMeters,
        BadgeMetric.streakWeeks => bestStreakWeeks.toDouble(),
        BadgeMetric.branches => branches.toDouble(),
        BadgeMetric.openRuns => openRuns.toDouble(),
      };
}

/// 배지 카탈로그 (badges)
class BadgeDef {
  const BadgeDef({
    required this.code,
    required String name,
    required String description,
    this.nameEn,
    this.descriptionEn,
    required this.icon,
    required this.tier,
    this.metric,
    this.goal,
    this.sortOrder = 0,
  })  : _name = name,
        _description = description;

  factory BadgeDef.fromJson(Json json) => BadgeDef(
        code: json.str('code'),
        name: json.str('name'),
        description: json.strOrNull('description') ?? '',
        nameEn: json.strOrNull('name_en'),
        descriptionEn: json.strOrNull('description_en'),
        metric: BadgeMetric.fromDb(json.strOrNull('metric')),
        goal: json.dblOrNull('goal'),
        icon: json.strOrNull('icon') ?? 'paw',
        tier: BadgeTier.fromDb(json.strOrNull('tier')),
        sortOrder: json.intOr('sort_order'),
      );

  final String code;
  final String _name;
  final String _description;
  final String? nameEn;
  final String? descriptionEn;

  String get name => L10n.pick(_name, nameEn);

  String get description => L10n.pick(_description, descriptionEn);

  /// 진행률 지표. 시상대처럼 월간 마감 때 주는 배지는 null.
  final BadgeMetric? metric;
  final double? goal;

  /// 앱 아이콘 키 (BadgeMedallion이 Material 아이콘으로 바꾼다)
  final String icon;
  final BadgeTier tier;
  final int sortOrder;

  /// 0~1. 지표가 없는 배지는 null.
  double? progress(BadgeStats stats) {
    final metric = this.metric;
    final goal = this.goal;
    if (metric == null || goal == null || goal <= 0) return null;
    return (stats.valueFor(metric) / goal).clamp(0.0, 1.0);
  }

  /// "3 / 10회", "12.4 / 42.2km"
  String? progressLabel(BadgeStats stats) {
    final metric = this.metric;
    final goal = this.goal;
    if (metric == null || goal == null) return null;
    final value = stats.valueFor(metric);
    if (metric == BadgeMetric.distanceMeters) {
      final current = (value / 1000).clamp(0, goal / 1000);
      return L10n.current.badgeProgressDistance(current.toStringAsFixed(1), (goal / 1000).toStringAsFixed(1));
    }
    final current = value.clamp(0, goal).toInt();
    final target = goal.toInt();
    final l = L10n.current;
    return switch (metric) {
      BadgeMetric.sessions => l.badgeProgressSessions(current, target),
      BadgeMetric.streakWeeks => l.badgeProgressWeeks(current, target),
      BadgeMetric.branches => l.badgeProgressBranches(current, target),
      BadgeMetric.openRuns => l.badgeProgressOpenRuns(current, target),
      BadgeMetric.distanceMeters => throw StateError('handled above'),
    };
  }
}

class EarnedBadge {
  const EarnedBadge({required this.code, required this.earnedAt});

  factory EarnedBadge.fromJson(Json json) =>
      EarnedBadge(code: json.str('code'), earnedAt: json.dateTime('earned_at'));

  final String code;
  final DateTime earnedAt;
}

/// 월간 수상 기록 (명예의 전당)
class AwardRecord {
  const AwardRecord({
    required this.periodMonth,
    required this.scope,
    required this.scopeKey,
    required String scopeLabel,
    this.scopeLabelEn,
    required this.rank,
    required this.points,
  }) : _scopeLabel = scopeLabel;

  factory AwardRecord.fromJson(Json json) => AwardRecord(
        periodMonth: DateTime.parse(json.str('period_month')),
        scope: RankingScope.fromDb(json.strOrNull('scope')),
        scopeKey: json.strOrNull('scope_key') ?? 'all',
        scopeLabel: json.strOrNull('scope_label') ?? '',
        scopeLabelEn: json.strOrNull('scope_label_en'),
        rank: json.intOr('rank'),
        points: json.intOr('points'),
      );

  final DateTime periodMonth;
  final RankingScope scope;
  final String scopeKey;
  final String _scopeLabel;
  final String? scopeLabelEn;
  final int rank;
  final int points;

  String get scopeLabel => L10n.pick(_scopeLabel, scopeLabelEn);

  /// "10월 용산점 1위"
  String get text =>
      RankingTitle(periodMonth: periodMonth, scope: scope, label: _scopeLabel, labelEn: scopeLabelEn, rank: rank).text;
}

/// 내 반려견의 배지·진행률·수상 기록 (get_dog_achievements)
class DogAchievements {
  const DogAchievements({required this.stats, required this.badges, required this.awards});

  factory DogAchievements.fromJson(Json json) => DogAchievements(
        stats: BadgeStats.fromJson(json.objOrNull('stats')),
        badges: json.objList('badges').map(EarnedBadge.fromJson).toList(),
        awards: json.objList('awards').map(AwardRecord.fromJson).toList(),
      );

  final BadgeStats stats;

  /// 최근에 받은 순
  final List<EarnedBadge> badges;
  final List<AwardRecord> awards;

  EarnedBadge? earned(String code) => badges.where((b) => b.code == code).firstOrNull;
}

/// 랭킹에서 반려견을 눌렀을 때의 공개 프로필 (get_ranking_dog_profile)
class RankingDogProfile {
  const RankingDogProfile({
    required this.dogId,
    required this.dogName,
    required this.nickname,
    required this.isMine,
    required this.participating,
    required this.periodMonth,
    required this.points,
    required this.sessionCount,
    required this.distanceMeters,
    required this.cheerCount,
    required this.cheeredByMe,
    required this.badges,
    required this.awards,
    String? breedLabel,
    this.breedLabelEn,
    this.size,
    this.photoPath,
    this.rank,
    this.participantCount,
  }) : _breedLabel = breedLabel;

  factory RankingDogProfile.fromJson(Json json) => RankingDogProfile(
        dogId: json.str('dog_id'),
        dogName: json.str('dog_name'),
        breedLabel: json.strOrNull('breed_label'),
        breedLabelEn: json.strOrNull('breed_label_en'),
        size: DogSize.fromDb(json.strOrNull('size_class')),
        photoPath: json.strOrNull('photo_path'),
        nickname: json.strOrNull('nickname') ?? '',
        isMine: json.boolOr('is_mine'),
        participating: json.boolOr('participating'),
        periodMonth: DateTime.parse(json.str('period_month')),
        rank: json.intOrNull('rank'),
        participantCount: json.intOrNull('participant_count'),
        points: json.intOr('points'),
        sessionCount: json.intOr('session_count'),
        distanceMeters: json.dblOr('distance_meters'),
        cheerCount: json.intOr('cheer_count'),
        cheeredByMe: json.boolOr('cheered_by_me'),
        badges: json.objList('badges').map(EarnedBadge.fromJson).toList(),
        awards: json.objList('awards').map(AwardRecord.fromJson).toList(),
      );

  final String dogId;
  final String dogName;
  final String? _breedLabel;
  final String? breedLabelEn;
  final DogSize? size;
  final String? photoPath;
  final String nickname;
  final bool isMine;
  final bool participating;
  final DateTime periodMonth;

  /// 이번 달 전체 순위. 아직 점수가 없으면 null.
  final int? rank;
  final int? participantCount;
  final int points;
  final int sessionCount;
  final double distanceMeters;
  final int cheerCount;
  final bool cheeredByMe;
  final List<EarnedBadge> badges;
  final List<AwardRecord> awards;

  String? get breedLabel => L10n.pickOrNull(_breedLabel, breedLabelEn);
}

/// 점수 0점인 이유
enum PointsNote {
  tooShort('too_short'),
  dailyLimit('daily_limit');

  const PointsNote(this.dbValue);

  final String dbValue;

  String get message => switch (this) {
        PointsNote.tooShort => L10n.current.rankingPointsNoteTooShort,
        PointsNote.dailyLimit => L10n.current.rankingPointsNoteDailyLimit,
      };

  static PointsNote? fromDb(String? value) {
    for (final note in values) {
      if (note.dbValue == value) return note;
    }
    return null;
  }
}

/// 운동 1회의 점수 원장 행 (exercise_points). 주간 보너스는 그 주 두 번째 운동에 붙는다.
class SessionPoints {
  const SessionPoints({
    required this.isWeeklyBonus,
    required this.attendance,
    required this.achievement,
    required this.distance,
    required this.bonus,
    required this.points,
    this.note,
    this.voided = false,
  });

  factory SessionPoints.fromJson(Json json) => SessionPoints(
        isWeeklyBonus: json.strOrNull('kind') == 'weekly_bonus',
        attendance: json.intOr('attendance_points'),
        achievement: json.intOr('achievement_points'),
        distance: json.intOr('distance_points'),
        bonus: json.intOr('bonus_points'),
        points: json.intOr('points'),
        note: PointsNote.fromDb(json.strOrNull('note')),
        voided: json['voided_at'] != null,
      );

  final bool isWeeklyBonus;
  final int attendance;
  final int achievement;
  final int distance;
  final int bonus;
  final int points;
  final PointsNote? note;

  /// 운영자가 무효 처리한 점수
  final bool voided;
}

/// 운동 1회에 붙은 점수 합계 (무효 처리 제외)
class SessionPointsSummary {
  const SessionPointsSummary({
    required this.total,
    required this.attendance,
    required this.achievement,
    required this.distance,
    required this.weeklyBonus,
    this.note,
    this.voided = false,
  });

  /// 원장 행이 없으면 null (기록 전이거나 점수 제도 도입 전 운동)
  static SessionPointsSummary? of(List<SessionPoints> rows) {
    if (rows.isEmpty) return null;
    final active = rows.where((r) => !r.voided).toList();
    final session = rows.where((r) => !r.isWeeklyBonus).firstOrNull;
    return SessionPointsSummary(
      total: active.fold(0, (sum, r) => sum + r.points),
      attendance: active.fold(0, (sum, r) => sum + r.attendance),
      achievement: active.fold(0, (sum, r) => sum + r.achievement),
      distance: active.fold(0, (sum, r) => sum + r.distance),
      weeklyBonus: active.fold(0, (sum, r) => sum + r.bonus),
      note: session?.note,
      voided: session?.voided ?? false,
    );
  }

  final int total;
  final int attendance;
  final int achievement;
  final int distance;
  final int weeklyBonus;
  final PointsNote? note;
  final bool voided;
}
