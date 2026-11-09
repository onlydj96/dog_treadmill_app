import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import 'data/analysis_models.dart';
import 'data/analysis_repository.dart';

final analysisRepositoryProvider = Provider<AnalysisRepository>(
  (ref) => AnalysisRepository(ref.watch(supabaseClientProvider)),
);

final reportsProvider = FutureProvider.autoDispose.family<List<AnalysisReport>, String>(
  (ref, dogId) => ref.watch(analysisRepositoryProvider).fetchReports(dogId),
);

/// 완료된 리포트 (최신순)
final completedReportsProvider = Provider.autoDispose.family<AsyncValue<List<AnalysisReport>>, String>(
  (ref, dogId) => ref.watch(reportsProvider(dogId)).whenData(
        (reports) => reports.where((r) => r.isCompleted).toList(),
      ),
);

final reportDetailProvider = FutureProvider.autoDispose.family<AnalysisReport, String>(
  (ref, reportId) => ref.watch(analysisRepositoryProvider).fetchReport(reportId),
);

typedef PreviousReportQuery = ({String dogId, DateTime before});

final previousReportProvider = FutureProvider.autoDispose.family<AnalysisReport?, PreviousReportQuery>(
  (ref, query) =>
      ref.watch(analysisRepositoryProvider).fetchPreviousCompleted(dogId: query.dogId, before: query.before),
);

final poseRecordsProvider = FutureProvider.autoDispose.family<List<PoseRecord>, String>(
  (ref, sessionId) => ref.watch(analysisRepositoryProvider).fetchPoseRecords(sessionId),
);

final activePlanProvider = FutureProvider.autoDispose.family<ExercisePlan?, String>(
  (ref, dogId) => ref.watch(analysisRepositoryProvider).fetchActivePlan(dogId),
);
