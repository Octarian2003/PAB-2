import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:info_loker_pab/firebase_options.dart';
import 'package:info_loker_pab/navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BottomNavBar());
  }
}
