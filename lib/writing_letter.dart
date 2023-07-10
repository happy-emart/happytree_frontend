import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class LetterScreen extends StatefulWidget {
  final Tuple2<double, double> argument;
  const LetterScreen({Key? key, required this.argument}) : super(key: key);
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
    int receiverId;
    Tuple2<double, double> argument = widget.argument;
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
                var posX = argument.item1, posY = argument.item1;
                String letter = _letterController.text;
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