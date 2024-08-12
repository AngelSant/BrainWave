import 'package:flutter/material.dart';
import 'memorama_game.dart';

class CardSetupScreen extends StatefulWidget {
  @override
  _CardSetupScreenState createState() => _CardSetupScreenState();
}

class _CardSetupScreenState extends State<CardSetupScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Tarjetas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _controllers.length,
                itemBuilder: (context, index) {
                  return TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Contenido de la tarjeta ${index + 1}',
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final cardContents = _controllers.map((controller) => controller.text).toList();
                if (cardContents.any((content) => content.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Por favor, ingrese el contenido para todas las tarjetas.'),
                  ));
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoramaGame(cardContents),
                  ),
                );
              },
              child: Text('Iniciar Juego'),
            ),
          ],
        ),
      ),
    );
  }
}
