import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/game/csv_game_respository.dart';
import 'package:spielwiesn_spielothek/game/game.dart';

main (){
  TestWidgetsFlutterBinding.ensureInitialized();

  test("parsing Spieleliste should work",
      () async {
        var repository = CsvGameRepository('assets/Spieleliste.csv');

        List<Game> games = await repository.fetchGames();

        expect(games, isNotEmpty);
      }
  );
}