import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
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
      appBar: AppBar(title: Text(context.l10n.dogListTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.dogNew),
        backgroundColor: AppColors.mintDeep,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.dogListRegister, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: AsyncValueView<List<Dog>>(
        value: ref.watch(dogsProvider),
        onRetry: () => ref.invalidate(dogsProvider),
        data: (dogs) {
          if (dogs.isEmpty) {
            return EmptyState(
              icon: Icons.pets_rounded,
              title: context.l10n.dogListEmptyTitle,
              message: context.l10n.dogListEmptyMessage,
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
                                  label: context.l10n.dogShownOnHome,
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
