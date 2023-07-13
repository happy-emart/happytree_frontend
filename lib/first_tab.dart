import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:flutter_application_1/writing_papaer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
// import 'package:smartrefresh/smartrefresh.dart';

String backgroundImagePath = 'assets/images/universe5.jpg';
String baseUrl = "http://168.131.151.213:4040";

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<FirstPage> {
  // Refresher
  // final RefreshController _refreshController1 = RefreshController();
  final RefreshController _refreshController1 = RefreshController(initialRefresh: false);
  final RefreshController _refreshController2 = RefreshController(initialRefresh: false);
  final RefreshController _refreshController4 = RefreshController(initialRefresh: false);

  // void refreshData1() async {
  //   setState(() {
  //     hhhhh = buildTreeOfMe();
  //   });
  //   await Future.delayed(Duration(milliseconds: 500)); // Delay for visual effect (optional)
  //   _refreshController1.refreshCompleted();
  // }

  late FutureBuilder<Stack> stackFuture;

  void refreshData1() async {
    var newData = await buildTreeOfMe();
    // Once the new data is ready, update the state.
    setState(() {
      stackFuture = newData;
    });
    await Future.delayed(Duration(milliseconds: 200));
    _refreshController1.refreshCompleted();
  }

  void refreshData2() async {
    setState(() {
      getOthersTreeView();
    });
    _refreshController2.refreshCompleted();
  }

  // void refreshData4() async {
  //   setState(() {
  //     getOthersFarmView();
  //   });
  //   _refreshController4.refreshCompleted();
  // }
  
  double transform_x(double origin) {
    return origin * centerHeight / 768;
  }
  double transform_y(double origin) {
    return origin * deviceWidth / 430;
  }

  late double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  late double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  late double centerWidth = 0.0;
  late double centerHeight = 0.0;
  late double poleHeight = deviceWidth*0.13;
  double imgSize = 48; // 1:1 image

  late final topPoint = (centerHeight - deviceWidth)*0.5; // img size = 48
  late final bottomPoint = topPoint + deviceWidth - poleHeight - imgSize; // img size = 48
  late final startPoint = 0.0;
  late final endPoint = startPoint + deviceWidth - imgSize; // img size = 48
  List<int> fruits = [];
  List<Tuple2<double, double>> pointList = [];

  Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  Future<List<User>> getUsersList() async {
    final request = Uri.parse("$baseUrl/users");
    final jwtToken = await getJwtToken();
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers: headers);
    var json = jsonDecode(response.body);
    List<User> users = [];
    for (var userJson in json) {
      users.add(User.fromJson(userJson));
    }
    return users;
  }

  Future<List<Container>> fetchFruits() async {
    final String Url = "$baseUrl/received_letters";
    final jwtToken = await getJwtToken();
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    try
    {
      final response = await http.get(request, headers: headers);
      var json = jsonDecode(response.body);
      List<Letter> letters = [];
      List<Container> containers = [];
      for (var LetterJson in json) {
        print(LetterJson);
        letters.add(Letter.fromJson(LetterJson));
      }

      for(var fruit in letters) {
        containers.add(createFruit(context, fruit.posX, fruit.posY, fruit.id, fruit.fruitType));
      }
      return containers;
    }
    catch(error)
    {
      print('error : $error');
    }
    return [];
  }

  Future<Tuple2<List<Container>,List<Letter>>> othersFruits(int id) async {
    final String Url = "$baseUrl/received_letters?id=$id";
    var jwtToken = await getJwtToken();
    var request = Uri.parse(Url);
    var headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    try
    {
      var response = await http.get(request, headers: headers);
      List<Letter> letters = [];
      List<Container> containers = [];
      var json = jsonDecode(response.body);
      // print(jsonList); // checking the validity of the letters list
      for (var letterJson in json) {
        letters.add(Letter.fromJson(letterJson));
      }
      for(var fruit in letters) {
        containers.add(createFruit(context, fruit.posX, fruit.posY, fruit.id, fruit.fruitType));
      }
      return Tuple2(containers, letters);
    }
    catch(error)
    {
      print('error : $error');
    }
    return const Tuple2([], []);
  }

  Future<Stack> buildTree(double cntrHeight, double cntrWidth, BuildContext context) async {
    List<Container> fruits = await fetchFruits();
    String userName = await getUserName();
    return Stack(
      children: [
        mars2(),
        settingTree(cntrWidth),
        for(var fruit in fruits)
          fruit,
        Positioned(
          left: 0,
          right: 0,
          top: deviceHeight * 0.68,
          child: Transform.scale(
            scale: 0.72,
            child: Positioned(
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showCustomToast(context, "오늘은 편지가 얼마나 왔을까~");
                    },
                    child: Image.asset(
                      "assets/images/namesign.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "mainfont",
                      fontSize: 60.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 113, 113, 113),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container settingTree(double cntrWidth) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
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
    );
  }

  Positioned moon2() {
    return Positioned(
              top: transform_y(580.0),
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 3.8,
                child: Image.asset(
                  "assets/images/moon2.png",
                ),
              ),
            );
  }

  Positioned moon1() {
    return Positioned(
              top: transform_y(530.0),
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 2.7,
                child: Image.asset(
                  "assets/images/moon1.png",
                ),
              ),
            );
  }

  Positioned mars2() {
    return Positioned(
              top: transform_y(700.0),
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 3.5,
                child: Image.asset(
                  "assets/images/mars2.png",
                ),
              ),
            );
  }

  Positioned mars1() {
    return Positioned(
      top: transform_y(720.0),
      left: 0,
      right: 0,
      child: Transform.scale(
        scale: 2.2,
        child: Image.asset(
          "assets/images/mars1.png",
        ),
      ),
    );
  }

  Future<Stack> buildOthersTree(int id, double cntrHeight, double cntrWidth, BuildContext context) async {
    Tuple2<List<Container>, List<Letter>> fruits = await othersFruits(id);
    return Stack(
      children: [
        moon1(),
        settingTree(cntrWidth),
        for(var fruit in fruits.item1)
          fruit,
      ],
    );
  }


  Future<String> getSenderById(int id) async{
    final String Url = '$baseUrl/user?id=$id';
    final jwtToken = await getJwtToken();
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };
    try {
      final response = await http.get(request, headers: headers);
      return response.body;

    }
    catch(error)
    {
      print('$error');
    }
    return "";
  }

  Future<String> getUserName() async{
    final String Url = "$baseUrl/user";
    final jwtToken = await getJwtToken();
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };
    try {
      final response = await http.get(request, headers: headers);
      return response.body;
    }
    catch(error)
    {
      print('$error');
    }
    return "";
  }

  double auxxxx(double aux) {
    if (aux >= 7) return 5.5;
    else return 3.5;
  }

  Container createFruit(BuildContext context, double x, double y, int id, int fruitType) {
    return Container(
      child: Positioned(
        top: x,
        right: y,
        child: Container(
          child:
          IconButton(
            icon: Transform.scale(
              scale: auxxxx(fruitType.toDouble()),
              child: Image.asset(
                getFruitImageRoute(fruitType),
                fit: BoxFit.cover,
              ),
            ),
            iconSize: 30,
            onPressed: () {
              FlutterDialog(context, id);
            },
          ),
        ),
      ),
    );
  }

  String getAmongImageRoute(int fruitType) {
    switch (fruitType) {
      case 0:
        return "assets/images/among1.png";
      case 1:
        return "assets/images/among2.png";
      case 2:
        return "assets/images/among3.png";
      case 3:
        return "assets/images/among4.png";
      case 4:
        return "assets/images/among5.png";
      case 5:
        return "assets/images/among6.png";
      case 6:
        return "assets/images/among7.png";
      case 7:
        return "assets/images/among8.png";
      case 8:
        return "assets/images/among9.png";
    }
    return "assets/images/apple.png";
  }

  String getPlanImageRoute(int fruitType)
  {
    switch(fruitType)
    {
      case 0:
        return "assets/images/plan1.png";
      case 1:
        return "assets/images/plan2.png";
      case 2:
        return "assets/images/plan3.png";
      case 3:
        return "assets/images/plan4.png";
      case 4:
        return "assets/images/plan5.png";
      case 5:
        return "assets/images/plan6.png";
      case 6:
        return "assets/images/plan7.png";
      case 7:
        return "assets/images/plan8.png";
    }
    return "assets/images/apple.png";
  }

  String getFruitImageRoute(int fruitType) {
    switch (fruitType) {
      case 0:
        return "assets/images/apple.png";
      case 1:
        return "assets/images/grape.png";
      case 2:
        return "assets/images/kiwi.png";
      case 3:
        return "assets/images/plan9.png";
      case 4:
        return "assets/images/melon.png";
      case 5:
        return "assets/images/orange.png";
      case 6:
        return "assets/images/peach.png";
    }
    return "assets/images/apple.png";
  }
  
  String formatKoreanDate(List<dynamic> date) {
    if (date.length < 3) {
      return ''; // Handle invalid date input
    }
    
    final year = date[0];
    final month = date[1];
    final day = date[2];
    
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(DateTime(year, month, day));
    return formattedDate;
  }

  void FlutterDialog(BuildContext context, int id) async {
    try
    {
      var Url = "$baseUrl/letter?id=$id";
      var jwtToken = await getJwtToken();
      var request = Uri.parse(Url);
      var headers = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken'
      };

      var response = await http.get(request, headers: headers);
      Map<String, dynamic> data = jsonDecode(response.body);
      String text = data['text'];
      int senderId = data['senderId'];
      String date = formatKoreanDate(data['generatedDate']);
      String username = await getSenderById(senderId);
      var title = '쓰니: $username';

      if(response.statusCode==200)
      {
        print(response.body);
        return showDialog(
            context: context,
            //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
            // barrierDismissible: false,
            builder: (BuildContext context) {
              return FractionallySizedBox(
      widthFactor: 0.9, // Set to your desired width factor (0.9 is 90% of screen width)
      child: Dialog(
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0)),
  child: Container(
    width: MediaQuery.of(context).size.width * 0.8,  // Set width as per your need
    padding: EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,  // Set this
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                '쓰니: $username',
                style: TextStyle(
                  fontFamily: "mainfont",
                  fontSize: 25,
                ),
              ),
              Text(
                "작성일: $date",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: "mainfont",
                  fontSize: 17,
                ),
              ),
              Text(""),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16.0),
                ),
                // getLetterById.getContents(),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
)
              );
            }
        );
      }
      else
      {
        throw const HttpException("You cannot access to letter");
      }
    }
    catch(error)
    {
      print('error : $error');
    }

  }

  Future<void> PaperDialog(BuildContext context, int id) async {
    try
    {
      var Url = "$baseUrl/paper?id=$id";
      var jwtToken = await getJwtToken();
      var request = Uri.parse(Url);
      var headers = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken'
      };

      var response = await http.get(request, headers: headers);
      Map<String, dynamic> data = jsonDecode(response.body);
      String text = data['text'];
      int senderId = data['senderId'];
      String username = await getSenderById(senderId);
      var title = '쓰니: $username';

      if(response.statusCode==200)
      {
        print(response.body);
        return showDialog(
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
                    Text('쓰니: $username'),
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
                          text,
                          style: const TextStyle(fontSize: 16.0),
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
                      child: const Text("잘 읽었어요"),
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
      else
      {
        throw const HttpException("You cannot access to letter");
      }
    }
    catch(error)
    {
      print('error : $error');
    }

  }

    Future<List<Farm>> getFarmList() async {
      final request = Uri.parse("$baseUrl/farm_list");
      final jwtToken = await getJwtToken();
      final headers = <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken'
      };

      var response = await http.get(request, headers: headers);
      var json = jsonDecode(response.body);
      List<Farm> farms = [];
      for (var farmJson in json) {
        farms.add(Farm.fromJson(farmJson));
      }
      return farms;
    }

    Future<List<Paper>> getPageList(int id) async {
    final request = Uri.parse("$baseUrl/get_paper_of_farm?id=$id");
    final jwtToken = await getJwtToken();
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };

    var response = await http.get(request, headers: headers);
    var json = jsonDecode(response.body);
    print(response.body);
    List<Paper> papers = [];
    for (var paperJson in json) {
      papers.add(Paper.fromJson(paperJson));
    }
    return papers;
  }



  void navigateToPaperScreen(BuildContext context, int id, List<Paper> papers) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaperScreen(
          argument: Tuple4(deviceWidth, deviceHeight, centerHeight, imgSize),
          receiverId: id,
          papers: papers,
        ),
      ),
    );
  }

  void getOthersPaperView(BuildContext context, int id) async {
    List<Paper> papers = await getPageList(id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Material(
          child: FutureBuilder<List<Paper>>(
            future: Future.value(papers),
            builder: (BuildContext context, AsyncSnapshot<List<Paper>> snapshot) {
              if (snapshot.hasData) {
                List<Paper> papers = snapshot.data!;
                List<List<Paper>> paperChunks = splitListIntoChunks(papers, 3);
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImagePath)
                      ),
                  ),
                  child: SingleChildScrollView(
                    child: AnimationLimiter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, deviceHeight * 0.07, 0, 0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateToPaperScreen(context, id, papers);
                              },
                              child: Material(
                                        type: MaterialType.transparency, // it can be changed according to your needs
                                        child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          navigateToPaperScreen(context, id, papers);
                        },
                                        ),
                                      ),
                            ),
                            ...paperChunks.map((paperChunk) {
                              return Row(
                                children: paperChunk.map((paper) {
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await PaperDialog(context, paper.id);
                                      },
                                      child: ImagePaperThumbnail(
                                        image: getFruitImageRoute(Random().nextInt(7)),
                                        id: paper.id,
                                        func: () async{
                                          await PaperDialog(context, paper.id);
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Farm>> getOthersFarmView() {
    Random random = Random();
    return FutureBuilder<List<Farm>>(
      future: getFarmList(),
      builder: (BuildContext context, AsyncSnapshot<List<Farm>> snapshot) {
        if (snapshot.hasData) {
          List<Farm> farms = snapshot.data!;
          List<List<Farm>> farmChunks = splitListIntoChunks(farms, 2);
          return SingleChildScrollView(
            child: AnimationLimiter(
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 100.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: farmChunks.map((farmChunk) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(40, 50, 0, 100),
                      child: Row(
                        children: farmChunk.map((farm) {
                          return Expanded(
                            child: ImagePlanThumbnail(
                              image: getPlanImageRoute(random.nextInt(8)),
                              name: farm.name,
                              id: farm.id,
                              func: () => getOthersPaperView(context, farm.id),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);


  late final List<Widget> _widgetOptions = <Widget>[
    buildTreeOfMe(),
    getOthersTreeView(),
    getOthersFarmView(),
  ];

  FutureBuilder<List<User>> getOthersTreeView() {
    return FutureBuilder<List<User>>(
      future: getUsersList(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          List<List<User>> userChunks = splitListIntoChunks(users, 3);
          return SmartRefresher(
            enablePullDown: true,
            header: const WaterDropHeader(),
            controller: _refreshController2,
            onRefresh: refreshData2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 300),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 100.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: userChunks.map((userChunk) {
                        return Row(
                          children: userChunk.map((user) {
                            return Expanded(
                              child: ImageThumbnail(
                                image: getAmongImageRoute(Random().nextInt(9)),
                                name: user.username,
                                id: user.id,
                                func: () => openOthersTreePage(context, user.id),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }


  void openOthersTreePage(BuildContext context, int othersId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final RefreshController refreshController3 = RefreshController(initialRefresh: false);
          void refreshData3() async {
            setState(() {
            });
            refreshController3.refreshCompleted();
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(0, deviceHeight*0.07, 0, deviceHeight*0.1),
            child: SmartRefresher(
              enablePullDown: true,
              header: const WaterDropHeader(),
              controller: refreshController3,
              onRefresh: refreshData3,
              child: Stack(
                children: [
                  Image.asset(
                    backgroundImagePath,
                    height: deviceHeight,
                    width: deviceWidth,
                    fit: BoxFit.cover,
                  ),
                  Scaffold(
                    backgroundColor: Colors.transparent,
                    body: buildOthersTreePage(othersId),
                  )
                ],
              ),
            ),
          );
        }
      )
    );
  }

  Stack buildOthersTreePage(int othersId) {
    return Stack(
      children: [
        buildTreeById(othersId),
        Positioned(
          left: 0,
          right: 0,
          top: transform_y(deviceHeight * 0.61),
          child: Transform.scale(
            scale: 0.5,
            child: FutureBuilder<Tuple2<List<Container>,List<Letter>>>(
              future: othersFruits(othersId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Do something with your error
                    return const Text('Error occurred');
                  }
                  // Your future has completed. Extract the data you need from the snapshot
                  List<Letter> letters = snapshot.data?.item2 ?? [];
                  return InkWell(
                    child: Image.asset(
                      "assets/images/writeimg.png",
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LetterScreen(argument: Tuple4(deviceWidth, deviceHeight, centerHeight, imgSize), receiverId: othersId, letters: letters)),
                      );
                    },
                  );
                } else {
                  // Your future is still loading
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ],
    );
  }


  FutureBuilder<Stack> buildTreeOfMe() {
    return FutureBuilder<Stack>(
      future: buildTree(centerWidth, centerWidth, context),
      builder: (BuildContext context, AsyncSnapshot<Stack> snapshot) {
        if (snapshot.hasData) {
          return SmartRefresher(
            enablePullDown: true,
            header: const WaterDropHeader(),
            controller: _refreshController1,
            onRefresh: refreshData1,
            child: snapshot.data!,
          );
          // return PullToRefresh(
          //   onRefresh: _handleRefresh,
          //   showChildOpacityTransition: false,
          //   backgroundColor: Colors.transparent,
          //   tColor: Colors.grey,
          //   onFail: failedIndicator(),
          //   onComplete: completeindicator(),
          //   onLoading: loadingindicator(),
          //   refreshController: _refreshController,
          //   child: StreamBuilder<int>(
          //     stream: counterStream,
          //   );
      } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<Stack> buildTreeById(int id) {
    return FutureBuilder<Stack>(
      future: buildOthersTree(id, centerWidth, centerWidth, context),
      builder: (BuildContext context, AsyncSnapshot<Stack> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          Image.asset(
            backgroundImagePath,
            height: deviceHeight,
            width: deviceWidth,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: EdgeInsets.fromLTRB(0, deviceHeight*0.07, 0, 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  centerHeight = constraints.maxHeight;
                  centerWidth = constraints.maxWidth;
                  return Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        // Change the transition according to your needs
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _widgetOptions.elementAt(_selectedIndex),
                    ),
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
                    rippleColor: const Color.fromARGB(255, 0, 0, 0),
                    hoverColor: const Color.fromARGB(255, 96, 69, 69),
                    gap: 8,
                    activeColor: const Color.fromARGB(255, 0, 0, 0),
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.grey[100]!,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    tabs: const [
                      GButton(
                        icon: LineIcons.tree,
                        text: 'My Tree',
                      ),
                      GButton(
                        icon: LineIcons.heart,
                        text: 'Our Tree',
                      ),
                      GButton(
                        icon: LineIcons.comment,
                        text: 'Rolling Paper',
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
    MaterialPageRoute(builder: (context) => const FirstPage()),
  );
}


class ImagePlanThumbnail extends StatelessWidget {
  const ImagePlanThumbnail({Key? key, required this.image, required this.name, required this.id, required this.func,})
      : super(key: key);
  final String image;
  final String name;
  final int id;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          margin: const EdgeInsets.only(bottom: 6),
          // decoration: BoxDecoration(
          //   image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
          //   borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: IconButton(
            icon: Transform.scale(
              scale: 5,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            iconSize: 30,
            onPressed: () {
              func();
            },
          ),
        ),
        Container(
            color: Colors.black87,
            // alignment: Alignment.center,
            child:
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
        const SizedBox(height: 20)
      ],
    );
  }
}

class ImagePaperThumbnail extends StatelessWidget {
  const ImagePaperThumbnail({Key? key, required this.image, required this.id, required this.func,})
      : super(key: key);
  final String image;
  final int id;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          margin: const EdgeInsets.only(bottom: 6),
          // decoration: BoxDecoration(
          //   image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
          //   borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: IconButton(
            icon: Transform.scale(
              scale: 2,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            iconSize: 30,
            onPressed: () {
              func();
            },
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}

class ImageThumbnail extends StatelessWidget {
  const ImageThumbnail({Key? key, required this.image, required this.name, required this.id, required this.func,})
      : super(key: key);
  final String image;
  final String name;
  final int id;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          margin: const EdgeInsets.only(bottom: 6),
          // decoration: BoxDecoration(
          //   image: DecorationImage(fit: BoxFit.fill, image: AssetImage(image)),
          //   borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: IconButton(
            icon: Transform.scale(
              scale: 3,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            iconSize: 30,
            onPressed: () {
              func();
            },
          ),
        ),
        Container(
            color: Colors.black87,
            // alignment: Alignment.center,
            child:
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white))),
        const SizedBox(height: 20)
      ],
    );
  }
}

class User {
  final int id;
  final String email;
  final String password;
  final String username;

  User({required this.id, required this.email, required this.password, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
    );
  }
}

class Letter {
  final int id;
  final int senderId;
  final int receivedId;
  final String text;
  final double posX;
  final double posY;
  final int fruitType;

  Letter({required this.id, required this.senderId, required this.receivedId, required this.text,
    required this.posX, required this.posY, required this.fruitType});

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
        id: json['id'],
        receivedId: json['receiverId'],
        senderId: json['senderId'],
        text: json['text'],
        posX: json['posX'].toDouble(),
        posY: json['posY'].toDouble(),
        fruitType: json['imgType']
    );
  }
}

class Farm {
  final int id;
  final String name;

  Farm({required this.id, required this.name});

  factory Farm.fromJson(Map<String, dynamic> json) {
    return Farm(
        id: json['id'],
        name: json['name'],
    );
  }
}

class Paper {
  final int id;
  final int farmId;
  final String text;
  final int senderId;

  Paper({required this.id, required this.farmId, required this.text, required this.senderId});

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'],
      text: json['text'],
      farmId: json['farmId'],
      senderId: json['senderId']
    );
  }
}

List<List<T>> splitListIntoChunks<T>(List<T> list, int chunkSize) {
  List<List<T>> chunks = [];
  for (var i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
  }
  return chunks;
}

void showCustomToast(BuildContext context, String message) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.removeCurrentSnackBar();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'mainfont',
          fontSize: 22.0,
          color: Colors.white,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: const Color.fromARGB(255, 94, 94, 94),
    ),
  );
}