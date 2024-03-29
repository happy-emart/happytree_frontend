import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = "http://168.131.151.213:4040";

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

// initState 무엇을 위해?
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final String Url = "$baseUrl/auth";
    final request = Uri.parse(Url);
    var headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String id = _idController.text;
    String password = _passwordController.text;
    var body = {
      'email': id,
      'password': password,
    };

    http.Response response;

    response = await http.post(request, headers: headers, body: json.encode(body));
    if(response.statusCode == 200)
    {
      storeJwtToken(response.body);
      startFirstPage(context);
    }
    else
    {
      final error = json.decode(response.body);
      print('Request failed with status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding3 =
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'ID',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _login();
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log-In Page'),
      ),
      body:
      padding3,
    );
  }

  Future<void> storeJwtToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('jwtToken', token);
  }
}