// import 'package:http/http.dart' as http;
// part 'post.dart';


// class PostService {
//   Future<List<Post>> getPostList() async {
//     final response = await http.get(Uri.parse('http://localhost:8081'));
    
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = jsonDecode(response.body);
//       return responseData.map((json) => Post.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch post list');
//     }
//   }

//   // 나머지 메서드들도 구현해야 함
// }
