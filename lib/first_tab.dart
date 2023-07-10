import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'dart:io';
import 'package:mysql1/mysql1.dart';
import 'package:tuple/tuple.dart';
import 'crud_service.dart' as crud;
import 'post.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

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

// void main() => runApp(LocalApp());

// class LocalApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: "Our Happy Tree",
//       home: TabBarDemo(),
//     );
//   }
// }


void main() => runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    title: 'GNav',
    theme: ThemeData(
      primaryColor: Colors.grey[800],
    ),
    home: FirstPage()));

class FirstPage extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<FirstPage> {
  late double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  late double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  late double centerHeight;
  late double centerWidth;
  late double poleHeight = deviceWidth*0.13;
  double imgSize = 48; // 1:1 image
  late final topPoint = (centerHeight - deviceWidth)*0.5 - imgSize; // img size = 48
  late final bottomPoint = topPoint + deviceWidth - poleHeight + imgSize; // img size = 48
  late final startPoint = 0;
  late final endPoint = startPoint + deviceWidth - imgSize; // img size = 48

  Stack buildTree(double cntrHeight, double cntrWidth, BuildContext context) {
    // List<Tuple2<double, double>> pointList = [];
    // while (pointList.length < 5) {
    //   var pntX = 0.0, pntY = 0.0;
    //   if (
    //     (math.pow(pntX-(centerWidth-imgSize)*0.5, 2) + math.pow(pntY-(centerWidth-imgSize-poleHeight)*0.5, 2))<=math.pow((centerWidth-poleHeight)*0.5, 2)
    //     ) { pointList.add(Tuple2(pntX, pntY)); }
    // }

    return Stack(
            children: [
              Container(
                child: Column(
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
              ),
              // createFruit(context , topPoint+math.Random().nextDouble()*(bottomPoint-topPoint), startPoint+math.Random().nextDouble()*(endPoint-startPoint), 2),
              // createFruit(context , topPoint+math.Random().nextDouble()*(bottomPoint-topPoint), startPoint+math.Random().nextDouble()*(endPoint-startPoint), 3),
              // createFruit(context , topPoint+math.Random().nextDouble()*(bottomPoint-topPoint), startPoint+math.Random().nextDouble()*(endPoint-startPoint), 4),

              // buildImageStack(5),
            ],
          );
  }

  Container createFruit(BuildContext context, double x, double y, int id) {
    print("top: $x, right: $y");
    return Container(
            child: Positioned(
              top: x,
              right: y,
              child: Container(
                child:
                  IconButton( 
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
        }
      );
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  late List<Widget> _widgetOptions = <Widget>[
    buildTree(centerWidth, centerWidth, context),
    Stack(
      children:[
      buildTree(centerWidth, centerWidth, context),
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
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Image.asset(
          "assets/images/universe2.png",
          height: deviceHeight,
          width: deviceWidth,
          fit: BoxFit.cover,
        ),
        Scaffold(
        backgroundColor: Colors.transparent,
        // back
        // appBar: AppBar(
        //   elevation: 20,
        //   title: const Text('GoogleNavBar'),
        // ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, deviceHeight*0.07, 0, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              centerHeight = constraints.maxHeight;
              centerWidth = constraints.maxWidth;
              print("deviceHeight: $deviceHeight, deviceWidth: $deviceWidth, centerHeight: $centerHeight, centerWidth: $centerWidth");

              return Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: const Color.fromARGB(255, 0, 0, 0)!,
                hoverColor: const Color.fromARGB(255, 96, 69, 69)!,
                gap: 8,
                activeColor: Color.fromARGB(255, 0, 0, 0),
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: const Color.fromARGB(255, 255, 255, 255),
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.heart,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),]
    );
  }
}

void startFirstPage(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => FirstPage()),
  );
}

// class FirstTab extends StatelessWidget {
//   const FirstTab({super.key});
//   // List<Widget> buildImageStack(int numOfPost) {
//   //   return List.generate(numOfPost, (_) {
//   //     return Image.asset('assets/images/apple.png');
//   //   });
//   // }
//   // List<Widget> buildImageStackDemo(int numOfPost) {
//   //   return List.generate(numOfPost, (_) {
//   //     return Image.asset('assets/images/apple.png');
//   //   });
//   // }
//   // var last = [()]  
//   int _selectedIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
//     double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기

//     // double cntrHeight = deviceHeight/2;
//     double cntrWidth = deviceWidth/1;
//     return MaterialApp(
//       /**
//        * Tab 사용법
//        * 스크린을 TabController 위젯으로 구성함
//        * TabBar: 사용할 탭을 구성. appBar의 bottom으로 구현
//        * TabBarView: 탭이 선택될 시 디스플레이할 컨텐트 구성. body로 구현
//        */
//       home: DefaultTabController(
//         // 탭의 수 설정
//         length: 3,
//         child: Scaffold(
//           bottomNavigationBar: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 20,
//                   color: Colors.black.withOpacity(.1),
//                 )
//               ],
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
//                 child: GNav(
//                   rippleColor: Colors.grey[300]!,
//                   hoverColor: Colors.grey[100]!,
//                   gap: 8,
//                   activeColor: Colors.black,
//                   iconSize: 24,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   duration: Duration(milliseconds: 400),
//                   tabBackgroundColor: Colors.grey[100]!,
//                   color: Colors.black,
//                   tabs: [
//                     GButton(
//                       icon: LineIcons.home,
//                       text: 'Home',
//                     ),
//                     GButton(
//                       icon: LineIcons.heart,
//                       text: 'Likes',
//                     ),
//                     GButton(
//                       icon: LineIcons.search,
//                       text: 'Search',
//                     ),
//                     GButton(
//                       icon: LineIcons.user,
//                       text: 'Profile',
//                     ),
//                   ],
//                   selectedIndex: _selectedIndex,
//                   onTabChange: (index) {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ),
//           // appBar: AppBar(
//           //   title: Row(
//           //     children: [
//           //       Text("fdsaf"), // Title widget
//           //       SizedBox(width: 16.0), // Optional spacing between title and TabBar
//           //     ],
//           //   ),
//           //   // TabBar 구현. 각 컨텐트를 호출할 탭들을 등록
//           //   flexibleSpace: TabBar(
//           //     tabs: [
//           //       Tab(text: "나의 나무",),
//           //       Tab(text: "너의 나무",),
//           //       Tab(icon: Icon(Icons.directions_bike)),
//           //     ],
//           //   ),
//           // ),
//           // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
//           body: TabBarView(
//             children: [
//               buildTree(cntrWidth, cntrWidth, context),
              // Stack(
              //   children:[
              //   buildTree(cntrWidth, cntrWidth, context),
              //   Positioned(
              //     left: 0,
              //     right: 0,
              //     bottom: deviceHeight/30,
              //     child: Transform.scale(
              //       scale: 0.5,
              //       child: InkWell( 
              //         // splashRadius: 50,
              //         child: Container(
              //           child: Image.asset(
              //             "assets/images/writeimg.png",
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //         onTap: () {
              //           print("이 버튼은 절대 누르지 마세요.");
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => const LetterScreen()),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              //   ],
              // ),
//               Icon(Icons.directions_bike),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   }

//   Container createFruit(BuildContext context, double x, double y, int id) {
//     return Container(
//             child: Positioned(
//               top: x,
//               right: y,
//               child: Container(
//                 child:
//                   IconButton( 
//                     icon: Transform.scale(
//                       scale: 3.5,
//                       child: Image.asset(
//                         "assets/images/apple.png",
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     iconSize: 30,
//                     onPressed: () {
//                       print("사과를 누르지 마세요.");
//                       FlutterDialog(context, id);
//                     },
//                   ),
//               ),
//             ),
//           );
//   }

  // void FlutterDialog(BuildContext context, int id) {
  //   double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  //   double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  //   showDialog(
  //       context: context,
  //       //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0)),
  //           //Dialog Main Title
  //           title: Column(
  //             children: <Widget>[
  //               new Text("편지의 제목"),
  //             ],
  //           ),
  //           // title: Text("편지"),
  //           //
  //           content: Container(
  //             alignment: Alignment.center,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: <Widget>[
  //                   Text(
  //                     '$id번째 사과를 눌렀더니 플러터를 사용해서 어플리케이션을 제작하는 영욱이가 긴 글을 그래도 겉보기에 괜찮아 보이도록 만드려는 노력 끝에 이런 의미 없는 문장들을 나열하기로 결정했어요. 이 문장은 여러분, 대단하게도 아무 의미가 없습니다. 그저 긴 글을 어느 정도의 수준으로 보여줄 지가 궁금했을 뿐입니다. 그런데 생각보다 쓸모가 없더라도 긴 글을 타이핑 하는 것은 쉬운 일이 아니군요. 저는 여태까지 많은 이들에게 편지를 써 왔는데요, 그 편지를 받는 이들은 같은 내용을 카카오톡을 통해 전달 받더라도 분명히 감사해야 합니다. 그렇게 쓰는 것도 분명 쉬운 일이 아니기 때문이죠. 저희 조는 수지 덕분에 꽤나 많은 정보를 갖고 시작했습니다. 수지는 엄청나게 많은 것을 알고 있습니다. 머릿속이 마치 도라에몽의 주머니 같달까요. 이럴 땐 그 결과를 부러워하기 보다는, 그가 그런 결과를 이뤄내기 위해 얼마나 많은 노력을 했을지에 대해 생각하며 스스로를 돌아봐야 합니다. 이 문장은 여러분, 대단하게도 아무 의미가 없습니다. 그저 긴 글을 어느 정도의 수준으로 보여줄 지가 궁금했을 뿐입니다. 그런데 생각보다 쓸모가 없더라도 긴 글을 타이핑 하는 것은 쉬운 일이 아니군요. 저는 여태까지 많은 이들에게 편지를 써 왔는데요, 그 편지를 받는 이들은 같은 내용을 카카오톡을 통해 전달 받더라도 분명히 감사해야 합니다. 그렇게 쓰는 것도 분명 쉬운 일이 아니기 때문이죠. 저희 조는 수지 덕분에 꽤나 많은 정보를 갖고 시작했습니다. 수지는 엄청나게 많은 것을 알고 있습니다. 머릿속이 마치 도라에몽의 주머니 같달까요. 이럴 땐 그 결과를 부러워하기 보다는, 그가 그런 결과를 이뤄내기 위해 얼마나 많은 노력을 했을지에 대해 생각하며 스스로를 돌아봐야 합니다.',
  //                     style: TextStyle(fontSize: 16.0),
  //                   ),
  //                   // getLetterById.getContents(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             Align(
  //               alignment: Alignment.center,
  //               child: TextButton(
  //                 // alignment: Alignme
  //                 child: new Text("잘 읽었어요"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         ),
//         body: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'name',
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }

// Future<void> dbConnector() async {
//   print("Connecting to mysql server ...");

//   final settings = ConnectionSettings(
//     host: 'localhost',
//     port: 3306,
//     user: 'user',
//     password: 'factory',
//     db: 'factory_db',
//   );

//   final conn = await MySqlConnection.connect(settings);

//   print("Connected");

//   // Results? result;
//   // int id = 1;

//   // if (queryState == 'selectAll') {
//   //   result = await conn.query("SELECT * FROM post");
//   // } else if (queryState == 'select') {
//   //   result = await conn.query(
//   //       "SELECT * FROM post where id", [id]);
//   // }

//   // if (result != null) {
//   //   for (var row in result) {
//   //     print(row.fields);
//   //   }
//   // }

//   Results? result = await crud.CrudService(conn: conn, tableName: "post").getDataList();
//   // Results? result = await crud.CrudService(conn: conn, tableName: "post").findById(2);
//   // Results? result = await crud.CrudService(conn: conn, tableName: "post").create(Post(id: 1 ,statement: "isitworkflutter", thanks: "happy", writer: "me"));
//   // Results? result = await crud.CrudService(conn: conn, tableName: "post").update(Post(id: 1 ,statement: "changeyourstate!", thanks: "happy", writer: "me"));
//   // Results? result = await crud.CrudService(conn: conn, tableName: "post").delete(6);

//   print(result);

//   await conn.close();
// }

// Future<http.Response> fetchPost() async {
//   return http.get(Uri.parse("http://localhost:8081"));
// }

// // Future<http.Response> testHttpPost() async {
// //   Post requestBody = Post.fromJson(json);
// //   return http.post(Uri.parse("http://localhost:8081"), body: requestBody.toJson());
// // }