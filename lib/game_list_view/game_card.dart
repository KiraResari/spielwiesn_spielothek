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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameSticker(game),
                const SizedBox(width: 12),
                _buildTextElements(),
              ],
            ),
          ),
          if (game.premium) _buildPremiumCorner(),
          if (game.rating > 0) _buildRatingCorner(),
        ],
      ),
    );
  }

  Positioned _buildPremiumCorner() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
          ),
        ),
        child: const Text(
          "Exclusiv",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Positioned _buildRatingCorner() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Text("${game.rating}👍"),
    );
  }

  Expanded _buildTextElements() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeadline(),
          _buildPlayerCountAndPlayTimeRow(),
          _buildComplexityCategoryAndCoOpRow(),
        ],
      ),
    );
  }

  Text _buildHeadline() {
    String headlineText = game.yearPublished > 0
        ? '${game.name} (${game.yearPublished})'
        : game.name;

    return Text(
      headlineText,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Row _buildPlayerCountAndPlayTimeRow() {
    String playerCountText = game.minPlayers == game.maxPlayers
        ? '${game.minPlayers} Spieler'
        : '${game.minPlayers}-${game.maxPlayers} Spieler';

    String playTimeText = game.minPlayTime == game.maxPlayTime
        ? '${game.minPlayTime} Minuten'
        : '${game.minPlayTime}-${game.maxPlayTime} Minuten';

    return Row(
      children: [
        Text(playerCountText),
        const SizedBox(width: 10),
        Text(playTimeText),
      ],
    );
  }

  Row _buildComplexityCategoryAndCoOpRow() {
    return Row(
      children: [
        _buildComplexityText(),
        const SizedBox(width: 10),
        Text(game.category.name),
        if (game.cooperative) const SizedBox(width: 10),
        if (game.cooperative) const Text("Co-Op"),
      ],
    );
  }

  Widget _buildComplexityText() {
    TextStyle textStyle = TextStyle(color: game.complexityLevel.displayColor);
    return Text(style: textStyle, game.complexityLevel.displayName);
  }
}
