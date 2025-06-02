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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: inventoryType.stickerColor,
          child: Text(
            inventoryLetter,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        if (_showLabel)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              inventoryType.name,
              style: const TextStyle(fontSize: 10),
            ),
          ),
      ],
    );
  }
}
