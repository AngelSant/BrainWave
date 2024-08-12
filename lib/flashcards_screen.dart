import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final DatabaseReference flashcardsRef = FirebaseDatabase.instance.ref().child('flashcards');
  late DatabaseReference _flashcardsRef;
  List<Map<dynamic, dynamic>> _flashcards = [];

  @override
  void initState() {
    super.initState();
    _fetchFlashcards();
  }

  void _fetchFlashcards() {
    _flashcardsRef = FirebaseDatabase.instance.ref().child('flashcards');
    _flashcardsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final List<Map<dynamic, dynamic>> flashcards = [];
        data.forEach((key, value) {
          flashcards.add({'key': key, ...value});
        });
        setState(() {
          _flashcards = flashcards;
        });
      }
    });
  }

  void _showAddFlashcardDialog() {
    final _termController = TextEditingController();
    final _definitionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Flashcard'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _termController,
                decoration: InputDecoration(labelText: 'Término'),
              ),
              TextField(
                controller: _definitionController,
                decoration: InputDecoration(labelText: 'Definición'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                final term = _termController.text;
                final definition = _definitionController.text;

                if (term.isNotEmpty && definition.isNotEmpty) {
                  _flashcardsRef.push().set({
                    'term': term,
                    'definition': definition,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Flashcard agregada')),
                    );
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al agregar flashcard: $error')),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, ingrese todos los campos.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteFlashcard(String key) {
    _flashcardsRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard eliminada')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar flashcard: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
      ),
      body: ListView.builder(
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          final flashcard = _flashcards[index];
          return ListTile(
            title: Text(flashcard['term']),
            subtitle: flashcard['definitionVisible'] != true
                ? Text('Toca para ver la definición')
                : Text(flashcard['definition']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteFlashcard(flashcard['key']),
            ),
            onTap: () {
              setState(() {
                flashcard['definitionVisible'] = !(flashcard['definitionVisible'] ?? false);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFlashcardDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
