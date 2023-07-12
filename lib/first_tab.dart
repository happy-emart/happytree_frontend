import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tuple/tuple.dart';
import 'package:fluttertoast/fluttertoast.dart';

String backgroundImagePath = "assets/images/universe5.jpg";
String baseUrl = "http://168.131.151.213:4040";

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<FirstPage> {
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
        containers.add(createFruit(context, fruit.posX, fruit.posY, fruit.id));
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
        containers.add(createFruit(context, fruit.posX, fruit.posY, fruit.id));
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
          bottom: deviceHeight / 23,
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
                      // Fluttertoast.showToast(
                      //   msg: "오늘은 얼마나 편지가 왔을까~",
                      //   toastLength: Toast.LENGTH_SHORT,
                      //   gravity: ToastGravity.TOP,
                      //   backgroundColor: Colors.grey[300],
                      //   textColor: Colors.black,
                      //   fontSize: 16.0,
                      // );
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
              top: 580,
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
              top: 530,
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
              top: 700,
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
      top: 720,
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

  Container createFruit(BuildContext context, double x, double y, int id) {
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
                      FlutterDialog(context, id);
                    },
                  ),
              ),
            ),
          );
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
      String username = await getSenderById(senderId);
      var title = '$username님에게 온 편지';

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
                      Text('$username님에게서 온 편지'),
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


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);


  late final List<Widget> _widgetOptions = <Widget>[
    buildTreeOfMe(),
    getOthersTreeView(),
    const Text("hiiiii"),
  ];

  FutureBuilder<List<User>> getOthersTreeView() {
    return FutureBuilder<List<User>>(
      future: getUsersList(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          List<List<User>> userChunks = splitListIntoChunks(users, 3);
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
                  children: userChunks.map((userChunk) {
                    return Row(
                      children: userChunk.map((user) {
                        return Expanded(
                          child: ImageThumbnail(
                            image: "assets/images/apple.png",
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
          return Stack(
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
          bottom: deviceHeight / 30,
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
          print("first tab emerged");
          return snapshot.data!;
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
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        // Change the transition according to your needs
                        return FadeTransition(child: child, opacity: animation);
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
              scale: 1.5,
              child: Image.asset(
                "assets/images/apple.png",
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
          alignment: Alignment.center,
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
  final int imgType;

  Letter({required this.id, required this.senderId, required this.receivedId, required this.text,
  required this.posX, required this.posY, required this.imgType});

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'],
      receivedId: json['receiverId'],
      senderId: json['senderId'],
      text: json['text'],
      posX: json['posX'].toDouble(),
      posY: json['posY'].toDouble(),
      imgType: json['imgType']
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
        style: TextStyle(
          fontFamily: 'mainfont',
          fontSize: 22.0,
          color: Colors.white,
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Color.fromARGB(255, 94, 94, 94),
    ),
  );
}


