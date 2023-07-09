import 'package:mysql1/mysql1.dart';
import 'post.dart';

class CrudService {
  MySqlConnection conn;
  String tableName;

  CrudService({required this.conn, required this.tableName});

  Future<Results> getDataList() async {
    Results result = await conn.query("SELECT * FROM $tableName");
    return result;
  }

  Future<Results> findById(int id) async {
    Results result = await conn.query("SELECT * FROM $tableName WHERE id = $id");
    return result;
  }

  Future<Results> create(Post post) async {
    Results result = await conn.query("INSERT INTO $tableName (id, statement, thanks, writer) VALUES (?, ?, ?, ?)",
    [post.id, post.statement, post.thanks, post.writer],
  );
    return result;
  }

  Future<Results> update(Post post) async {
    Results result = await conn.query("UPDATE $tableName SET statement = ?, thanks = ?, writer = ? WHERE id = ?",
    [post.statement, post.thanks, post.writer, post.id]);
    return result;
  }

  Future<Results> delete(int id) async {
    Results result = await conn.query("DELETE FROM $tableName WHERE id = $id");
    return result;
  }  
}