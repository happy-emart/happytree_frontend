import 'package:flutter/material.dart';

class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key});
  @override
  _LetterScreenState createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  TextEditingController _letterController = TextEditingController();

  @override
  void dispose() {
    _letterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Letter'),
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
                        decoration: InputDecoration(
                          hintText: 'Write your letter here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle letter submission
                String letter = _letterController.text;
                // Process the letter (e.g., send it to a recipient)
                // ...
                // 작성을 완료했습니다 토스트 띄우기
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
