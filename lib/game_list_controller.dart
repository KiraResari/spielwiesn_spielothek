import 'package:flutter/material.dart';
import 'package:spielwiesn_spielothek/xml_game_respository.dart';
import 'game.dart';
import 'game_repository.dart';

class GameListController extends ChangeNotifier {
  final GameRepository repository = XmlGameRepository('assets/Spieleliste.xml');

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
    final name = nameController.text.trim().toLowerCase();
    final players = int.tryParse(playersController.text.trim());
    final duration = int.tryParse(durationController.text.trim());
    final year = int.tryParse(yearController.text.trim());
    final rating = double.tryParse(ratingController.text.trim());

    filteredGames = _games.where((game) {
      final matchesName = name.isEmpty || game.name.toLowerCase().contains(name);
      final matchesPlayers = players == null || (players >= game.minPlayers && players <= game.maxPlayers);
      final matchesDuration = duration == null || (duration >= game.minPlayTime && duration <= game.maxPlayTime);
      final matchesYear = year == null || year == game.yearPublished;
      final matchesRating = rating == null || game.rating >= rating;

      return matchesName && matchesPlayers && matchesDuration && matchesYear && matchesRating;
    }).toList();

    notifyListeners();
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