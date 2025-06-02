import 'package:flutter/material.dart';

enum GameComplexityLevel {
  verySimple(displayName: "Sehr leicht", displayColor: Colors.blue),
  simple(displayName: "Leicht", displayColor: Colors.green),
  moderate(displayName: "Mittel", displayColor: Colors.orange),
  complex(displayName: "Schwer", displayColor: Colors.red),
  veryComplex(displayName: "Sehr schwer", displayColor: Colors.purple);

  final String displayName;
  final Color displayColor;

  const GameComplexityLevel({
    required this.displayName,
    required this.displayColor,
  });
}
