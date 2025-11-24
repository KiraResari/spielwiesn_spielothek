import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../game/csv_game_list_parser.dart';
import '../game/game.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';

class _FilterPill {
  final String type;
  final String value;
  final String label;
  _FilterPill(this.type, this.value, this.label);
}

class GameListController extends ChangeNotifier {
  static const spielelisteDownloadUrl =
      'Spieleliste.csv';
      // 'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";
  static const imprintPath = "assets/Imprint.md";
  static const privacyPath = "assets/Privacy.md";
  static const gameListCacheKey = 'spielwiesn_spielothek_spieleliste';
  static const favoritesCacheKey = 'spielwiesn_spielothek_favoriten';

  final csvGameListParser = CsvGameListParser();
  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();
  static const filterDebounceDuration = Duration(milliseconds: 200);
  static const int pageSize = 50;
  Timer? _filterDebounce;

  List<GameComplexityLevel> selectedComplexityLevels = [];
  List<GameCategory> selectedCategories = [];
  List<bool> selectedCoOp = [];
  List<bool> selectedExklusiv = [];
  List<bool> selectedNovelty = [];
  bool showOnlyFavorites = false;
  bool showFilters = true;

  List<Game> _games = [];
  final List<Game> _favoriteGames = [];
  List<Game> filteredGames = [];
  List<Game> visibleGames = [];
  int _visibleCount = 0;
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
    csvString = _sanitizeCsv(csvString);
    _games = await compute(_parseGames, csvString);
    filteredGames = List.from(_games);
    _resetVisibleGames();
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

  String _sanitizeCsv(String csv) {
    if (csv.startsWith('\uFEFF')) {
      csv = csv.substring(1);
    }
    return csv.replaceAll('\r\n', '\n');
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

  void _setupListeners() {
    nameController.addListener(_scheduleFilter);
    playersController.addListener(_scheduleFilter);
    durationController.addListener(_scheduleFilter);
  }

  void filterGames() {
    filteredGames = _games.where((game) {
      if (showOnlyFavorites && !game.favorite) return false;
      if (selectedCoOp.isNotEmpty && !selectedCoOp.contains(game.cooperative)) {
        return false;
      }
      if (selectedExklusiv.isNotEmpty && !selectedExklusiv.contains(game.exklusiv)) {
        return false;
      }
      if (selectedNovelty.isNotEmpty && !selectedNovelty.contains(game.novelty)) {
        return false;
      }
      return _matchesName(game) &&
          _matchesPlayers(game) &&
          _matchesDuration(game) &&
          _matchesComplexity(game) &&
          _matchesCategory(game);
    }).toList();
    _resetVisibleGames();
    notifyListeners();
  }

  void _scheduleFilter() {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(filterDebounceDuration, filterGames);
  }

  void _resetVisibleGames() {
    _visibleCount = filteredGames.length < pageSize
        ? filteredGames.length
        : pageSize;
    visibleGames = filteredGames.take(_visibleCount).toList();
  }

  void loadMore() {
    if (_visibleCount >= filteredGames.length) return;
    final nextCount = (_visibleCount + pageSize) > filteredGames.length
        ? filteredGames.length
        : (_visibleCount + pageSize);
    visibleGames = filteredGames.take(nextCount).toList();
    _visibleCount = nextCount;
    notifyListeners();
  }

  bool _matchesName(Game game) {
    String name = nameController.text.trim().toLowerCase();
    return name.isEmpty ||
        game.searchableLower.contains(name);
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

  bool _matchesCategory(Game game) =>
      selectedCategories.isEmpty ||
      selectedCategories.contains(game.category);

  bool _matchesComplexity(Game game) =>
      selectedComplexityLevels.isEmpty ||
      selectedComplexityLevels.contains(game.complexityLevel);

  bool _matchesBool(List<bool> selectedValues, bool value) =>
      selectedValues.isEmpty || selectedValues.contains(value);

  List<_FilterPill> get activeFilterPills {
    final List<_FilterPill> pills = [];

    // Categories (one pill per selected category when not all are selected)
    if (selectedCategories.isNotEmpty &&
        selectedCategories.length < GameCategory.values.length) {
      for (var c in selectedCategories) {
        pills.add(_FilterPill('category', c.name, 'Kategorie: ${c.name}'));
      }
    }

    // Complexity levels
    if (selectedComplexityLevels.isNotEmpty &&
        selectedComplexityLevels.length < GameComplexityLevel.values.length) {
      for (var l in selectedComplexityLevels) {
        pills.add(_FilterPill('complexity', l.displayName, 'Komplexität: ${l.displayName}'));
      }
    }

    // Co-Op / Premium / Novelty (boolean multi-select) - show pills for selected specific values if reduced
    if (selectedCoOp.contains(true)) {
      pills.add(_FilterPill('co_op', 'true', 'Koop'));
    }

    if (selectedExklusiv.contains(true)) {
      pills.add(_FilterPill('exklusiv', 'true', 'Exklusiv'));
    }

    if (selectedNovelty.contains(true)) {
      pills.add(_FilterPill('novelty', 'true', 'Neuheit'));
    }

    // Favorites
    if (showOnlyFavorites) {
      pills.add(_FilterPill('favorite', 'Favoriten', 'Favoriten'));
    }

    // Players and duration
    if (playersController.text.trim().isNotEmpty) {
      final value = playersController.text.trim();
      pills.add(_FilterPill('players', value, 'Spieler: $value'));
    }
    if (durationController.text.trim().isNotEmpty) {
      final value = durationController.text.trim();
      pills.add(_FilterPill('duration', value, 'Dauer: ${value} min'));
    }

    return pills;
  }

  bool get hasActiveFilters => activeFilterPills.isNotEmpty;

  void applyFilterSelections({
    required List<GameCategory> categories,
    required List<GameComplexityLevel> complexities,
    required bool coopOnly,
    required bool exklusivOnly,
    required bool noveltyOnly,
    required bool favoritesOnly,
  }) {
    selectedCategories = List.from(categories);
    selectedComplexityLevels = List.from(complexities);
    selectedCoOp = coopOnly ? [true] : [];
    selectedExklusiv = exklusivOnly ? [true] : [];
    selectedNovelty = noveltyOnly ? [true] : [];
    showOnlyFavorites = favoritesOnly;
    filterGames();
  }

  void removeFilterPill(_FilterPill pill) {
    switch (pill.type) {
      case 'category':
        final match = GameCategory.values
            .firstWhere((c) => c.name == pill.value, orElse: () => GameCategory.unknown);
        if (selectedCategories.contains(match)) {
          selectedCategories.remove(match);
        }
        break;
      case 'complexity':
        final match = GameComplexityLevel.values
            .firstWhere((l) => l.displayName == pill.value, orElse: () => GameComplexityLevel.simple);
        if (selectedComplexityLevels.contains(match)) {
          selectedComplexityLevels.remove(match);
        }
        break;
      case 'co_op':
        final b = pill.value.toLowerCase() == 'true';
        if (selectedCoOp.contains(b)) selectedCoOp.remove(b);
        break;
      case 'exklusiv':
        final b = pill.value.toLowerCase() == 'true';
        if (selectedExklusiv.contains(b)) selectedExklusiv.remove(b);
        break;
      case 'novelty':
        final b = pill.value.toLowerCase() == 'true';
        if (selectedNovelty.contains(b)) selectedNovelty.remove(b);
        break;
      case 'favorite':
        showOnlyFavorites = false;
        break;
      case 'players':
        playersController.clear();
        break;
      case 'duration':
        durationController.clear();
        break;
    }
    filterGames();
    notifyListeners();
  }

  void clearAllFilters() {
    selectedComplexityLevels = [];
    selectedCategories = [];
    selectedCoOp = [];
    selectedExklusiv = [];
    selectedNovelty = [];
    showOnlyFavorites = false;
    playersController.clear();
    durationController.clear();
    filterGames();
    notifyListeners();
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

  void toggleExklusiv(bool value) {
    if (selectedExklusiv.contains(value)) {
      selectedExklusiv.remove(value);
    } else {
      selectedExklusiv.add(value);
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

  void toggleFilters() {
    showFilters = !showFilters;
    notifyListeners();
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
    _filterDebounce?.cancel();
    nameController.dispose();
    playersController.dispose();
    durationController.dispose();
    super.dispose();
  }
}

List<Game> _parseGames(String csvString) {
  final parser = CsvGameListParser();
  return parser.parseCsv(csvString);
}
