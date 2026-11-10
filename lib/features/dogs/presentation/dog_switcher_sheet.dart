import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../providers.dart';
import 'widgets/dog_avatar.dart';

/// 다견 등록 시 반려견 전환 (문서 3.1)
Future<void> showDogSwitcherSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _DogSwitcherSheet(),
  );
}

class _DogSwitcherSheet extends ConsumerWidget {
  const _DogSwitcherSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dogs = ref.watch(dogsProvider).valueOrNull ?? const [];
    final selectedId = ref.watch(activeDogIdProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('반려견 선택', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final dog in dogs)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: dog.id == selectedId ? AppColors.mintMist : theme.colorScheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: dog.id == selectedId ? AppColors.mintMist : theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: DogAvatar(dog: dog, size: 44),
                    title: Text(
                      dog.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: dog.id == selectedId ? AppColors.mintInk : null,
                      ),
                    ),
                    subtitle: Text(
                      dog.summary,
                      style: TextStyle(color: dog.id == selectedId ? AppColors.mintDeep : null),
                    ),
                    trailing:
                        dog.id == selectedId ? const Icon(Icons.check_circle_rounded, color: AppColors.mintDeep) : null,
                    onTap: () {
                      ref.read(selectedDogIdProvider.notifier).select(dog.id);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.dogNew);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('반려견 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
