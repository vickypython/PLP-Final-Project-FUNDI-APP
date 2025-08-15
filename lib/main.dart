import 'package:firebase_core/firebase_core.dart';
import 'package:fundi/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fundi/screens/home_page.dart';
import 'package:fundi/screens/onboarding/login.dart';
import 'package:fundi/screens/onboarding/role_selection.dart';
import 'package:fundi/screens/onboarding/signup.dart';
import 'package:fundi/screens/splash_screen.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundi App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => const LogIn(),
        '/register': (context) => const Signup(),
        '/roleSelection': (context) => const RoleSelectionScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
