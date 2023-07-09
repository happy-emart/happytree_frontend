import 'package:flutter/material.dart';

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
  late TabController _tabController;
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    String id = _idController.text;
    String password = _passwordController.text;
    // Perform login authentication here
    print('ID: $id');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    var padding2 = Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _login(); // Perform login
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
    var padding1 = Padding(
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
                    _tabController.animateTo(1); // Switch to the next tab
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
