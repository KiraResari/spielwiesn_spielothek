import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../game/csv_game_list_parser.dart';
import '../game/game.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';

class GameListController extends ChangeNotifier {
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";

  final csvGameListParser = CsvGameListParser();
  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();

  List<GameComplexityLevel> selectedComplexityLevels =
      List.from(GameComplexityLevel.values);
  List<GameCategory> selectedCategories = List.from(GameCategory.values);
  List<bool> selectedCoOp = [true, false];

  List<Game> _games = [];
  List<Game> filteredGames = [];

  GameListController() {
    _init();
  }

  Future<void> _init() async {
    await _populateGamesList();
    _setupListeners();
    notifyListeners();
  }

  Future<void> _populateGamesList() async {
    String csvString = await _getGamesCsvFromEndpointOrFallback();
    _games = csvGameListParser.parseCsv(csvString);
    filteredGames = List.from(_games);
  }

  Future<String> _getGamesCsvFromEndpointOrFallback() async {
    try {
      final response = await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      stderr.writeln("Error while trying to download latest game csv: $e");
    }
    return rootBundle.loadString(csvPath);
  }

  void _setupListeners() {
    nameController.addListener(filterGames);
    playersController.addListener(filterGames);
    durationController.addListener(filterGames);
  }

  void filterGames() {
    filteredGames = _games.where((game) {
      return _matchesName(game) &&
          _matchesPlayers(game) &&
          _matchesDuration(game) &&
          selectedComplexityLevels.contains(game.complexityLevel) &&
          selectedCategories.contains(game.category) &&
          selectedCoOp.contains(game.cooperative);
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

  void clearField(TextEditingController controller) {
    controller.clear();
    filterGames();
  }

  @override
  void dispose() {
    nameController.dispose();
    playersController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
