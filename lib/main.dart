import 'package:flutter/material.dart';
import 'package:pramana_qr_verifier/screens/Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pramana QR',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor:  Colors.white,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

