import 'package:flutter/material.dart';

import '../core/utils/json.dart';
import '../features/booking/data/booking_models.dart';
import '../l10n/l10n.dart';
import 'mock_server/mock_server.dart';

/// 데모의 "QR 스캔": 카메라 대신 예약한 지점의 트레드밀을 골라 그 기기의 QR 내용을 돌려준다.
/// 배정된 기기가 아닌 빈 기기를 고르면 실제처럼 그 기기로 옮겨 체크인된다.
Future<String?> pickDemoTreadmillQr(BuildContext context, MockServer server, Booking booking) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _DemoQrPicker(server: server, booking: booking),
  );
}

class _DemoQrPicker extends StatelessWidget {
  const _DemoQrPicker({required this.server, required this.booking});

  final MockServer server;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final machines = server.booking.machines(booking.branchId);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.demoQrPickerTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(l10n.demoQrPickerBody, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final machine in machines) _tile(context, machine),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, Json machine) {
    final l10n = context.l10n;
    final id = machine.str('id');
    final assigned = id == booking.treadmillId;
    final busy = server.booking.treadmillBusy(id, booking.startAt, booking.endAt, excludeBookingId: booking.id);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.qr_code_2_rounded),
      title: Text(machine.str('device_name')),
      subtitle: busy ? Text(l10n.demoQrBusy) : null,
      trailing: assigned ? Chip(label: Text(l10n.demoQrAssigned)) : null,
      onTap: () => Navigator.of(context).pop(server.booking.treadmillQrPayload(id)),
    );
  }
}
