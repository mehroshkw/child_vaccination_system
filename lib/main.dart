import 'package:child_vaccination_system/constants/local_storage.dart';
import 'package:child_vaccination_system/constants/theme.dart';
import 'package:child_vaccination_system/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vaccination Management System',
      debugShowCheckedModeBanner: false,
      theme: theme(),

      /// route where the app should first start
      home: const Splash(),
    );
  }
}
