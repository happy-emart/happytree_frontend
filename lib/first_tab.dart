import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/writing_letter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:math' as math;

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

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
  List<int> fruits = [];
    // List<Tuple2<double, double>> pointList = [];
    // while (pointList.length < 5) {
    //   var pntX = 0.0, pntY = 0.0;
    //   if (
    //     (math.pow(pntX-(centerWidth-imgSize)*0.5, 2) + math.pow(pntY-(centerWidth-imgSize-poleHeight)*0.5, 2))<=math.pow((centerWidth-poleHeight)*0.5, 2)
    //     ) { pointList.add(Tuple2(pntX, pntY)); }
    // }

  @override
  void initState()
  {
    fetchFruits();
  }

  Future<String?> getJwtToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  void fetchFruits() async {
    const String Url = "http://127.0.0.1:8080/received_letters";
    final jwtToken = await getJwtToken();
    print('Bearer $jwtToken');
    final request = Uri.parse(Url);
    final headers = <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken'
    };
    try
    {
      final response = await http.get(request, headers: headers);
      print('body : ');
      print(response.body);
    }
    catch(error)
    {
      print('error : $error');
    }

    fruits.add(1);
    fruits.add(2);
    fruits.add(3);
    fruits.add(4);
  }

  Stack buildTree(double cntrHeight, double cntrWidth, BuildContext context, List<dynamic> fruits) {
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
                createFruit(context , startPoint + math.Random().nextDouble()*(endPoint-startPoint), 48+ math.Random().nextDouble()*(deviceWidth-48), fruit),
              ],
              // buildImageStack(5),
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
            title: const Column(
              children: <Widget>[
                Text("편지의 제목"),
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

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);


  late final List<Widget> _widgetOptions = <Widget>[
    buildTree(centerWidth, centerWidth, context, fruits),
    Stack(
      children:[
      buildTree(centerWidth, centerWidth, context, fruits),
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