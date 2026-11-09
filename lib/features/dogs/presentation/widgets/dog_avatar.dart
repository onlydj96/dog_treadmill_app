import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dog.dart';
import '../../providers.dart';

/// 반려견 프로필 사진 (비공개 버킷 → 서명 URL). 사진이 없으면 발바닥 아이콘.
class DogAvatar extends ConsumerWidget {
  const DogAvatar({super.key, required this.dog, this.size = 48, this.ringColor});

  final Dog? dog;
  final double size;
  final Color? ringColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
      child: Icon(Icons.pets_rounded, size: size * 0.48, color: AppColors.burgundy),
    );

    final path = dog?.profileImagePath;
    Widget avatar = fallback;
    if (path != null) {
      avatar = ref.watch(dogImageUrlProvider(path)).maybeWhen(
            data: (url) => ClipOval(
              child: Image.network(
                url,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
            ),
            orElse: () => fallback,
          );
    }

    if (ringColor == null) return avatar;
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ringColor!, width: 2)),
      child: avatar,
    );
  }
}
