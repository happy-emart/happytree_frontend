import 'package:flutter/material.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(LoginApp());
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
    String id = _idController.text;
    String password = _passwordController.text;
    // Perform login authentication here
    print('ID: $id');
    print('Password: $password');
    var req = LoginPostRequest(id, password);
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
                // _login();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => const startFirstPage())
                // );
                startFirstPage(context);
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

Future<http.Response> fetchPost() async {
  return http.get(Uri.parse("http://localhost:8081"));
}

Future<http.Response> LoginPostRequest(String id, String pw) async {
  return await http.post(
    Uri.parse("http://localhost:8081"),
    body: "{id : $id, pw : $pw}"
    );
}

// Future<http.Response> testHttpPost() async {
//   Post requestBody = Post.fromJson(json);
//   return http.post(Uri.parse("http://localhost:8081"), body: requestBody.toJson());
// }