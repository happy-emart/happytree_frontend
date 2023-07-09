import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'crud_service.dart' as crud;
import 'post.dart';

// Future<void> main() async {
//   // final settings = ConnectionSettings(
//   //   host: 'localhost',
//   //   port: 3306,
//   //   user: 'user',
//   //   password: 'factory',
//   //   db: 'factory_db',
//   // );

//   // final conn = await MySqlConnection.connect(settings);

//   // final result = await conn.query('SELECT * FROM post');
//   // for (var row in result) {
//   //   print(row.fields);
//   // }
//   // dbConnector();
//   final response = await fetchPost();
//   print(response.body);
//   // final response = await testHttpPost();
//   // print(response.body);

//   runApp(const MyApp());
// }

void main() => runApp(LocalApp());

class LocalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Our Happy Tree",
      home: TabBarDemo(),
    );
  }
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});
  // List<Widget> buildImageStack(int numOfPost) {
  //   return List.generate(numOfPost, (_) {
  //     return Image.asset('assets/images/apple.png');
  //   });
  // }
  // List<Widget> buildImageStackDemo(int numOfPost) {
  //   return List.generate(numOfPost, (_) {
  //     return Image.asset('assets/images/apple.png');
  //   });
  // }
  // var last = [()]  

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
    double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기

    // double cntrHeight = deviceHeight/2;
    double cntrWidth = deviceWidth/1;
    return MaterialApp(
      /**
       * Tab 사용법
       * 스크린을 TabController 위젯으로 구성함
       * TabBar: 사용할 탭을 구성. appBar의 bottom으로 구현
       * TabBarView: 탭이 선택될 시 디스플레이할 컨텐트 구성. body로 구현
       */
      home: DefaultTabController(
        // 탭의 수 설정
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Tabs Demo'),
            // TabBar 구현. 각 컨텐트를 호출할 탭들을 등록
            bottom: TabBar(
              tabs: [
                Tab(text: "나의 나무",),
                Tab(text: "너의 나무",),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
          body: TabBarView(
            children: [
              buildTree(cntrWidth, cntrWidth, context),
              Stack(
                children:[
                buildTree(cntrWidth, cntrWidth, context),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: deviceHeight/30,
                  child: Transform.scale(
                    scale: 0.5,
                    child: InkWell( 
                      // splashRadius: 50,
                      child: Container(
                        child: Image.asset(
                          "assets/images/writeimg.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      onTap: () {
                        print("이 버튼은 절대 누르지 마세요.");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LetterScreen()),
                        );
                      },
                    ),
                  ),
                ),
                ],
              ),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }

  Stack buildTree(double cntrHeight, double cntrWidth, BuildContext context) {
    return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/tree.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          height: cntrWidth,
                          width: cntrWidth,
                        ),
                      ]
                    ),
                  ],
                ),
                createFruit(context ,200, 270, 1),
                createFruit(context, 300, 100, 2),
                createFruit(context, 400, 200, 3),
                createFruit(context, 320, 300, 4),
                ],
                // buildImageStack(5),
            );
  }

  Container createFruit(BuildContext context, double x, double y, int id) {
    return Container(
            child: Positioned(
              top: x,
              right: y,
              child: Container(
                child:
                  IconButton( 
                    splashRadius: 50,
                    icon: Transform.scale(
                      scale: 3.5,
                      child: Image.asset(
                        "assets/images/apple.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    iconSize: 30,
                    onPressed: () {
                      print("사과를 누르지 마세요.");
                      FlutterDialog(context, id);
                    },
                  ),
              ),
            ),
          );
  }

  void FlutterDialog(BuildContext context, int id) {
    double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
    double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("편지의 제목"),
              ],
            ),
            // title: Text("편지"),
            //
            content: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      '$id번째 사과를 눌렀더니 플러터를 사용해서 어플리케이션을 제작하는 영욱이가 긴 글을 그래도 겉보기에 괜찮아 보이도록 만드려는 노력 끝에 이런 의미 없는 문장들을 나열하기로 결정했어요. 이 문장은 여러분, 대단하게도 아무 의미가 없습니다. 그저 긴 글을 어느 정도의 수준으로 보여줄 지가 궁금했을 뿐입니다. 그런데 생각보다 쓸모가 없더라도 긴 글을 타이핑 하는 것은 쉬운 일이 아니군요. 저는 여태까지 많은 이들에게 편지를 써 왔는데요, 그 편지를 받는 이들은 같은 내용을 카카오톡을 통해 전달 받더라도 분명히 감사해야 합니다. 그렇게 쓰는 것도 분명 쉬운 일이 아니기 때문이죠. 저희 조는 수지 덕분에 꽤나 많은 정보를 갖고 시작했습니다. 수지는 엄청나게 많은 것을 알고 있습니다. 머릿속이 마치 도라에몽의 주머니 같달까요. 이럴 땐 그 결과를 부러워하기 보다는, 그가 그런 결과를 이뤄내기 위해 얼마나 많은 노력을 했을지에 대해 생각하며 스스로를 돌아봐야 합니다. 이 문장은 여러분, 대단하게도 아무 의미가 없습니다. 그저 긴 글을 어느 정도의 수준으로 보여줄 지가 궁금했을 뿐입니다. 그런데 생각보다 쓸모가 없더라도 긴 글을 타이핑 하는 것은 쉬운 일이 아니군요. 저는 여태까지 많은 이들에게 편지를 써 왔는데요, 그 편지를 받는 이들은 같은 내용을 카카오톡을 통해 전달 받더라도 분명히 감사해야 합니다. 그렇게 쓰는 것도 분명 쉬운 일이 아니기 때문이죠. 저희 조는 수지 덕분에 꽤나 많은 정보를 갖고 시작했습니다. 수지는 엄청나게 많은 것을 알고 있습니다. 머릿속이 마치 도라에몽의 주머니 같달까요. 이럴 땐 그 결과를 부러워하기 보다는, 그가 그런 결과를 이뤄내기 위해 얼마나 많은 노력을 했을지에 대해 생각하며 스스로를 돌아봐야 합니다.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    // getLetterById.getContents(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  // alignment: Alignme
                  child: new Text("잘 읽었어요"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }
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

  // Results? result;
  // int id = 1;

  // if (queryState == 'selectAll') {
  //   result = await conn.query("SELECT * FROM post");
  // } else if (queryState == 'select') {
  //   result = await conn.query(
  //       "SELECT * FROM post where id", [id]);
  // }

  // if (result != null) {
  //   for (var row in result) {
  //     print(row.fields);
  //   }
  // }

  Results? result = await crud.CrudService(conn: conn, tableName: "post").getDataList();
  // Results? result = await crud.CrudService(conn: conn, tableName: "post").findById(2);
  // Results? result = await crud.CrudService(conn: conn, tableName: "post").create(Post(id: 1 ,statement: "isitworkflutter", thanks: "happy", writer: "me"));
  // Results? result = await crud.CrudService(conn: conn, tableName: "post").update(Post(id: 1 ,statement: "changeyourstate!", thanks: "happy", writer: "me"));
  // Results? result = await crud.CrudService(conn: conn, tableName: "post").delete(6);

  print(result);

  await conn.close();
}

Future<http.Response> fetchPost() async {
  return http.get(Uri.parse("http://localhost:8081"));
}

// Future<http.Response> testHttpPost() async {
//   Post requestBody = Post.fromJson(json);
//   return http.post(Uri.parse("http://localhost:8081"), body: requestBody.toJson());
// }