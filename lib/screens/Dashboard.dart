import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pramana_qr_verifier/widgets/CameraControlButton.dart';
import 'package:pramana_qr_verifier/widgets/QRViewer.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  final ref = FirebaseDatabase.instance.ref("qr_codes");
  List<String> scannedCodes = [];
  String scannedCode = "";
  bool isPaused = false;
  bool isCameraPaused = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event QR verifier"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Place the QR code in the below area",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              "Scanning will be started automatically",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              flex: 4,
              child: QRViewer(qrrKey: qrKey, onQRViewCreated: _onQRViewCreated),
            ),
            CameraControlButton(
                onPressed: toggleCameraPause, isCameraPaused: isCameraPaused)
          ],
        ),
      ),
    );
  }

  void toggleCameraPause() {
    setState(() {
      isCameraPaused = !isCameraPaused;
      if (isCameraPaused) {
        controller?.pauseCamera();
      } else {
        controller?.resumeCamera();
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isPaused) {
        final String scannedCode = scanData.code!;

        setState(() {
          isPaused = true;
        });

        scannedCodes.add(scannedCode);

        ref.once().then((DatabaseEvent event) {
          DataSnapshot snapshot = event.snapshot;

          if (snapshot.value != null) {
            final String dbCode = snapshot.value.toString();

            print("Scanned code: $scannedCode");
            print("Database code: $dbCode");

            if (scannedCode == dbCode) {
              bool alreadyScanned = true;
              for (int i = 0; i < scannedCodes.length - 1; i++) {
                if (scannedCodes[i] == scannedCode) {
                  alreadyScanned = false;
                  break;
                }
              }
              _showScannedCodeDialog(scannedCode, true, alreadyScanned);
            } else {
              _showScannedCodeDialog(scannedCode, false, true);
            }
          } else {
            print("Error: Snapshot value is null");
            _showScannedCodeDialog(scannedCode, false, false);
          }

          controller.pauseCamera();
        }).catchError((error) {
          // Handle database error
          print("Error fetching data: $error");

          _showScannedCodeDialog(scannedCode, false, false);

          controller.pauseCamera();
        });
      }
    });
  }

  void _showScannedCodeDialog(
      String scannedCode, bool isVerified, bool alreadyScanned) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scanned QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(scannedCode),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(isVerified ? Icons.verified : Icons.error),
                  Text(isVerified ? 'Verified User' : 'Not Verified'),
                ],
              ),
              Row(
                children: [
                  Icon(alreadyScanned ? Icons.verified_user_rounded : Icons.error),
                  Text(alreadyScanned ? 'New User' : 'Already Scanned User'),
                ],
              ),
              SizedBox(height: alreadyScanned ? 16 : 0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  isPaused = false;
                  controller?.resumeCamera();
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      },
    );
  }
}
