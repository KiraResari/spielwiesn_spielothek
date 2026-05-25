import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/game/csv_game_list_parser.dart';
import 'package:spielwiesn_spielothek/game/game.dart';
import 'package:spielwiesn_spielothek/game/game_category.dart';
import 'package:spielwiesn_spielothek/game/game_complexity_level.dart';
import 'package:spielwiesn_spielothek/game/game_csv_client.dart';
import 'package:spielwiesn_spielothek/game/game_repository.dart';
import 'package:spielwiesn_spielothek/game_list_view/game_list_view_controller.dart';
import 'package:spielwiesn_spielothek/get_it_context.dart';
import 'package:spielwiesn_spielothek/utils/shared_preferences_wrapper.dart';

import '../assets/test_spieleliste.dart';
import '../mocks/game_csv_client_mock.dart';
import '../mocks/shared_preferences_wrapper_mock.dart';

void main() {
  late GameListViewController controller;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<GameCsvClient>(GameCsvClientMock());
    getIt.registerSingleton<SharedPreferencesWrapper>(
        SharedPreferencesWrapperMock());
    getIt.registerSingleton(CsvGameListParser());
    var repository = GameRepository();
    await repository.initialize();
    getIt.registerSingleton(repository);
    controller = GameListViewController();
  });

  test("applyFilters should not change game count if no filters are set", () {
    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.gamesCount));
  });

  test("filtering for category should return correct game count", () {
    controller.selectedCategories = [GameCategory.family];

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.familyGamesCount));
  });

  test("filtering for complexity should return correct game count", () {
    controller.selectedComplexityLevels = [GameComplexityLevel.veryComplex];

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.veryComplexGamesCount));
  });

  test("filtering for co-op should return correct game count", () {
    controller.selectedCoOp = [true];

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.coOpGamesCount));
  });

  test("filtering for exclusive should return correct game count", () {
    controller.selectedExclusive = [true];

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.exclusiveGamesCount));
  });

  test("filtering for novelty should return correct game count", () {
    controller.selectedNovelty = [true];

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.noveltyGamesCount));
  });

  test("filtering for favorites should only return favorite games", () async {
    Game game = controller.filteredGames.first;
    controller.showOnlyFavorites = true;

    await controller.toggleFavorite(game);

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(1));
    expect(games.first, equals(game));
  });

  test("filtering for name should return correct game count", () {
    controller.nameController.text = "catan";

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.catanGamesCount));
  });

  test("filtering for player count should return correct game count", () {
    controller.playersController.text = "9";

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.ninePlayerGamesCount));
  });

  test("filtering for play time should return correct game count", () {
    controller.durationController.text = "5";

    controller.applyFilters();

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.fiveMinuteGamesCount));
  });

  test("activeFilterCount should be correct", () {
    controller.selectedComplexityLevels = [
      GameComplexityLevel.veryComplex,
      GameComplexityLevel.simple,
    ];
    controller.durationController.text = "5";
    controller.showOnlyFavorites = true;

    int activeFilterCount = controller.activeFilterCount;

    expect(activeFilterCount, equals(4));
  });

  test(
    "activeFilterCount should not count complexity or category if all options are set",
    () {
      controller.selectedComplexityLevels = GameComplexityLevel.values;
      controller.selectedCategories = GameCategory.values;

      int activeFilterCount = controller.activeFilterCount;

      expect(activeFilterCount, equals(0));
    },
  );

  test("hasActiveFilters should be false if no filters are set", () {
    bool hasActiveFilters = controller.hasActiveFilters;

    expect(hasActiveFilters, isFalse);
  });

  test("hasActiveFilters should be true if at least one filter is set", () {
    controller.showOnlyFavorites = true;

    bool hasActiveFilters = controller.hasActiveFilters;

    expect(hasActiveFilters, isTrue);
  });

  test("clearAllFilters should disable all filters", () {
    controller.durationController.text = "5";
    controller.showOnlyFavorites = true;

    controller.clearAllFilters();

    bool hasActiveFilters = controller.hasActiveFilters;
    expect(hasActiveFilters, isFalse);
  });

  test(
    "toggleComplexity should add complexity level to filters if it's not selected",
    () {
      var complexityLevel = GameComplexityLevel.moderate;
      controller.toggleComplexity(complexityLevel);

      expect(controller.selectedComplexityLevels, contains(complexityLevel));
    },
  );

  test(
    "toggleComplexity should remove complexity level from filters if it's already selected",
    () {
      var complexityLevel = GameComplexityLevel.moderate;
      controller.selectedComplexityLevels = [complexityLevel];
      controller.toggleComplexity(complexityLevel);

      expect(
        controller.selectedComplexityLevels,
        isNot(contains(complexityLevel)),
      );
    },
  );

  test("toggleCategory should add category to filters if it's not selected",
      () {
    var category = GameCategory.strategy;
    controller.toggleCategory(category);

    expect(controller.selectedCategories, contains(category));
  });

  test(
    "toggleCategory should remove category  from filters if it's already selected",
    () {
      var category = GameCategory.strategy;
      controller.selectedCategories = [category];
      controller.toggleCategory(category);

      expect(controller.selectedCategories, isNot(contains(category)));
    },
  );

  test("clearField should disable selected filter field", () {
    controller.durationController.text = "5";
    controller.applyFilters();

    controller.clearField(controller.durationController);

    List<Game> games = controller.filteredGames;
    expect(games.length, equals(TestSpieleliste.gamesCount));
  });
}
