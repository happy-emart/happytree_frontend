import 'dart:math' as math;
import 'first_tab.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String baseUrl = baseUrl;


// deviceWidth, deviceHeight, centerHeight, imgSize

class LetterScreen extends StatefulWidget {
  final Tuple4<double, double, double, double> argument;
  final int receiverId;
  final List<Letter> letters;
  const LetterScreen({Key? key, required this.argument, required this.receiverId, required this.letters}) : super(key: key);
  @override
  _LetterScreenState createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  final TextEditingController _letterController = TextEditingController();

  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int receiverId = widget.receiverId;
    Tuple4<double, double, double, double> argument = widget.argument;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Letter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            selectOtherButton(argument: argument, letterController: _letterController),
            Expanded(
              child: SingleChildScrollView(
                child:
                  Column(
                    children: [
                      TextField(
                        controller: _letterController,
                        maxLines: null, // Allows the TextField to expand vertically as needed
                        decoration: const InputDecoration(
                          hintText: 'Write your letter here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            const SizedBox(height: 16.0),
            sendingButton(argument: argument, letterController: _letterController, widget: widget, receiverId: receiverId),
          ],
        ),
      ),
    );
  }
}

class selectOtherButton extends StatelessWidget {
  const selectOtherButton({
    super.key,
    required this.argument,
    required TextEditingController letterController,
  }) : _letterController = letterController;

  final Tuple4<double, double, double, double> argument;
  final TextEditingController _letterController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // // Handle letter submission
        // var posX = argument.item1;
        // var posY = argument.item1;
        // String letter = _letterController.text;
        // // set Letter Data
        // var body = {
        //   // 'receiverId': receiverId,
        //   'text': letter,
        //   // 'openDate':
        //   // 'isAno':
        //   'posX':posX,
        //   'posY':posY,
        //   // 'img Type'
        // };
        // print("작성 완료 : $posX, $posY");
        // 작성을 완료했습니다 토스트 띄우기
        Navigator.pop(context);
      },
      child: const Text('Select Other User(not implememted)'),
    );
  }
}

class sendingButton extends StatelessWidget {
  const sendingButton({
    super.key,
    required this.argument,
    required TextEditingController letterController,
    required this.widget,
    required this.receiverId,
  }) : _letterController = letterController;

  final Tuple4<double, double, double, double> argument;
  final TextEditingController _letterController;
  final LetterScreen widget;
  final int receiverId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle letter submission
        var deviceWidth = argument.item1;
        var deviceHeight = argument.item2;
        var centerHeight = argument.item3;
        var imgSize = argument.item4;
        double poleHeight = deviceWidth*0.13;
        final topPoint = (centerHeight - deviceWidth)*0.5; // img size = 48
        final bottomPoint = topPoint + deviceWidth - poleHeight - imgSize; // img size = 48
        const startPoint = 0.0;
        final endPoint = startPoint + deviceWidth - imgSize; // img size = 48
        
        String letterText = _letterController.text;
        (double, double) getRandPos() {
          return (topPoint + math.Random().nextDouble()*(bottomPoint-topPoint), startPoint + math.Random().nextDouble()*(endPoint-startPoint));
        }
        bool isNotValidLetterPos(List<Letter> letters, double x, double y) {
          if ((math.pow(x-(deviceWidth-imgSize)*0.5, 2) + math.pow(y-(deviceWidth-imgSize-poleHeight)*0.5, 2))>=math.pow((deviceWidth-poleHeight)*0.5, 2)) {
            return true;
          }
          for (var letter in letters) {
            if (((letter.posX - x).abs() < 48) && ((letter.posY - y).abs() < 48)) return true;
          }
          return false;
        }
        double posX = 0.0;
        double posY = 0.0;
        while(true) {
          (posX, posY) = getRandPos();
          if (!isNotValidLetterPos(widget.letters, posX, posY)) {
            break;
          }
        }
        // set Letter Data
        var body = {
          'receiverId': receiverId,
          'text': letterText,
          // 'openDate':
          // 'isAno':
          'posX':posX,
          'posY':posY,
          // 'imgType':math.Random().nextInt(16),
        };
        sendLetter(body);
        // 작성을 완료했습니다 토스트 띄우기
        showCustomToast(context, "편지를 보냈어요");
        Navigator.pop(context);
      },
      child: const Text('Submit'),
    );
  }
}

void sendLetter(Map<String, dynamic> body) async {
  const String Url = "http://168.131.151.213:4040/sent_letters";
  final request = Uri.parse(Url);
  final jwtToken = await getJwtToken();
  final headers = <String, String> {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $jwtToken'
  };
  try
    {
      final response = await http.post(request, headers: headers, body: json.encode(body));
      print(response.body);
    }
    catch(error)
    {
      print('error : $error');
    }
  }

Future<String?> getJwtToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}
