import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';


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

  String scannedCode = "";
  bool isPaused = false;

  bool isCameraPaused = false;

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
      setState(() {
        if(!isPaused){
          scannedCode = scanData.code!;
            _showScannedCodeDialog(scannedCode);
            isPaused = true;
            controller.pauseCamera();
        }
      });
    });
  }

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
    void _showScannedCodeDialog(String scannedCode) async {
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
                const Row(
                  children: [
                   Icon(Icons.verified),
                    Text('Verified User'),
                  ],

                ),

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pramana QR"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:  Padding(
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
               child: QRView(
                 overlay: QrScannerOverlayShape(
                   borderColor: Colors.blue,
                   borderRadius: 14,
                   borderLength: 50,
                   borderWidth: 10,
                   cutOutSize: 340,
                   cutOutBottomOffset: 40,
                   overlayColor: Colors.white
                 ), key: qrKey, onQRViewCreated: _onQRViewCreated)
           ),

            ElevatedButton(
              onPressed: toggleCameraPause,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isCameraPaused ? Colors.green : Colors.red,
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  CircleBorder(),
                ),
              ),
              child: Icon(
                isCameraPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 32.0,

              ),
            )

          ],
        ),
      ),
    );
  }


}
