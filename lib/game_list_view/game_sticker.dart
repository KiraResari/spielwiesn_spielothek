import 'package:flutter/material.dart';

import '../game/inventory_type.dart';

class GameSticker extends StatelessWidget {
  final String inventoryLetter;
  final InventoryType inventoryType;

  const GameSticker({
    super.key,
    required this.inventoryLetter,
    required this.inventoryType,
  });

  bool get _showLabel =>
      inventoryType == InventoryType.cards ||
      inventoryType == InventoryType.child ||
      inventoryType == InventoryType.two;

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
            backgroundColor: inventoryType.stickerColor,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                inventoryLetter,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              if (_showLabel)
                Text(
                  inventoryType.name,
                  style: const TextStyle(
                    fontSize: 8,
                    height: 1.1,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
