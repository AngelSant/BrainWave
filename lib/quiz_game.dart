import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class QuizGameScreen extends StatefulWidget {
  final List<Map<String, String>> questions;

  QuizGameScreen({required this.questions});

  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  String feedbackMessage = '';
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _resetQuiz,
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      feedbackMessage = '';
      _answerController.clear();
    });
  }

  void _submitAnswer() {
    setState(() {
      if (_answerController.text.toLowerCase() ==
          widget.questions[currentQuestionIndex]['answer']!.toLowerCase()) {
        feedbackMessage = 'Correcto!';
      } else {
        feedbackMessage = 'Incorrecto. La respuesta era: ${widget.questions[currentQuestionIndex]['answer']}';
      }
      _answerController.clear();
      currentQuestionIndex++;
      if (currentQuestionIndex >= widget.questions.length) {
        currentQuestionIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.questions[currentQuestionIndex]['question']!,
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Tu Respuesta'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Responder'),
            ),
            SizedBox(height: 20),
            Text(feedbackMessage),
          ],
        ),
      ),
    );
  }
}