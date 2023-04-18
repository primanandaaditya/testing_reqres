import 'package:flutter/material.dart';
import 'package:testing/screens/create/CreateScreen.dart';
import 'package:testing/screens/login/LoginScreen.dart';
import 'package:testing/screens/register/RegisterScreen.dart';
import 'screens/list/UserScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Testing',
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/user':(context) => const UserScreen(),
        '/create':(context) => const CreateScreen()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

