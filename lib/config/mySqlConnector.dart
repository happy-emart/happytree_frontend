// /* mySqlConnector.dart */
// import 'package:mysql_client/mysql_client.dart';
// import 'package:flutter_memo_app/config/dbInfo.dart';

// // MySQL 접속
// Future<MySQLConnection> dbConnector() async {
//   print("Connecting to mysql server...");

//   // MySQL 접속 설정
//   final conn = await MySQLConnection.createConnection(
//     host: DbInfo.hostName,
//     port: DbInfo.portNumber,
//     userName: DbInfo.userName,
//     password: DbInfo.password,
//     databaseName: DbInfo.dbName, // optional
//   );

//   await conn.connect();

//   print("Connected");

//   return conn;
// }