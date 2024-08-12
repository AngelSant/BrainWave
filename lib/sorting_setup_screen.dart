import 'package:flutter/material.dart';
import 'sorting_game.dart';

class SortingSetupScreen extends StatefulWidget {
  @override
  _SortingSetupScreenState createState() => _SortingSetupScreenState();
}

class _SortingSetupScreenState extends State<SortingSetupScreen> {
  final List<String> items = [];

  final TextEditingController itemController = TextEditingController();

  void _addItem() {
    if (itemController.text.isNotEmpty) {
      setState(() {
        items.add(itemController.text);
      });
      itemController.clear();
    }
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _startGame() {
    if (items.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SortingGameScreen(items: items),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Sorting Game'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: 'Elemento'),
            ),
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text('Agregar Elemento'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _startGame,
              child: Text('Iniciar Juego'),
            ),
          ),
        ],
      ),
    );
  }
}
