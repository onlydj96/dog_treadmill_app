import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'dog.dart';

class DogRepository {
  DogRepository(this._client);

  final SupabaseClient _client;

  static const profileBucket = 'dog-profiles';

  Future<List<Dog>> fetchDogs(String ownerId) async {
    final rows = await _client
        .from('dogs')
        .select()
        .eq('owner_id', ownerId)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: true);
    return rows.map(Dog.fromJson).toList();
  }

  Future<Dog> fetchDog(String dogId) async {
    final row = await _client.from('dogs').select().eq('id', dogId).single();
    return Dog.fromJson(row);
  }

  Future<Dog> createDog(String ownerId, DogDraft draft) async {
    final row = await _client.from('dogs').insert({...draft.toJson(), 'owner_id': ownerId}).select().single();
    return Dog.fromJson(row);
  }

  Future<Dog> updateDog(String dogId, DogDraft draft) async {
    final row = await _client.from('dogs').update(draft.toJson()).eq('id', dogId).select().single();
    return Dog.fromJson(row);
  }

  /// 소프트 삭제 — 운동·분석 이력은 보존된다.
  Future<void> deleteDog(String dogId) async {
    await _client.from('dogs').update({'deleted_at': DateTime.now().toUtc().toIso8601String()}).eq('id', dogId);
  }

  Future<DogHealthProfile?> fetchHealthProfile(String dogId) async {
    final row = await _client.from('dog_health_profiles').select().eq('dog_id', dogId).maybeSingle();
    return row == null ? null : DogHealthProfile.fromJson(row);
  }

  Future<void> saveHealthProfile(DogHealthProfile profile) async {
    await _client.from('dog_health_profiles').upsert(profile.toJson(), onConflict: 'dog_id');
  }

  /// 프로필 사진 업로드 후 dogs.profile_image_path 갱신. 이전 사진은 삭제한다.
  Future<String> uploadProfileImage({
    required Dog dog,
    required Uint8List bytes,
    required String extension,
  }) async {
    final ext = _normalizeExtension(extension);
    final path = '${dog.ownerId}/${dog.id}/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from(profileBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: _contentType(ext), upsert: false),
        );
    await _client.from('dogs').update({'profile_image_path': path}).eq('id', dog.id);

    final previous = dog.profileImagePath;
    if (previous != null && previous != path) {
      // 이전 파일 삭제 실패는 사용자 흐름을 막지 않는다 (고아 파일은 운영에서 정리 가능)
      try {
        await _client.storage.from(profileBucket).remove([previous]);
      } on StorageException {
        // ignore
      }
    }
    return path;
  }

  Future<String> createSignedImageUrl(String path) {
    return _client.storage.from(profileBucket).createSignedUrl(path, 60 * 60);
  }

  static String _normalizeExtension(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    return switch (ext) {
      'jpeg' || 'jpg' => 'jpg',
      'png' || 'webp' || 'heic' => ext,
      _ => 'jpg',
    };
  }

  static String _contentType(String ext) => switch (ext) {
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' => 'image/heic',
        _ => 'image/jpeg',
      };
}
