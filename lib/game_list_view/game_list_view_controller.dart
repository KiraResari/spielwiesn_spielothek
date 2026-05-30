import 'dart:async';

import 'package:flutter/material.dart';

import '../game/csv_game_list_parser.dart';
import '../game/game.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';
import '../game/game_material_type.dart';
import '../game/game_repository.dart';
import '../game/sort_type.dart';
import '../game/sticker_type.dart';
import '../spielwiesn_context.dart';

class GameListViewController extends ChangeNotifier {
  static const imprintPath = "assets/Imprint.md";
  static const privacyPath = "assets/Privacy.md";
  static const updateSuccessMessage = "Spieleliste aktualisiert";
  static const updateFailedMessage =
      "Fehler beim Aktualisieren der Spieleliste";
  static const filterDebounceDuration = Duration(milliseconds: 200);
  static const int pageSize = 50;

  final csvGameListParser = CsvGameListParser();
  final nameController = TextEditingController();
  final playersController = TextEditingController();
  final durationController = TextEditingController();
  final minAgeController = TextEditingController();
  final gameRepository = getIt<GameRepository>();

  final void Function(String message) showSnackBar;
  final void Function(String message) showErrorSnackBar;

  Timer? _filterDebounce;
  List<GameComplexityLevel> selectedComplexityLevels = [];
  List<GameCategory> selectedCategories = [];
  List<StickerType> selectedStickerTypes = [];
  List<GameMaterialType> selectedMaterialTypes = [];
  List<bool> selectedCoOp = [];
  List<bool> selectedExclusive = [];
  List<bool> selectedNovelty = [];
  bool showOnlyFavorites = false;
  bool showFilters = true;
  bool _isUpdating = false;
  SortType _sortType = SortType.sticker;

  List<Game> filteredGames = [];
  List<Game> visibleGames = [];
  int _visibleCount = 0;

  GameListViewController({
    required this.showSnackBar,
    required this.showErrorSnackBar,
  }) {
    filteredGames = List.from(gameRepository.games);
    _setupListeners();
    _resetVisibleGames();
    notifyListeners();
  }

  void _setupListeners() {
    nameController.addListener(_scheduleFilter);
    playersController.addListener(_scheduleFilter);
    durationController.addListener(_scheduleFilter);
    minAgeController.addListener(_scheduleFilter);
  }

  void _scheduleFilter() {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(filterDebounceDuration, applyFilters);
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
      if (selectedStickerTypes.isNotEmpty &&
          !selectedStickerTypes.contains(game.stickerType)) {
        return false;
      }
      if (selectedMaterialTypes.isNotEmpty &&
          !selectedMaterialTypes.contains(game.materialType)) {
        return false;
      }
      return _matchesName(game) &&
          _matchesPlayers(game) &&
          _matchesDuration(game) &&
          _matchesMinAge(game) &&
          _matchesComplexity(game) &&
          _matchesCategory(game);
    }).toList();
    _sortResults();
    _resetVisibleGames();
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

  bool _matchesMinAge(Game game) {
    int? minAge = int.tryParse(minAgeController.text.trim());
    return minAge == null || (game.minAge >= minAge);
  }

  bool _matchesCategory(Game game) =>
      selectedCategories.isEmpty || selectedCategories.contains(game.category);

  bool _matchesComplexity(Game game) =>
      selectedComplexityLevels.isEmpty ||
      selectedComplexityLevels.contains(game.complexityLevel);

  void _sortResults() {
    switch (_sortType) {
      case SortType.sticker:
        _sortByName();
        _sortByStickerLetter();
        break;

      case SortType.alphabetic:
        _sortByName();
        break;

      case SortType.rating:
        _sortByName();
        _sortByRating();
        break;

      case SortType.random:
        filteredGames.shuffle();
        break;
    }
  }

  void _sortByStickerLetter() =>
      filteredGames.sort((a, b) => a.stickerLetter.compareTo(b.stickerLetter));

  void _sortByName() => filteredGames.sort((a, b) => a.name.compareTo(b.name));

  void _sortByRating() =>
      filteredGames.sort((a, b) => b.rating.compareTo(a.rating));

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

  int get activeFilterCount {
    int count = 0;
    if (selectedCategories.isNotEmpty &&
        selectedCategories.length < GameCategory.values.length) {
      count += selectedCategories.length;
    }
    if (selectedComplexityLevels.isNotEmpty &&
        selectedComplexityLevels.length < GameComplexityLevel.values.length) {
      count += selectedComplexityLevels.length;
    }
    if (selectedStickerTypes.isNotEmpty &&
        selectedStickerTypes.length < StickerType.values.length) {
      count += selectedStickerTypes.length;
    }
    if (selectedMaterialTypes.isNotEmpty &&
        selectedMaterialTypes.length < GameMaterialType.values.length) {
      count += selectedMaterialTypes.length;
    }
    if (selectedCoOp.contains(true)) count++;
    if (selectedExclusive.contains(true)) count++;
    if (selectedNovelty.contains(true)) count++;
    if (showOnlyFavorites) count++;
    if (playersController.text.trim().isNotEmpty) count++;
    if (durationController.text.trim().isNotEmpty) count++;
    if (minAgeController.text.trim().isNotEmpty) count++;
    return count;
  }

  bool get hasActiveFilters => activeFilterCount > 0;

  void clearAllFilters() {
    selectedComplexityLevels = [];
    selectedCategories = [];
    selectedCoOp = [];
    selectedExclusive = [];
    selectedNovelty = [];
    selectedStickerTypes = [];
    selectedMaterialTypes = [];
    showOnlyFavorites = false;
    playersController.clear();
    durationController.clear();
    minAgeController.clear();
    applyFilters();
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

  void toggleStickerType(StickerType stickerType) {
    if (selectedStickerTypes.contains(stickerType)) {
      selectedStickerTypes.remove(stickerType);
    } else {
      selectedStickerTypes.add(stickerType);
    }
    applyFilters();
  }

  void toggleMaterialType(GameMaterialType materialType) {
    if (selectedMaterialTypes.contains(materialType)) {
      selectedMaterialTypes.remove(materialType);
    } else {
      selectedMaterialTypes.add(materialType);
    }
    applyFilters();
  }

  void clearField(TextEditingController controller) {
    controller.clear();
    applyFilters();
  }

  Future<void> toggleFavorite(Game game) async {
    await gameRepository.toggleFavorite(game);
    applyFilters();
  }

  Future<void> updateSource() async {
    try {
      isUpdating = true;
      await gameRepository.updateSource();
      applyFilters();
      showSnackBar(updateSuccessMessage);
    } catch (e) {
      talker.error("Error while trying to update games", e);
      showErrorSnackBar(updateFailedMessage);
    }
    isUpdating = false;
  }

  bool get isUpdating => _isUpdating;

  set isUpdating(bool targetValue) {
    _isUpdating = targetValue;
    notifyListeners();
  }

  SortType get sortType => _sortType;

  void setSortType(SortType sortType) {
    _sortType = sortType;
    applyFilters();
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
