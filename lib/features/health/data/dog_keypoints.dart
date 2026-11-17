import '../../../l10n/l10n.dart';

/// AI Pose 15개 관절 Keypoint (문서 3.4-A).
/// [isFarSide]는 측면 카메라 반대편(오른쪽) 다리. 도식에서 옅게 그린다.
enum DogKeypoint {
  nose('nose'),
  withers('withers'),
  tailBase('tail_base'),
  leftElbow('left_elbow'),
  leftCarpus('left_carpus'),
  leftFrontPaw('left_front_paw'),
  rightElbow('right_elbow', isFarSide: true),
  rightCarpus('right_carpus', isFarSide: true),
  rightFrontPaw('right_front_paw', isFarSide: true),
  leftStifle('left_stifle'),
  leftHock('left_hock'),
  leftHindPaw('left_hind_paw'),
  rightStifle('right_stifle', isFarSide: true),
  rightHock('right_hock', isFarSide: true),
  rightHindPaw('right_hind_paw', isFarSide: true);

  const DogKeypoint(this.key, {this.isFarSide = false});

  final String key;
  final bool isFarSide;

  /// 현재 언어의 관절 이름
  String get label => switch (this) {
        DogKeypoint.nose => L10n.current.keypointNose,
        DogKeypoint.withers => L10n.current.keypointWithers,
        DogKeypoint.tailBase => L10n.current.keypointTailBase,
        DogKeypoint.leftElbow => L10n.current.keypointLeftElbow,
        DogKeypoint.leftCarpus => L10n.current.keypointLeftCarpus,
        DogKeypoint.leftFrontPaw => L10n.current.keypointLeftFrontPaw,
        DogKeypoint.rightElbow => L10n.current.keypointRightElbow,
        DogKeypoint.rightCarpus => L10n.current.keypointRightCarpus,
        DogKeypoint.rightFrontPaw => L10n.current.keypointRightFrontPaw,
        DogKeypoint.leftStifle => L10n.current.keypointLeftStifle,
        DogKeypoint.leftHock => L10n.current.keypointLeftHock,
        DogKeypoint.leftHindPaw => L10n.current.keypointLeftHindPaw,
        DogKeypoint.rightStifle => L10n.current.keypointRightStifle,
        DogKeypoint.rightHock => L10n.current.keypointRightHock,
        DogKeypoint.rightHindPaw => L10n.current.keypointRightHindPaw,
      };

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
