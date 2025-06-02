import 'package:flutter/material.dart';

enum InventoryType {
  unknown(name: "Unbekannt", stickerColor: Colors.white),
  cards(name: "Karten", stickerColor: Colors.lightBlue),
  child(name: "Kind", stickerColor: Colors.yellow),
  normal(name: "Normal", stickerColor: Colors.white),
  two(name: "Zwei", stickerColor: Colors.pink);

  final String name;
  final Color stickerColor;

  const InventoryType({required this.name, required this.stickerColor});

  factory InventoryType.fromName(String name){
    return values.firstWhere(
          (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }
}
