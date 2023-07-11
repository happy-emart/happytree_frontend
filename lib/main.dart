import 'package:flutter/material.dart';
import 'package:flutter_application_1/sign_in.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    title: 'GNav',
    theme: ThemeData(
      primaryColor: Colors.grey[800],
    ),
    home: const MainScreen()));

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInApp()));
              },
              child: const Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const KakaoApp()));
              },
              child: const Text('Login with Kakaotalk'),
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

void returnToMain(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()),
  );
}
