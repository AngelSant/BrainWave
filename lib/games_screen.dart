import 'package:flutter/material.dart';
import 'card_setup_screen.dart';
import 'memorama_game.dart';
import 'quiz_setup_screen.dart';
import 'sorting_setup_screen.dart';

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juegos'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Memorama'),
            tileColor: Colors.blue[50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardSetupScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Quiz de Preguntas'),
            tileColor: Colors.green[50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizSetupScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            title: Text('Juego de Ordenar'),
            tileColor: Colors.orange[50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SortingSetupScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
