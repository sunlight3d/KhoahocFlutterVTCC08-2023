import 'package:flutter/material.dart';
import 'package:myapp/screens/camera_scan/index.dart';
import 'package:myapp/screens/nfc_scanning_guide/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: NFCScanningGuide(),
      home: CameraScan()
    );
  }
}

