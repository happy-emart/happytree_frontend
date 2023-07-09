import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

void main() {
  runApp(LoginApp());
}

class LoginForm {
  final String email;
  final String password;

  LoginForm({
    required this.email,
    required this.password,
});

  factory LoginForm.fromJson(Map<String,dynamic> json)
  {
    return LoginForm(
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
    final String Url = "http://localhost:8080/auth";
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

    var response;

      response = await http.post(request, headers: headers, body: json.encode(body));
      if(response.statusCode == 200)
      {
        var responseData = json.decode(response.body);
        print("request sunggonged");
        print(responseData);
      }
      else
      {
        print('Request failed with status: ${response.statusCode}');
      }
  }

  @override
  Widget build(BuildContext context) {
    var padding1 =
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'ID',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('Next'),
            ),
          ],
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text('Log-In Page'),
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

