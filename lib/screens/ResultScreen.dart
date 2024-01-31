import 'package:flutter/material.dart';
//import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ResultScreen extends StatelessWidget{
  final String scannedData;

  const ResultScreen({super.key, required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBar(
          title: const Text("Pramana QR"),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            QrImageView(
              data: scannedData,
              version: QrVersions.auto,
              size: 200.0,
            ),


            const Text("Scanned QR",style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w400,

            ),),
            SizedBox(height: 10,),


          ],
        ),
      ),
    );
  }

}