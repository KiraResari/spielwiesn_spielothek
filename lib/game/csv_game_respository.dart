import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'game.dart';
import 'game_category.dart';
import 'game_repository.dart';
import 'inventory_type.dart';
import 'material_type.dart';

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
        copiesOwned: int.tryParse(values[1]) ?? 0,
        inventoryLetter: values[2],
        inventoryType: InventoryType.fromName(values[3]),
        category: GameCategory.fromName(values[3]),
        materialType: MaterialType.fromName(values[3]),
        rating: double.tryParse(values[6]) ?? 0.0,
        yearPublished: int.tryParse(values[7]) ?? 0,
        minPlayers: int.tryParse(values[8]) ?? 0,
        maxPlayers: int.tryParse(values[9]) ?? 0,
        minPlayTime: int.tryParse(values[10]) ?? 0,
        maxPlayTime: int.tryParse(values[11]) ?? 0,
        minAge: int.tryParse(values[12]) ?? 0,
        complexity: double.tryParse(values[13]) ?? 0.0,
        cooperative: values[14].isNotEmpty,
        novelty: values[15].isNotEmpty,
        premium: values[16].isNotEmpty,
        link: values[17],
      );
    }).toList();
  }
}
