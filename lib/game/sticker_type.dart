import 'package:flutter/material.dart';

enum StickerType {
  unknown(name: "Unbekannt", stickerColor: Colors.white),
  cards(
    name: "Karten",
    displayName: "Karten",
    stickerColor: Colors.lightBlue,
    textColor: Colors.white,
  ),
  child(name: "Kind", displayName: "Kind", stickerColor: Colors.yellow),
  normal(name: "Normal", stickerColor: Colors.white),
  two(name: "Zwei", displayName: "2er-Spiel", stickerColor: Colors.pink);

  final String name;
  final String displayName;
  final Color stickerColor;
  final Color textColor;

  const StickerType({
    required this.name,
    this.displayName = "",
    required this.stickerColor,
    this.textColor = Colors.black,
  });

  factory StickerType.fromName(String name) {
    return values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }

  static  List<StickerType> get filterOrder => [
    StickerType.normal,
    StickerType.cards,
    StickerType.two,
    StickerType.child,
  ];
}
