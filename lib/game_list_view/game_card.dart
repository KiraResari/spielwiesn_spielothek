import 'package:flutter/material.dart';

import '../game/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${game.name} (${game.yearPublished}) ${game.rating.toStringAsFixed(1)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('${game.minPlayers}-${game.maxPlayers} Spieler'),
            Text('${game.minPlayTime}-${game.maxPlayTime} Minuten'),
          ],
        ),
      ),
    );
  }
}
