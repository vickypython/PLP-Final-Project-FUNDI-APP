import 'package:firebase_core/firebase_core.dart';
import 'package:fundi/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fundi/screens/pages/login.dart';
import 'package:fundi/screens/pages/post_project.dart';
import 'package:fundi/screens/pages/profile_setup.dart';
import 'package:fundi/screens/pages/projects.dart';
import 'package:fundi/screens/pages/signup.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
      ),
      initialRoute: '/view/projects',
      routes: {
        '/': (context) => LogIn(),
        '/register':(context)=>Signup(),
        '/project': (context) => PostProject(),
        '/profile': (context) => ProfileSetup(),
        '/view/projects':(_)=>ShowProjects()
      },
    );
  }
}
