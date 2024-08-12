import 'package:flutter/material.dart';

class SortingGameScreen extends StatefulWidget {
  final List<String> items;

  SortingGameScreen({required this.items});

  @override
  _SortingGameScreenState createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen> {
  late List<String> shuffledItems;

  @override
  void initState() {
    super.initState();
    shuffledItems = List.from(widget.items)..shuffle();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = shuffledItems.removeAt(oldIndex);
      shuffledItems.insert(newIndex, item);
    });
  }

  bool _isSortedCorrectly() {
    for (int i = 0; i < shuffledItems.length; i++) {
      if (shuffledItems[i] != widget.items[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ordenar'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder,
              children: [
                for (final item in shuffledItems)
                  ListTile(
                    key: ValueKey(item),
                    title: Text(item),
                    tileColor: Colors.blueAccent.withOpacity(0.3),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_isSortedCorrectly()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('¡Bien hecho!'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Inténtalo de nuevo.'),
                ));
              }
            },
            child: Text('Verificar Orden'),
          ),
        ],
      ),
    );
  }
}
