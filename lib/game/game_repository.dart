import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../getIt.dart';
import '../utils/shared_preferences_wrapper.dart';
import 'csv_game_list_parser.dart';
import 'game.dart';

class GameRepository {
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";

  final sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();

  List<Game> _games = [];
  final List<Game> _favoriteGames = [];

  List<Game> get games => _games;

  Future<void> initialize() async {
    await _populateGamesList();
    await _loadFavorites();
  }

  Future<void> _populateGamesList() async {
    String csvString = await _getGamesCsv();
    csvString = _sanitizeCsv(csvString);
    _games = await compute(_parseGames, csvString);
  }

  Future<String> _getGamesCsv() async {
    try {
      http.Response response =
          await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        String csv = utf8.decode(response.bodyBytes);
        await sharedPreferencesWrapper.setGamesCsv(csv);
        return csv;
      }
    } catch (e) {
      stderr.writeln("Error while trying to download latest game csv: $e");
    }
    String? cachedCsv = await sharedPreferencesWrapper.gamesCsv;
    if (cachedCsv != null && cachedCsv.isNotEmpty) {
      return cachedCsv;
    }
    return rootBundle.loadString(csvPath);
  }

  String _sanitizeCsv(String csv) {
    if (csv.startsWith('\uFEFF')) {
      csv = csv.substring(1);
    }
    return csv.replaceAll('\r\n', '\n');
  }

  List<Game> _parseGames(String csvString) {
    final parser = CsvGameListParser();
    return parser.parseCsv(csvString);
  }

  Future<void> _loadFavorites() async {
    List<String> cachedFavIds = await sharedPreferencesWrapper.favIds;
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
    await sharedPreferencesWrapper.setFavIds(identifiers);
  }
}
