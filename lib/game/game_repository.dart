import 'package:flutter/foundation.dart';

import '../getIt.dart';
import '../utils/shared_preferences_wrapper.dart';
import 'csv_game_list_parser.dart';
import 'game.dart';
import 'game_csv_client.dart';

class GameRepository {
  final _sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();
  final _client = getIt.get<GameCsvClient>();
  final _parser = getIt.get<CsvGameListParser>();

  List<Game> _games = [];
  final List<Game> _favoriteGames = [];

  List<Game> get games => _games;

  Future<void> initialize() async {
    String csvString = await _client.gamesCsv;
    csvString = _sanitizeCsv(csvString);
    _games = await compute(_parser.parseCsv, csvString);
    await _loadFavorites();
  }

  String _sanitizeCsv(String csv) {
    if (csv.startsWith('\uFEFF')) {
      csv = csv.substring(1);
    }
    return csv.replaceAll('\r\n', '\n');
  }

  Future<void> _loadFavorites() async {
    List<String> cachedFavIds = await _sharedPreferencesWrapper.favIds;
    _favoriteGames.clear();
    for (String cachedFavId in cachedFavIds) {
      for (Game game in _games) {
        if (game.identifier == cachedFavId) {
          game.favorite = true;
          _favoriteGames.add(game);
        }
      }
    }
  }

  Future<void> toggleFavorite(Game game) async {
    game.favorite = !game.favorite;
    _favoriteGames.contains(game)
        ? _favoriteGames.remove(game)
        : _favoriteGames.add(game);
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    List<String> identifiers = _favoriteGames.map((g) => g.identifier).toList();
    await _sharedPreferencesWrapper.setFavIds(identifiers);
  }
}
