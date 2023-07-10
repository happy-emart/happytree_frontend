import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;
import 'package:tuple/tuple.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<FirstPage> {
  late double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  late double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  late double centerHeight = 0.0;
  late double centerWidth = 0.0;
  late double poleHeight = deviceWidth*0.13;
  double imgSize = 48; // 1:1 image

  late final topPoint = (centerHeight - deviceWidth)*0.5; // img size = 48
  late final bottomPoint = topPoint + deviceWidth - poleHeight - imgSize; // img size = 48
  late final startPoint = 0.0;
  late final endPoint = startPoint + deviceWidth - imgSize; // img size = 48
  List<int> fruits = [];
  List<Container> yeolmae = [];
  List<Tuple2<double, double>> pointList = [];

  Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  bool isNotValidLetterPos(List<String> letters, double x, double y) {
    if ((math.pow(x-(centerWidth-imgSize)*0.5, 2) + math.pow(y-(centerWidth-imgSize-poleHeight)*0.5, 2))>=math.pow((centerWidth-poleHeight)*0.5, 2)) {
      return true;
    }
    return false;
  }

  (double, double) getRandPos(double startPoint, double endPoint, double deviceWidth) {
    return (topPoint + math.Random().nextDouble()*(endPoint-startPoint), startPoint + math.Random().nextDouble()*(endPoint-startPoint));
  }

  Future<List<Container>> fetchFruits() async {
    const String Url = "http://127.0.0.1:8080/received_letters";
    final jwtToken = await getJwtToken();
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };
    try
    {
      final response = await http.get(request, headers: headers);
      List<dynamic> jsonList = jsonDecode(response.body);
      List<int> fruitList = jsonList.cast<int>();
      List<Container> containers = [];

      for(var fruit in fruitList) {

        while(true) {
          var (x, y) = getRandPos(startPoint, endPoint, deviceWidth);
          if (!isNotValidLetterPos([], x, y)) {
            containers.add(createFruit(context, x, y, fruit));
            break;
          }
        }
      }
      return containers;
    }
    catch(error)
    {
      print('error : $error');
    }
    return [];
  }

  Future<Stack> buildTree(double cntrHeight, double cntrWidth, BuildContext context) async {
    List<Container> fruits = await fetchFruits();
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
              ),
              for(var fruit in fruits)
                fruit,
              ],
              // buildImageStack(5),
          );
  }


  Future<String> getSenderById(int id) async{
    final String Url = 'http://127.0.0.1:8080/user?id=$id';
    final jwtToken = await getJwtToken();
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };
    try {
      final response = await http.get(request, headers: headers);
      print(response.body);
      return response.body;

    }
    catch(error)
    {
      print('$error');
    }
    return "";
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
        final String Url = "http://127.0.0.1:8080/letter?id=$id";
        final jwtToken = await getJwtToken();
        final request = Uri.parse(Url);
        final headers = <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        };

        final response = await http.get(request, headers: headers);
        Map<String, dynamic> data = jsonDecode(response.body);
        String text = data['text'];
        int senderId = data['senderId'];
        String username = await getSenderById(senderId);
        final title = '$username님에게 온 편지';

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
                              '$text',
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
            throw HttpException("You cannot access to letter");
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
    FutureBuilder<Stack>(
      future: buildTree(centerWidth, centerWidth, context),
      builder: (BuildContext context, AsyncSnapshot<Stack> snapshot) {
      if (snapshot.hasData) {
        return snapshot.data!;
      } else {
        return CircularProgressIndicator();
      }
    },
    ),
  Stack(
  children: [
  Positioned(
  left: 0,
  right: 0,
  bottom: deviceHeight / 30,
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
              Tuple2<double, double> position= Tuple2(100.0, 100.0);
  Navigator.push(
  context,
                MaterialPageRoute(builder: (context) => LetterScreen(argument: position)),
  );
  },
  ),
  ),
  ),
  ],
  ),
  const Text(
  'Search',
  style: optionStyle,
  ),
  const Text(
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
                  // print("deviceHeight: $deviceHeight, deviceWidth: $deviceWidth, centerHeight: $centerHeight, centerWidth: $centerWidth");

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
    MaterialPageRoute(builder: (context) => const FirstPage()),
  );
}