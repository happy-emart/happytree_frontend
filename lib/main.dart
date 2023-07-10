import 'dart:convert';

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_application_1/sign_in.dart';
=======
import 'package:flutter_application_1/first_tab.dart';
>>>>>>> 363d5e6f8b945c95c790a0d7009a49947f8af61b
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

import 'login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
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
<<<<<<< HEAD
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginApp()));

=======
                // _login();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const startFirstPage())
                // );
                startFirstPage(context);
>>>>>>> 363d5e6f8b945c95c790a0d7009a49947f8af61b
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInApp()));
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text('Main-Page'),
      ),
      body:
        padding1,
    );
  }
}


Future<void> dbConnector() async {
  print("Connecting to mysql server ...");

  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'user',
    password: 'factory',
    db: 'factory_db',
  );

  final conn = await MySqlConnection.connect(settings);

  print("Connected");

  await conn.close();
}

