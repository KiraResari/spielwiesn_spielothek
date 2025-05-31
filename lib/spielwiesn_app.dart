import 'package:flutter/material.dart';
import 'package:spielwiesn_spielothek/xml_game_respository.dart';

import 'game_filter_screen.dart';

class SpielwiesnApp extends StatelessWidget {
  const SpielwiesnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Game Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: GameFilterScreen(
        repository: XmlGameRepository('assets/Spieleliste.xml'),
      ),
    );
  }
}