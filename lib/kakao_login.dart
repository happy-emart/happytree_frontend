// import 'dart:html';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class KakaoApp extends StatelessWidget {
//   const KakaoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter App',
//       home: WebViewPage(),
//     );
//   }
// }

// class WebViewPage extends StatefulWidget {
//   const WebViewPage({super.key});

//   @override
//   State<WebViewPage> createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {

//   final url = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=61cf0a365da5ecf4a1c4bd3d12aed9ab&redirect_uri=http://127.0.0.1:8080/kakao/sign_in";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: Uri.parse(url),
//         ),
//         initialOptions: InAppWebViewGroupOptions(
//             android: AndroidInAppWebViewOptions(useHybridComposition: true)),
//       ),
//     );
//   }
// }