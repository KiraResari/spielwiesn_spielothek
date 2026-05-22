import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/game/csv_game_list_parser.dart';
import 'package:spielwiesn_spielothek/game/game.dart';
import 'package:spielwiesn_spielothek/game/game_csv_client.dart';
import 'package:spielwiesn_spielothek/game/game_repository.dart';
import 'package:spielwiesn_spielothek/getIt.dart';
import 'package:spielwiesn_spielothek/utils/shared_preferences_wrapper.dart';

import '../mocks/game_csv_client_mock.dart';
import '../mocks/shared_preferences_wrapper_mock.dart';

void main() {
  late GameRepository repository;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<GameCsvClient>(GameCsvClientMock());
    getIt.registerSingleton<SharedPreferencesWrapper>(
        SharedPreferencesWrapperMock());
    getIt.registerSingleton(CsvGameListParser());
    repository = GameRepository();
    await repository.initialize();
  });

  test("games should return correct game count", () {
    List<Game> games = repository.games;

    expect(games.length, equals(1813));
  });
}
