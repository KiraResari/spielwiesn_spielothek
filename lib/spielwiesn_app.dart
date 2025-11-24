import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import 'game_list_view/game_list_view.dart';

class SpielwiesnApp extends StatelessWidget {
  const SpielwiesnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spielwiesn Spielothek',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: UpgradeAlert(child: const GameListView()),
    );
  }
}
