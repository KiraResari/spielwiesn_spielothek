import 'dart:async';

import 'package:flutter/material.dart';

import '../game/csv_game_list_parser.dart';
import '../game/game.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';
import '../game/game_repository.dart';
import '../getIt.dart';
import 'game_filter.dart';

class GameListViewController extends ChangeNotifier {
  static const imprintPath = "assets/Imprint.md";
  static const privacyPath = "assets/Privacy.md";

  final csvGameListParser = CsvGameListParser();
  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();
  final gameRepository = getIt<GameRepository>();
  static const filterDebounceDuration = Duration(milliseconds: 200);
  static const int pageSize = 50;
  Timer? _filterDebounce;

  List<GameComplexityLevel> selectedComplexityLevels = [];
  List<GameCategory> selectedCategories = [];
  List<bool> selectedCoOp = [];
  List<bool> selectedExclusive = [];
  List<bool> selectedNovelty = [];
  bool showOnlyFavorites = false;
  bool showFilters = true;

  List<Game> filteredGames = [];
  List<Game> visibleGames = [];
  int _visibleCount = 0;

  GameListViewController() {
    filteredGames = List.from(gameRepository.games);
    _setupListeners();
    _resetVisibleGames();
    notifyListeners();
  }

  void _setupListeners() {
    nameController.addListener(_scheduleFilter);
    playersController.addListener(_scheduleFilter);
    durationController.addListener(_scheduleFilter);
  }

  void applyFilters() {
    filteredGames = gameRepository.games.where((game) {
      if (showOnlyFavorites && !game.favorite) return false;
      if (selectedCoOp.isNotEmpty && !selectedCoOp.contains(game.cooperative)) {
        return false;
      }
      if (selectedExclusive.isNotEmpty &&
          !selectedExclusive.contains(game.exklusiv)) {
        return false;
      }
      if (selectedNovelty.isNotEmpty &&
          !selectedNovelty.contains(game.novelty)) {
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
    _filterDebounce = Timer(filterDebounceDuration, applyFilters);
  }

  void _resetVisibleGames() {
    _visibleCount =
        filteredGames.length < pageSize ? filteredGames.length : pageSize;
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
    return name.isEmpty || game.searchableLower.contains(name);
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
      selectedCategories.isEmpty || selectedCategories.contains(game.category);

  bool _matchesComplexity(Game game) =>
      selectedComplexityLevels.isEmpty ||
      selectedComplexityLevels.contains(game.complexityLevel);

  List<GameFilter> get activeFilters {
    List<GameFilter> activeFilters = [];

    if (selectedCategories.isNotEmpty &&
        selectedCategories.length < GameCategory.values.length) {
      for (var c in selectedCategories) {
        activeFilters
            .add(GameFilter('category', c.name, 'Kategorie: ${c.name}'));
      }
    }

    if (selectedComplexityLevels.isNotEmpty &&
        selectedComplexityLevels.length < GameComplexityLevel.values.length) {
      for (var l in selectedComplexityLevels) {
        activeFilters.add(GameFilter(
            'complexity', l.displayName, 'Komplexität: ${l.displayName}'));
      }
    }

    if (selectedCoOp.contains(true)) {
      activeFilters.add(GameFilter('co_op', 'true', 'Koop'));
    }

    if (selectedExclusive.contains(true)) {
      activeFilters.add(GameFilter('exklusiv', 'true', 'Exklusiv'));
    }

    if (selectedNovelty.contains(true)) {
      activeFilters.add(GameFilter('novelty', 'true', 'Neuheit'));
    }

    if (showOnlyFavorites) {
      activeFilters.add(GameFilter('favorite', 'Favoriten', 'Favoriten'));
    }

    if (playersController.text.trim().isNotEmpty) {
      final value = playersController.text.trim();
      activeFilters.add(GameFilter('players', value, 'Spieler: $value'));
    }
    if (durationController.text.trim().isNotEmpty) {
      final value = durationController.text.trim();
      activeFilters.add(GameFilter('duration', value, 'Dauer: $value min'));
    }

    return activeFilters;
  }

  bool get hasActiveFilters => activeFilters.isNotEmpty;

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
    selectedExclusive = exklusivOnly ? [true] : [];
    selectedNovelty = noveltyOnly ? [true] : [];
    showOnlyFavorites = favoritesOnly;
    applyFilters();
  }

  void clearAllFilters() {
    selectedComplexityLevels = [];
    selectedCategories = [];
    selectedCoOp = [];
    selectedExclusive = [];
    selectedNovelty = [];
    showOnlyFavorites = false;
    playersController.clear();
    durationController.clear();
    applyFilters();
    notifyListeners();
  }

  void toggleComplexity(GameComplexityLevel level) {
    if (selectedComplexityLevels.contains(level)) {
      selectedComplexityLevels.remove(level);
    } else {
      selectedComplexityLevels.add(level);
    }
    applyFilters();
  }

  void toggleCategory(GameCategory category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    applyFilters();
  }

  void toggleCoOp(bool value) {
    if (selectedCoOp.contains(value)) {
      selectedCoOp.remove(value);
    } else {
      selectedCoOp.add(value);
    }
    applyFilters();
  }

  void toggleExklusiv(bool value) {
    if (selectedExclusive.contains(value)) {
      selectedExclusive.remove(value);
    } else {
      selectedExclusive.add(value);
    }
    applyFilters();
  }

  void toggleNovelty(bool value) {
    if (selectedNovelty.contains(value)) {
      selectedNovelty.remove(value);
    } else {
      selectedNovelty.add(value);
    }
    applyFilters();
  }

  void clearField(TextEditingController controller) {
    controller.clear();
    applyFilters();
  }

  void toggleFilters() {
    showFilters = !showFilters;
    notifyListeners();
  }

  Future<void> toggleFavorite(Game game) async {
    await gameRepository.toggleFavorite(game);
    applyFilters();
    notifyListeners();
  }

  @override
  void dispose() {
    _filterDebounce?.cancel();
    nameController.dispose();
    playersController.dispose();
    durationController.dispose();
    super.dispose();
  }
}
