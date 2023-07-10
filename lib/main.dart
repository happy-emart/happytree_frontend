
import 'package:flutter/material.dart';
import 'package:flutter_application_1/sign_in.dart';
import 'package:mysql1/mysql1.dart';
import 'login.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    title: 'GNav',
    theme: ThemeData(
      primaryColor: Colors.grey[800],
    ),
    home: const MainScreen()));

// class MainApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainScreen(),
//     );
//   }
// }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{

// initState 무엇을 위해?
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding1 =
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginApp()));
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInApp()));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main-Page'),
      ),
      body:
        padding1,
    );
  }
}