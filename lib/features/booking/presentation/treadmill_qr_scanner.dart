import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../l10n/l10n.dart';
import '../data/booking_models.dart';

/// 트레드밀 QR을 읽어 그 내용(문자열)을 돌려준다. 취소하면 null.
typedef TreadmillQrScanner = Future<String?> Function(BuildContext context, Booking booking);

/// 실제 앱은 카메라 화면으로 읽는다. 데모 앱은 카메라 없이 트레드밀을 고르는 시트로 바꾼다 (demoOverrides).
final treadmillQrScannerProvider = Provider<TreadmillQrScanner>((ref) => scanTreadmillQrWithCamera);

Future<String?> scanTreadmillQrWithCamera(BuildContext context, Booking booking) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(fullscreenDialog: true, builder: (_) => TreadmillQrScanScreen(booking: booking)),
  );
}

/// 카메라로 트레드밀 QR을 읽는 화면. QR을 하나 읽으면 그 내용을 들고 닫힌다.
class TreadmillQrScanScreen extends StatefulWidget {
  const TreadmillQrScanScreen({super.key, required this.booking});

  final Booking booking;

  @override
  State<TreadmillQrScanScreen> createState() => _TreadmillQrScanScreenState();
}

class _TreadmillQrScanScreenState extends State<TreadmillQrScanScreen> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);
  var _done = false;

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    final raw = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
    if (raw == null) return;
    _done = true;
    Navigator.of(context).pop(raw);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final machine = widget.booking.treadmill?.deviceName;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.bookingQrScanTitle),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) => _ScannerError(error: error),
          ),
          const IgnorePointer(child: Center(child: _ScanFrame())),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bookingQrScanHint,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, height: 1.4),
                    ),
                    if (machine != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.bookingQrScanAssigned(machine),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, height: 1.5),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 3),
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(denied ? Icons.no_photography_rounded : Icons.videocam_off_rounded, color: Colors.white, size: 40),
              const SizedBox(height: 12),
              Text(
                denied ? l10n.bookingQrCameraDenied : l10n.bookingQrCameraError,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
