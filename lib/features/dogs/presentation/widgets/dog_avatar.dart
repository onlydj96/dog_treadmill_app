import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dog.dart';
import '../../providers.dart';

/// 반려견 프로필 사진 (비공개 버킷 → 서명 URL). 사진이 없으면 발바닥 아이콘.
class DogAvatar extends ConsumerWidget {
  const DogAvatar({super.key, required this.dog, this.size = 48, this.ringColor}) : imagePath = null;

  /// [Dog] 없이 사진 경로만 있을 때 (랭킹의 다른 회원 반려견 등). 경로가 null이면 기본 아이콘.
  const DogAvatar.path({super.key, required String? path, this.size = 48, this.ringColor})
      : dog = null,
        imagePath = path;

  final Dog? dog;
  final String? imagePath;
  final double size;
  final Color? ringColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: AppColors.honey, shape: BoxShape.circle),
      child: Icon(Icons.pets_rounded, size: size * 0.48, color: AppColors.honeyInk),
    );

    final path = imagePath ?? dog?.profileImagePath;
    Widget avatar = fallback;
    if (path != null) {
      avatar = ref.watch(dogImageUrlProvider(path)).maybeWhen(
            data: (url) => ClipOval(
              child: Image(
                image: _imageFor(url),
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

  /// 서명 URL은 네트워크 이미지로, `data:` URL(데모 앱 목업 서버의 사진)은 메모리 이미지로 그린다.
  /// 같은 data URL은 다시 디코딩하지 않도록 캐시한다 (매초 다시 그리는 화면에서 깜박이지 않게).
  static ImageProvider _imageFor(String url) {
    if (!url.startsWith('data:')) return NetworkImage(url);
    return _dataImages[url] ??= MemoryImage(UriData.parse(url).contentAsBytes());
  }

  static final _dataImages = <String, MemoryImage>{};
}
