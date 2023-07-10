import 'dart:math' as math;

import 'package:flutter/material.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});
  @override
  _LetterScreenState createState() => _LetterScreenState();
}

(double, double) getRandPos(double startPoint, double endPoint, double deviceWidth) {
// createFruit(context , startPoint, 48+ math.Random().nextDouble()*(deviceWidth-48), 1),
  return (startPoint, (48+ math.Random().nextDouble()*(deviceWidth-48)).toDouble());
}

class _LetterScreenState extends State<LetterScreen> {
  final TextEditingController _letterController = TextEditingController();

  late double deviceWidth = MediaQuery.of(context).size.width;  // 화면의 가로 크기
  late double deviceHeight = MediaQuery.of(context).size.height; // 화면의 세로 크기
  late double centerHeight;
  late double centerWidth;
  late double poleHeight = deviceWidth*0.13;
  double imgSize = 48; // 1:1 image
  late final topPoint = (centerHeight - deviceWidth)*0.5 - imgSize; // img size = 48
  late final bottomPoint = topPoint + deviceWidth - poleHeight + imgSize; // img size = 48
  final startPoint = 0.0;
  late final endPoint = startPoint + deviceWidth - imgSize; // img size = 48

  bool isNotValidLetterPos(List<String> letters, double x, double y) {
  // return false;
  // double comp_x, comp_y;
  // get list of letter from DB
  // 
  //  for letter in letters :
  //    if abs(comp_x - x) < 48 && abs(comp_y - y) < 48:
  //      return true;
        if ((math.pow(x-(centerWidth-imgSize)*0.5, 2) + math.pow(y-(centerWidth-imgSize-poleHeight)*0.5, 2))>=math.pow((centerWidth-poleHeight)*0.5, 2)) {
          return true;
        }

    return false;
  }
  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Letter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            ElevatedButton(
              onPressed: () {
                // Handle letter submission
                String letter = _letterController.text;
                double x, y, posX, posY;
                (x, y) = getRandPos(startPoint, endPoint, deviceWidth);
                while (isNotValidLetterPos([], x, y)) {
                  (x, y) = getRandPos(startPoint, endPoint, deviceWidth);
                }
                posX = x;
                posY = y;
                // set Letter Data
                var body = {
                  // 'receiverId': receiverId,
                  'text': letter,
                  // 'openDate':
                  // 'isAno':
                  'posX':posX,
                  'posY':posY,
                  // 'img Type'
                };
                // 작성을 완료했습니다 토스트 띄우기
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}