import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../game/csv_game_list_parser.dart';
import '../game/game.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';

class GameListController extends ChangeNotifier {
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";
  static const imprintPath = "assets/Imprint.md";
  static const privacyPath = "assets/Privacy.md";
  static const gameListCacheKey = 'spielwiesn_spielothek_spieleliste';
  static const favoritesCacheKey = 'spielwiesn_spielothek_favoriten';

  final csvGameListParser = CsvGameListParser();
  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();

  List<GameComplexityLevel> selectedComplexityLevels =
      List.from(GameComplexityLevel.values);
  List<GameCategory> selectedCategories = List.from(GameCategory.values);
  List<bool> selectedCoOp = [true, false];
  List<bool> selectedPremium = [true, false];
  List<bool> selectedNovelty = [true, false];
  bool showOnlyFavorites = false;

  List<Game> _games = [];
  final List<Game> _favoriteGames = [];
  List<Game> filteredGames = [];
  String _imprint = "Impressum konnte nicht geladen werden";
  String _privacy = "Datenschutzvereinbarung konnte nicht geladen werden";

  GameListController() {
    _init();
  }

  Future<void> _init() async {
    await _populateGamesList();
    await _loadFavorites();
    _imprint = await rootBundle.loadString(imprintPath);
    _privacy = await rootBundle.loadString(privacyPath);
    _setupListeners();
    notifyListeners();
  }

  Future<void> _populateGamesList() async {
    String csvString = await _getGamesCsv();
    _games = csvGameListParser.parseCsv(csvString);
    filteredGames = List.from(_games);
  }

  Future<String> _getGamesCsv() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        final csv = utf8.decode(response.bodyBytes);
        await prefs.setString(gameListCacheKey, csv);
        return csv;
      }
    } catch (e) {
      stderr.writeln("Error while trying to download latest game csv: $e");
    }
    final cachedCsv = prefs.getString(gameListCacheKey);
    if (cachedCsv != null && cachedCsv.isNotEmpty) {
      return cachedCsv;
    }
    return rootBundle.loadString(csvPath);
  }

  void _setupListeners() {
    nameController.addListener(filterGames);
    playersController.addListener(filterGames);
    durationController.addListener(filterGames);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedFavIds = prefs.getStringList(favoritesCacheKey) ?? [];
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

  void filterGames() {
    filteredGames = _games.where((game) {
      return _matchesName(game) &&
          _matchesPlayers(game) &&
          _matchesDuration(game) &&
          _matchesFavoriteFilter(game) &&
          selectedComplexityLevels.contains(game.complexityLevel) &&
          selectedCategories.contains(game.category) &&
          selectedCoOp.contains(game.cooperative) &&
          selectedPremium.contains(game.premium) &&
          selectedNovelty.contains(game.novelty);
    }).toList();

    notifyListeners();
  }

  bool _matchesName(Game game) {
    String name = nameController.text.trim().toLowerCase();
    return name.isEmpty ||
        game.nameAndSearchAnchors.toLowerCase().contains(name);
  }

  bool _matchesPlayers(Game game) {
    int? players = int.tryParse(playersController.text.trim());
    return players == null ||
        (players >= game.minPlayers && players <= game.maxPlayers);
  }

  bool _matchesDuration(Game game) {
    int? duration = int.tryParse(durationController.text.trim());
    return duration == null ||
        (duration >= game.minPlayTime && duration <= game.maxPlayTime);
  }

  bool _matchesFavoriteFilter(Game game) {
    if (showOnlyFavorites && !game.favorite) {
      return false;
    }
    return true;
  }

  void toggleComplexity(GameComplexityLevel level) {
    if (selectedComplexityLevels.contains(level)) {
      selectedComplexityLevels.remove(level);
    } else {
      selectedComplexityLevels.add(level);
    }
    filterGames();
  }

  void toggleCategory(GameCategory category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    filterGames();
  }

  void toggleCoOp(bool value) {
    if (selectedCoOp.contains(value)) {
      selectedCoOp.remove(value);
    } else {
      selectedCoOp.add(value);
    }
    filterGames();
  }

  void togglePremium(bool value) {
    if (selectedPremium.contains(value)) {
      selectedPremium.remove(value);
    } else {
      selectedPremium.add(value);
    }
    filterGames();
  }

  void toggleNovelty(bool value) {
    if (selectedNovelty.contains(value)) {
      selectedNovelty.remove(value);
    } else {
      selectedNovelty.add(value);
    }
    filterGames();
  }

  void clearField(TextEditingController controller) {
    controller.clear();
    filterGames();
  }

  Future<void> toggleFavorite(Game game) async {
    game.favorite = !game.favorite;
    _favoriteGames.contains(game)
        ? _favoriteGames.remove(game)
        : _favoriteGames.add(game);
    await _saveFavorites();
    filterGames();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final identifiers = _favoriteGames.map((g) => g.identifier).toList();
    await prefs.setStringList(favoritesCacheKey, identifiers);
  }

  String get imprint => _imprint;

  String get privacy => _privacy;

  @override
  void dispose() {
    nameController.dispose();
    playersController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
