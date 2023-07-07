import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';

// void main() {
//   // http.
//   runApp(App());
// } 

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Color(0xFF181818),
//         body: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 40,
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 80,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("안녕하세요, 영욱씨",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 38,
//                         fontWeight: FontWeight.w600,
//                       )),
//                       Text("오랜만이에요",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 22,
//                       )),                    
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }

void main() {
  dbConnector();
  runApp(const MyApp());
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

  final conn = await MySQLConnection.createConnection(
    host: 'jdbc:mysql://localhost:3306/factory_db',
    port: 8081,
    userName: 'user',
    password: 'factory',
    databaseName: 'factory_db',
    );

    await conn.connect();

    print("Connected");

    await conn.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'name',
              ),
            ],
          )
        ),
      ),
    );
  }
}