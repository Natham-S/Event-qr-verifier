import 'package:flutter/material.dart';

class ScannedCodeDialog{
  static void showScannedCodeDialog(BuildContext context,String scannedCode, bool isVerified , bool alreadyScanned,Function() onResumeCamera, bool isPaused) async {
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
                  Icon(alreadyScanned ? Icons.verified : Icons.error),
                  Text(alreadyScanned ? 'Not Scanned Before' : 'Scanned'),
                ],
              ),
              SizedBox(height: alreadyScanned ? 16 : 0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  isPaused = false;
                  onResumeCamera();
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