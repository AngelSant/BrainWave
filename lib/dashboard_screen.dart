import 'package:flutter/material.dart';
import 'flashcards_screen.dart';
import 'games_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Flashcards'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlashcardsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.games),
            title: Text('Sección de Juegos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Progreso'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProgressScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
