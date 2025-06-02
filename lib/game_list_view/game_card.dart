import 'package:flutter/material.dart';

import '../game/game.dart';
import 'game_sticker.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameSticker(
              inventoryLetter: game.inventoryLetter,
              inventoryType: game.inventoryType,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _buildHeadlineText(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(_buildPlayerCountText()),
                      const SizedBox(width: 10),
                      Text(_buildPlayTimeText()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildHeadlineText() => game.yearPublished > 0
      ? '${game.name} (${game.yearPublished})'
      : game.name;

  String _buildPlayerCountText() => game.minPlayers == game.maxPlayers
      ? '${game.minPlayers} Spieler'
      : '${game.minPlayers}-${game.maxPlayers} Spieler';

  String _buildPlayTimeText() => game.minPlayTime == game.maxPlayTime
      ? '${game.minPlayTime} Minuten'
      : '${game.minPlayTime}-${game.maxPlayTime} Minuten';
}
