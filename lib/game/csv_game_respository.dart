import 'dart:convert';

import 'package:flutter/services.dart';

import 'game.dart';
import 'game_category.dart';
import 'game_repository.dart';
import 'material_type.dart';
import 'sticker_type.dart';

class CsvGameRepository implements GameRepository {
  final String csvPath;

  CsvGameRepository(this.csvPath);

  @override
  Future<List<Game>> fetchGames() async {
    final csvString = await rootBundle.loadString(csvPath);
    final lines = LineSplitter.split(csvString).where((line) => line.trim().isNotEmpty);

    return lines.map<Game>((line) {
      final values = line.split(',').map((e) => e.trim()).toList();

      return Game(
        name: values[0],
        searchAnchors: values[1],
        copiesOwned: int.tryParse(values[2]) ?? 0,
        stickerLetter: values[3],
        stickerType: StickerType.fromName(values[4]),
        category: GameCategory.fromName(values[5]),
        materialType: MaterialType.fromName(values[6]),
        rating: double.tryParse(values[7]) ?? 0.0,
        yearPublished: int.tryParse(values[8]) ?? 0,
        minPlayers: int.tryParse(values[9]) ?? 0,
        maxPlayers: int.tryParse(values[10]) ?? 0,
        minPlayTime: int.tryParse(values[11]) ?? 0,
        maxPlayTime: int.tryParse(values[12]) ?? 0,
        minAge: int.tryParse(values[13]) ?? 0,
        complexity: double.tryParse(values[14]) ?? 0.0,
        cooperative: values[15].isNotEmpty,
        novelty: values[16].isNotEmpty,
        premium: values[17].isNotEmpty,
        link: values[18],
      );
    }).toList();
  }
}
