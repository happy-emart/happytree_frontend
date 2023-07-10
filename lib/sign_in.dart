import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin{
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

// initState 무엇을 위해?
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _login() async {
    final String Url = "http://127.0.0.1:8080/signup";
    final request = Uri.parse(Url);
    var headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String id = _idController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    var body = {
      'email': id,
      'password': password,
      'username': username,
    };

    var response;

    response = await http.post(request, headers: headers, body: json.encode(body));
    print("response printed!!");
    print(response);
    if(response.statusCode == 200)
    {
      print("request sunggonged");
      print(response.body);
      final jwtParts = response.body.split('.');

      final payload = utf8.decode(base64Url.decode(jwtParts[1]));
      print(payload);

    }
    else
    {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var padding2 =
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextField(
            controller: _usernameController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              _login();
            },
            child: Text('Sign Up!'),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Log-In Page'),
      ),
      body:
      padding2,
    );
  }


}