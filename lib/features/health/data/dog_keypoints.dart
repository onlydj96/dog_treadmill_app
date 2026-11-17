/// AI Pose 15개 관절 Keypoint (문서 3.4-A).
/// [isFarSide]는 측면 카메라 반대편(오른쪽) 다리. 도식에서 옅게 그린다.
enum DogKeypoint {
  nose('nose', '코'),
  withers('withers', '기갑(어깨 위)'),
  tailBase('tail_base', '꼬리 시작점'),
  leftElbow('left_elbow', '왼쪽 앞다리 팔꿈치'),
  leftCarpus('left_carpus', '왼쪽 앞발목'),
  leftFrontPaw('left_front_paw', '왼쪽 앞발'),
  rightElbow('right_elbow', '오른쪽 앞다리 팔꿈치', isFarSide: true),
  rightCarpus('right_carpus', '오른쪽 앞발목', isFarSide: true),
  rightFrontPaw('right_front_paw', '오른쪽 앞발', isFarSide: true),
  leftStifle('left_stifle', '왼쪽 뒷다리 무릎'),
  leftHock('left_hock', '왼쪽 뒷발목(비절)'),
  leftHindPaw('left_hind_paw', '왼쪽 뒷발'),
  rightStifle('right_stifle', '오른쪽 뒷다리 무릎', isFarSide: true),
  rightHock('right_hock', '오른쪽 뒷발목(비절)', isFarSide: true),
  rightHindPaw('right_hind_paw', '오른쪽 뒷발', isFarSide: true);

  const DogKeypoint(this.key, this.label, {this.isFarSide = false});

  final String key;
  final String label;
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
