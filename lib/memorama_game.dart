import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shake/shake.dart';

class MemoramaGame extends StatefulWidget {
  final List<String> cardContents;

  MemoramaGame(this.cardContents);

  @override
  _MemoramaGameState createState() => _MemoramaGameState();
}

class _MemoramaGameState extends State<MemoramaGame> {
  late List<CardItem> _cards;
  late List<CardItem> _selectedCards;
  late bool _isMatching;
  late bool _isFlipping;
  late int _firstCardIndex;
  late int _secondCardIndex;
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _resetGame,
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  void _initializeGame() {
    List<String> shuffledContents = [...widget.cardContents];
    shuffledContents.addAll(widget.cardContents); // Duplicates for matching
    shuffledContents.shuffle();

    _cards = List.generate(shuffledContents.length, (index) {
      return CardItem(content: shuffledContents[index], isFlipped: false, isMatched: false);
    });

    _selectedCards = [];
    _isMatching = false;
    _isFlipping = false;
    _firstCardIndex = -1;
    _secondCardIndex = -1;
  }

  void _onCardTap(int index) {
    if (_isFlipping || _cards[index].isFlipped || _cards[index].isMatched) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;
      _selectedCards.add(_cards[index]);

      if (_selectedCards.length == 2) {
        _isFlipping = true;
        _firstCardIndex = _cards.indexOf(_selectedCards[0]);
        _secondCardIndex = _cards.indexOf(_selectedCards[1]);

        if (_selectedCards[0].content == _selectedCards[1].content) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _selectedCards[0].isMatched = true;
              _selectedCards[1].isMatched = true;
              _selectedCards.clear();
              _isFlipping = false;
            });
          });
        } else {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _cards[_firstCardIndex].isFlipped = false;
              _cards[_secondCardIndex].isFlipped = false;
              _selectedCards.clear();
              _isFlipping = false;
            });
          });
        }
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorama'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return GestureDetector(
            onTap: () => _onCardTap(index),
            child: Card(
              child: Center(
                child: card.isFlipped
                    ? Text(card.content, style: TextStyle(fontSize: 18))
                    : Text('', style: TextStyle(fontSize: 18)),
              ),
              color: card.isFlipped ? Colors.white : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

class CardItem {
  final String content;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });
}