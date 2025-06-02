import 'package:flutter/material.dart';

import '../game/csv_game_respository.dart';
import '../game/game.dart';
import '../game/game_repository.dart';

class GameListController extends ChangeNotifier {
  final GameRepository repository = CsvGameRepository('assets/Spieleliste.csv');

  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();
  final yearController = TextEditingController();
  final ratingController = TextEditingController();

  List<Game> _games = [];
  List<Game> filteredGames = [];

  GameListController() {
    _init();
  }

  Future<void> _init() async {
    _games = await repository.fetchGames();
    filteredGames = List.from(_games);
    _setupListeners();
    notifyListeners();
  }

  void _setupListeners() {
    nameController.addListener(filterGames);
    playersController.addListener(filterGames);
    durationController.addListener(filterGames);
    yearController.addListener(filterGames);
    ratingController.addListener(filterGames);
  }

  void filterGames() {
    filteredGames = _games.where((game) {
      return _matchesName(game) &&
          _matchesPlayers(game) &&
          _matchesDuration(game);
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

  void clearField(TextEditingController controller) {
    controller.clear();
    filterGames();
  }

  @override
  void dispose() {
    nameController.dispose();
    playersController.dispose();
    durationController.dispose();
    yearController.dispose();
    ratingController.dispose();
    super.dispose();
  }
}
