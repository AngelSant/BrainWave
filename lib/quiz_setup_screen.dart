import 'package:flutter/material.dart';
import 'quiz_game.dart';

class QuizSetupScreen extends StatefulWidget {
  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  final List<Map<String, String>> questions = [];

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  void _addQuestion() {
    if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
      setState(() {
        questions.add({
          'question': questionController.text,
          'answer': answerController.text,
        });
      });
      questionController.clear();
      answerController.clear();
    }
  }

  void _removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  void _startQuiz() {
    if (questions.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizGameScreen(questions: questions),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Quiz'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Pregunta'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Respuesta'),
            ),
          ),
          ElevatedButton(
            onPressed: _addQuestion,
            child: Text('Agregar Pregunta'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index]['question']!),
                  subtitle: Text(questions[index]['answer']!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeQuestion(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _startQuiz,
              child: Text('Iniciar Quiz'),
            ),
          ),
        ],
      ),
    );
  }
}
