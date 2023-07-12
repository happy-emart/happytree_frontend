import 'dart:convert';
import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/kakao_login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/first_tab.dart';
import 'package:flutter_application_1/main.dart';

import 'dialog_builders.dart';
import 'login.dart';
import 'first_tab.dart';

String baseUrl = "http://168.131.151.213:4040";


class LoginFunctions {
  /// Collection of functions will be performed on login/signup.
  /// * e.g. [onLogin], [onSignup], [socialLogin], and [onForgotPassword]
  const LoginFunctions(this.context);
  final BuildContext context;


  /// Login action that will be performed on click to action button in login mode.
  Future<String?> onLogin(LoginData loginData) async {
    // var isSuccessed = _login(loginData.email, loginData.password, context);
    // await Future.delayed(const Duration(seconds: 2));
    // if (isSuccessed == "true") return "로그인에 성공했습니다." 
    // else return null;
    _login(loginData.email, loginData.password, context);
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  /// Sign up action that will be performed on click to action button in sign up mode.
  Future<String?> onSignup(SignUpData signupData) async {
    if (signupData.password != signupData.confirmPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }
    _signup(signupData.email, signupData.password, signupData.name);
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  /// Social login callback example.
  Future<String?> socialLogin(String type) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KakaoApp()),
    );
    // await Future.delayed(const Duration(seconds: 2));
    startFirstPage(context);
    return null;
  }

  /// Action that will be performed on click to "Forgot Password?" text/CTA.
  /// Probably you will navigate user to a page to create a new password after the verification.
  Future<String?> onForgotPassword(String email) async {
    DialogBuilder(context).showLoadingDialog();
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/forgotPass');
    return null;
  }
}

void _login(String id, String pw, BuildContext context) async {
  final String Url = "$baseUrl/auth";
  final request = Uri.parse(Url);
  var headers = <String, String> {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  var body = {
    'email': id,
    'password': pw,
  };

  http.Response response;

  response = await http.post(request, headers: headers, body: json.encode(body));
  if(response.statusCode == 200)
  {
    storeJwtToken(response.body);
    await Future.delayed(const Duration(seconds: 2));
    // return "true";
    startFirstPage(context);
  }
  else
  {
    final error = json.decode(response.body);
    print('Request failed with status: $error');
    // return "false";
  }
}

void _signup(String id, String pw, String username) async {
  final String Url = "$baseUrl/signup";
  final request = Uri.parse(Url);
  var headers = <String, String> {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  var body = {
    'email': id,
    'password': pw,
    'username': username,
  };

  http.Response response;

  response = await http.post(request, headers: headers, body: json.encode(body));
  if(response.statusCode == 200)
  {
    await Future.delayed(const Duration(seconds: 2));
    print('Signup completed!');
  }
  else
  {
    print('Signup failed with status');
  }
}

Future<void> storeJwtToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('jwtToken', token);
}
