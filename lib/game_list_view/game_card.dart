import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game.dart';
import 'game_list_controller.dart';
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GameSticker(game),
                const SizedBox(width: 12),
                _buildTextElements(),
                _buildFavButton(context),
              ],
            ),
          ),
          if (game.premium) _buildPremiumCorner(),
          if (game.novelty) _buildNoveltyCorner(),
          if (game.rating > 0) _buildRatingCorner(),
        ],
      ),
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

  Widget _buildPlayerCountAndPlayTimeRow() {
    String playerCountText = game.minPlayers == game.maxPlayers
        ? '${game.minPlayers} Spieler'
        : '${game.minPlayers}-${game.maxPlayers} Spieler';

    String playTimeText = game.minPlayTime == game.maxPlayTime
        ? '${game.minPlayTime} Minuten'
        : '${game.minPlayTime}-${game.maxPlayTime} Minuten';

    return Wrap(
      spacing: 6,
      runSpacing: 0,
      children: [
        Text(playerCountText),
        Text(playTimeText),
      ],
    );
  }

  Widget _buildComplexityCategoryAndCoOpRow() {
    return Wrap(
      spacing: 6,
      runSpacing: 0,
      children: [
        _buildComplexityText(),
        Text(game.category.name),
        if (game.cooperative) const Text("Co-Op"),
      ],
    );
  }

  Widget _buildComplexityText() {
    TextStyle textStyle = TextStyle(color: game.complexityLevel.displayColor);
    return Text(style: textStyle, game.complexityLevel.displayName);
  }

  Widget _buildFavButton(BuildContext context) {
    var controller = context.watch<GameListController>();
    return IconButton(
      icon: Icon(
        game.favorite ? Icons.star : Icons.star_border,
        color: game.favorite ? Colors.amber : Colors.grey,
      ),
      onPressed: () {
        controller.toggleFavorite(game);
      },
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
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
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

  Positioned _buildNoveltyCorner() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: const Text(
          "Neu",
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
}
