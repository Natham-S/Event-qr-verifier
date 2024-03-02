import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pramana_qr_verifier/firebase_options.dart';
import 'package:pramana_qr_verifier/screens/Dashboard.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    try{
      await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      print('Error initializing Firebase: $e');
    }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event QR Verifier',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor:  Colors.white,
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Dashboard(),
    );
  }
}

