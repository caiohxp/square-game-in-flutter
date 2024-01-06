import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  const GameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return _gameTitle();
  }

  Widget _gameTitle() {
    var rowTitle = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Square",
          style: TextStyle(
            color: Colors.white,
            fontSize: 72,
            fontFamily: 'Squarea',
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "o",
          style: TextStyle(
            color: Colors.white,
            fontSize: 144,
            fontFamily: 'Squarea',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
    return rowTitle;
  }
}
