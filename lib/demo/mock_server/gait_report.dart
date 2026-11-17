import 'dart:math';

import '../../core/utils/json.dart';

/// AI 서버(FastAPI)가 analysis_reports에 저장하는 결과와 같은 형식의 샘플 (docs/analysis-metrics.md).
///
/// [issueLevel]은 0(특이사항 없음)~1(뚜렷한 변화). 관절질환이 있는 반려견은 왼쪽 뒷다리 무릎 가동 범위가
/// 기준선보다 줄어드는 모습으로 표현한다. 문구는 진단이 아니라 관찰된 변화만 서술한다.
Json generateGaitReport({
  required Json dog,
  required Random random,
  double issueLevel = 0,
}) {
  double jitter(double value, double ratio) => value * (1 + (random.nextDouble() * 2 - 1) * ratio);
  double round(double value, [int digits = 1]) => double.parse(value.toStringAsFixed(digits));

  // 개체별 기준선은 반려견마다 일정해야 하므로 ID로 고정한다
  final individual = Random(dog.str('id').codeUnits.fold<int>(17, (hash, unit) => (hash * 31 + unit) & 0x7fffffff));
  double personal(double value, double ratio) => value * (1 + (individual.nextDouble() * 2 - 1) * ratio);

  final cadenceBase = switch (dog['size_class']) {
    'small' => 172.0,
    'large' => 122.0,
    _ => 148.0,
  };
  final baselineCadence = personal(cadenceBase, 0.04);
  final baselineSymmetry = personal(0.95, 0.015).clamp(0.9, 0.98);
  final baselineCv = personal(0.05, 0.15);

  final issue = issueLevel.clamp(0.0, 1.0);
  final stifleDrop = issue * (0.08 + random.nextDouble() * 0.1); // 최대 약 18% 감소

  const joints = <String, (double, double)>{
    'left_elbow': (38, 128),
    'right_elbow': (38, 128),
    'left_carpus': (70, 165),
    'right_carpus': (70, 165),
    'left_stifle': (46, 124),
    'right_stifle': (46, 124),
    'left_hock': (40, 134),
    'right_hock': (40, 134),
  };
  final jointRows = <Json>[];
  final romChanges = <String, double>{};
  for (final MapEntry(key: key, value: (romBase, meanBase)) in joints.entries) {
    final baselineRom = personal(romBase, 0.06);
    var rom = jitter(baselineRom, 0.04);
    if (key == 'left_stifle') rom = baselineRom * (1 - stifleDrop) * (1 + (random.nextDouble() - 0.5) * 0.02);
    final mean = jitter(meanBase, 0.02);
    romChanges[key] = (rom - baselineRom) / baselineRom;
    jointRows.add({
      'key': key,
      'rom_deg': round(rom),
      'mean_angle_deg': round(mean),
      'min_angle_deg': round(mean - rom / 2),
      'max_angle_deg': round(mean + rom / 2),
      'baseline_rom_deg': round(baselineRom),
      'confidence': round(0.84 + random.nextDouble() * 0.12, 2),
    });
  }

  final hindSymmetry = (baselineSymmetry - issue * 0.09 + (random.nextDouble() - 0.5) * 0.02).clamp(0.7, 0.99);
  final frontSymmetry = (baselineSymmetry + (random.nextDouble() - 0.5) * 0.03).clamp(0.85, 0.99);
  final symmetry = (hindSymmetry + frontSymmetry) / 2;
  final cadence = jitter(baselineCadence, 0.03);
  final cv = baselineCv * (1 + issue * 0.5) * (1 + (random.nextDouble() - 0.5) * 0.2);

  // 이상 움직임: 기준선 대비 가동 범위가 10% 넘게 줄었거나 뒷다리 대칭이 낮으면 관찰 필요
  final findings = <Json>[];
  for (final MapEntry(key: key, value: change) in romChanges.entries) {
    if (change > -0.10) continue;
    final percent = (-change * 100).round();
    findings.add({
      'joint': key,
      'description': '가동 범위가 기준선보다 $percent% 줄었어요.',
      'description_en': 'Range of motion is $percent% below baseline.',
      'severity': change <= -0.2 ? 'warning' : 'caution',
    });
  }
  if (hindSymmetry < 0.87) {
    findings.add({
      'joint': 'left_hock',
      'label': '뒷다리 좌우 균형',
      'label_en': 'Hind-leg balance',
      'description': '왼쪽과 오른쪽 뒷다리의 움직임 차이가 평소보다 커요.',
      'description_en': 'The difference between left and right hind-leg movement is larger than usual.',
      'severity': 'caution',
    });
  }
  final level = findings.any((f) => f['severity'] == 'warning')
      ? 'warning'
      : findings.isEmpty
          ? 'normal'
          : 'caution';

  final hasNote = random.nextDouble() < 0.25;
  final notes = <String>[
    if (hasNote) '측면 카메라에서 오른쪽 다리가 일부 가려져 신뢰도가 다소 낮아요.',
  ];
  final notesEn = <String>[
    if (hasNote) 'The right leg was partly hidden from the side camera, so confidence is a bit lower.',
  ];
  final summary = switch (level) {
    'warning' => '왼쪽 뒷다리 무릎의 움직임이 기준선보다 크게 줄었어요. 불편해 보이면 동물병원 진료를 받아 보세요.',
    'caution' => '왼쪽 뒷다리를 평소보다 덜 굽히며 걷는 모습이 관찰됐어요. 며칠 동안 걸음걸이를 지켜봐 주세요.',
    _ => '보행 리듬과 좌우 균형이 기준선과 비슷하게 유지되고 있어요. 지금처럼 꾸준히 운동해 주세요.',
  };

  final summaryEn = switch (level) {
    'warning' =>
      'Movement in the left hind-leg knee has dropped a lot from baseline. If your dog seems uncomfortable, please see a vet.',
    'caution' =>
      'We noticed your dog bending the left hind leg less than usual while walking. Keep an eye on the gait for a few days.',
    _ => 'Gait rhythm and left-right balance are staying close to baseline. Keep up the steady exercise.',
  };

  return {
    'joint_metrics': {'keypoint_count': 15, 'joints': jointRows},
    'gait_metrics': {
      'cadence_spm': round(cadence),
      'stride_time_s': round(120 / cadence, 2),
      'stride_time_cv': round(cv, 3),
      'symmetry_index': round(symmetry, 2),
      'front_symmetry': round(frontSymmetry, 2),
      'hind_symmetry': round(hindSymmetry, 2),
      'rhythm_score': round((1 - cv * 2.2).clamp(0.6, 0.97), 2),
      'baseline': {
        'cadence_spm': round(baselineCadence),
        'symmetry_index': round(baselineSymmetry, 2),
        'stride_time_cv': round(baselineCv, 3),
      },
    },
    'anomaly_metrics': {
      'level': level,
      'anomaly_score': round((stifleDrop * 2.2 + (1 - hindSymmetry) * 1.2).clamp(0.03, 0.9), 2),
      'confidence': round(notes.isEmpty ? 0.88 + random.nextDouble() * 0.07 : 0.78 + random.nextDouble() * 0.06, 2),
      'findings': findings,
      'notes': notes,
      'notes_en': notesEn,
    },
    'summary': summary,
    'summary_en': summaryEn,
    'care_notes': [
      '운동 전후로 5분씩 천천히 걸으며 몸을 풀어 주세요.',
      if (level != 'normal') '미끄러운 바닥에서 뛰거나 점프하지 않게 해 주세요.',
      '운동 후에는 물을 충분히 마실 수 있게 해 주세요.',
    ],
    'care_notes_en': [
      'Walk slowly for 5 minutes before and after exercise to warm up and cool down.',
      if (level != 'normal') 'Keep your dog from running or jumping on slippery floors.',
      'Make sure your dog can drink plenty of water after exercise.',
    ],
    'model_version': 'gait-v0.3',
  };
}
