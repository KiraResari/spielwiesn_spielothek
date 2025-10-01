import 'package:flutter/material.dart';

import '../game/game.dart';
import '../game/sticker_type.dart';

class GameSticker extends StatelessWidget {
  final String stickerLetter;
  final StickerType stickerType;

  GameSticker(Game game, {super.key})
      : stickerLetter = game.stickerLetter,
        stickerType = game.stickerType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: stickerType.stickerColor,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stickerLetter,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: stickerType.fontColor,
                ),
              ),
              if (stickerType.displayName.isNotEmpty)
                Text(
                  stickerType.displayName,
                  style: TextStyle(
                    fontSize: 8,
                    height: 1.1,
                    color: stickerType.fontColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
