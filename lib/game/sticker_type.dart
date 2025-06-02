import 'package:flutter/material.dart';

enum StickerType {
  unknown(name: "Unbekannt", stickerColor: Colors.white),
  cards(
    name: "Karten",
    displayName: "Karten",
    stickerColor: Colors.lightBlue,
    fontColor: Colors.white,
  ),
  child(name: "Kind", displayName: "Kind", stickerColor: Colors.yellow),
  normal(name: "Normal", stickerColor: Colors.white),
  two(name: "Zwei", displayName: "2er-Spiel", stickerColor: Colors.pink);

  final String name;
  final String displayName;
  final Color stickerColor;
  final Color fontColor;

  const StickerType({
    required this.name,
    this.displayName = "",
    required this.stickerColor,
    this.fontColor = Colors.black,
  });

  factory StickerType.fromName(String name) {
    return values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }
}
