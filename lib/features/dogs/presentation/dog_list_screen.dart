import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../data/dog.dart';
import '../providers.dart';
import 'widgets/dog_avatar.dart';

/// 마이페이지 > 반려견 관리
class DogListScreen extends ConsumerWidget {
  const DogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(activeDogIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('반려견 관리')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.dogNew),
        backgroundColor: AppColors.mintDeep,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('반려견 등록', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: AsyncValueView<List<Dog>>(
        value: ref.watch(dogsProvider),
        onRetry: () => ref.invalidate(dogsProvider),
        data: (dogs) {
          if (dogs.isEmpty) {
            return const EmptyState(
              icon: Icons.pets_rounded,
              title: '등록된 반려견이 없어요',
              message: '반려견을 등록하고 운동 예약과 AI 분석을 시작해 보세요.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
            itemCount: dogs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final dog = dogs[index];
              return AppCard(
                padding: const EdgeInsets.all(16),
                onTap: () => context.push(AppRoutes.dogDetail(dog.id)),
                child: Row(
                  children: [
                    DogAvatar(dog: dog, size: 56),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(dog.name, style: Theme.of(context).textTheme.titleMedium),
                              if (dog.id == selectedId) ...[
                                const SizedBox(width: 8),
                                StatusBadge(
                                  label: '홈에 표시 중',
                                  tone: Theme.of(context).colorScheme.activeTone,
                                  dense: true,
                                ),
                              ],
                            ],
                          ),
                          if (dog.summary.isNotEmpty) Text(dog.summary),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
