import 'dart:math' as math;
import 'first_tab.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String baseUrl = baseUrl;


// deviceWidth, deviceHeight, centerHeight, imgSize

class PaperScreen extends StatefulWidget {
  final Tuple4<double, double, double, double> argument;
  final int receiverId;
  final List<Paper> papers;
  const PaperScreen({Key? key, required this.argument, required this.receiverId, required this.papers}) : super(key: key);
  @override
  _PaperScreenState createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  final TextEditingController _paperController = TextEditingController();

  @override
  void dispose() {
    _paperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int receiverId = widget.receiverId;
    Tuple4<double, double, double, double> argument = widget.argument;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Paper'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            selectOtherButton(argument: argument, paperController: _paperController),
            Expanded(
              child: SingleChildScrollView(
                child:
                Column(
                  children: [
                    TextField(
                      controller: _paperController,
                      maxLines: null, // Allows the TextField to expand vertically as needed
                      decoration: const InputDecoration(
                        hintText: 'Write your Rolling paper here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            sendigButton(argument: argument, paperController: _paperController, widget: widget, receiverId: receiverId),
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
    required TextEditingController paperController,
  }) : _paperController = paperController;

  final Tuple4<double, double, double, double> argument;
  final TextEditingController _paperController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // // Handle letter submission
        // var posX = argument.item1;
        // var posY = argument.item1;
        // String letter = _letterController.text;
        // // set Paper Data
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

class sendigButton extends StatelessWidget {
  const sendigButton({
    super.key,
    required this.argument,
    required TextEditingController paperController,
    required this.widget,
    required this.receiverId,
  }) : _paperController = paperController;

  final Tuple4<double, double, double, double> argument;
  final TextEditingController _paperController;
  final PaperScreen widget;
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

        String paperText = _paperController.text;
        // set Paper Data
        var body = {
          'receiverId': receiverId,
          'text': paperText,
          // 'openDate':
          // 'isAno':
        };
        print(body);
        sendPaper(body);
        // 작성을 완료했습니다 토스트 띄우기
        Navigator.pop(context);
      },
      child: const Text('Submit'),
    );
  }
}

void sendPaper(Map<String, dynamic> body) async {
  const String Url = "http://168.131.151.213:4040/sent_paper";
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
