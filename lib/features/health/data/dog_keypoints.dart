import 'dart:ui';

/// AI Pose 15개 관절 Keypoint (문서 3.4-A).
/// [position]은 측면 스켈레톤 도식에서의 정규화 좌표(0~1, 오른쪽이 머리).
/// [isFarSide]는 카메라 반대편 다리(도식에서 흐리게 표시).
enum DogKeypoint {
  nose('nose', '코', Offset(0.95, 0.24)),
  withers('withers', '기갑(어깨 위)', Offset(0.66, 0.30)),
  tailBase('tail_base', '꼬리 시작점', Offset(0.17, 0.32)),
  leftElbow('left_elbow', '왼쪽 앞다리 팔꿈치', Offset(0.67, 0.56)),
  leftCarpus('left_carpus', '왼쪽 앞발목', Offset(0.69, 0.77)),
  leftFrontPaw('left_front_paw', '왼쪽 앞발', Offset(0.72, 0.93)),
  rightElbow('right_elbow', '오른쪽 앞다리 팔꿈치', Offset(0.60, 0.55), isFarSide: true),
  rightCarpus('right_carpus', '오른쪽 앞발목', Offset(0.58, 0.76), isFarSide: true),
  rightFrontPaw('right_front_paw', '오른쪽 앞발', Offset(0.60, 0.93), isFarSide: true),
  leftStifle('left_stifle', '왼쪽 뒷다리 무릎', Offset(0.28, 0.58)),
  leftHock('left_hock', '왼쪽 뒷발목(비절)', Offset(0.21, 0.77)),
  leftHindPaw('left_hind_paw', '왼쪽 뒷발', Offset(0.24, 0.93)),
  rightStifle('right_stifle', '오른쪽 뒷다리 무릎', Offset(0.22, 0.57), isFarSide: true),
  rightHock('right_hock', '오른쪽 뒷발목(비절)', Offset(0.14, 0.76), isFarSide: true),
  rightHindPaw('right_hind_paw', '오른쪽 뒷발', Offset(0.16, 0.93), isFarSide: true);

  const DogKeypoint(this.key, this.label, this.position, {this.isFarSide = false});

  final String key;
  final String label;
  final Offset position;
  final bool isFarSide;

  static DogKeypoint? fromKey(String key) {
    for (final point in values) {
      if (point.key == key) return point;
    }
    return null;
  }

  /// 스켈레톤 연결선
  static const bones = <(DogKeypoint, DogKeypoint)>[
    (nose, withers),
    (withers, tailBase),
    (withers, leftElbow),
    (leftElbow, leftCarpus),
    (leftCarpus, leftFrontPaw),
    (withers, rightElbow),
    (rightElbow, rightCarpus),
    (rightCarpus, rightFrontPaw),
    (tailBase, leftStifle),
    (leftStifle, leftHock),
    (leftHock, leftHindPaw),
    (tailBase, rightStifle),
    (rightStifle, rightHock),
    (rightHock, rightHindPaw),
  ];
}
