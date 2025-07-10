import 'package:flutter/material.dart';

enum GameComplexityLevel {
  verySimple(
    displayName: "Sehr leicht",
    displayColor: Colors.blue,
    textColor: Colors.black,
  ),
  simple(
    displayName: "Leicht",
    displayColor: Colors.green,
    textColor: Colors.black,
  ),
  moderate(
    displayName: "Mittel",
    displayColor: Colors.orange,
    textColor: Colors.black,
  ),
  complex(
    displayName: "Schwer",
    displayColor: Colors.red,
    textColor: Colors.black,
  ),
  veryComplex(
    displayName: "Sehr schwer",
    displayColor: Colors.purple,
    textColor: Colors.white,
  );

  final String displayName;
  final Color displayColor;
  final Color textColor;

  const GameComplexityLevel({
    required this.displayName,
    required this.displayColor,
    required this.textColor,
  });
}
