import 'package:csv/csv.dart';
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

    final rows = const CsvToListConverter(
      fieldDelimiter: ',',
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(csvString);

    return rows
        .where((row) => row.isNotEmpty && row.first.toString().trim().isNotEmpty)
        .map<Game>((values) => _mapRowToGame(values))
        .toList();
  }

  Game _mapRowToGame(List<dynamic> values) {
    final name = values[0].toString().trim();
    final searchAnchors = values[1].toString().trim();
    final copiesOwned = int.tryParse(values[2].toString()) ?? 0;
    final stickerLetter = values[3]?.toString() ?? "";
    final stickerType = StickerType.fromName(values[4]?.toString() ?? "");
    final category = GameCategory.fromName(values[5]?.toString() ?? "");
    final materialType = MaterialType.fromName(values[6]?.toString() ?? "");
    final rating = double.tryParse(values[7].toString()) ?? 0.0;
    final yearPublished = int.tryParse(values[8].toString()) ?? 0;
    final minPlayers = int.tryParse(values[9].toString()) ?? 0;
    final maxPlayers = int.tryParse(values[10].toString()) ?? 0;
    final minPlayTime = int.tryParse(values[11].toString()) ?? 0;
    final maxPlayTime = int.tryParse(values[12].toString()) ?? 0;
    final minAge = int.tryParse(values[13].toString()) ?? 0;
    final complexity = double.tryParse(values[14].toString()) ?? 0.0;
    final cooperative = values[15]?.toString().isNotEmpty == true;
    final novelty = values[16]?.toString().isNotEmpty == true;
    final premium = values[17]?.toString().isNotEmpty == true;
    final link = values[18].toString().trim();

    return Game(
      name: name,
      searchAnchors: searchAnchors,
      yearPublished: yearPublished,
      minPlayers: minPlayers,
      maxPlayers: maxPlayers,
      minPlayTime: minPlayTime,
      maxPlayTime: maxPlayTime,
      rating: rating,
      copiesOwned: copiesOwned,
      stickerLetter: stickerLetter,
      stickerType: stickerType,
      category: category,
      materialType: materialType,
      minAge: minAge,
      complexity: complexity,
      cooperative: cooperative,
      novelty: novelty,
      premium: premium,
      link: link,
    );
  }
}
