import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewer extends StatelessWidget {
  const QRViewer({Key? key, required this.qrrKey, required this.onQRViewCreated})
      : super(key: key);

  final GlobalKey qrrKey;
  final Function(QRViewController) onQRViewCreated;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue,
        borderRadius: 14,
        borderLength: 50,
        borderWidth: 10,
        cutOutSize: 340,
        cutOutBottomOffset: 40,
        overlayColor: Colors.white,
      ),
    );
  }
}


