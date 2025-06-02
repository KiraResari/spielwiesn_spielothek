import 'package:flutter/material.dart';

import 'game_list_view/game_list_view.dart';

class SpielwiesnApp extends StatelessWidget {
  const SpielwiesnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Game Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const GameListView(),
    );
  }
}