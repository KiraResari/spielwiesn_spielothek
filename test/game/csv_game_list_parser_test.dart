import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/game/csv_game_list_parser.dart';
import 'package:spielwiesn_spielothek/game/game.dart';

main (){
  TestWidgetsFlutterBinding.ensureInitialized();

  test("parsing full Spieleliste should work",
      () async {
        var repository = CsvGameListParser();
        final csvString = await rootBundle.loadString('assets/Spieleliste.csv');

        List<Game> games = repository.parseCsv(csvString);

        expect(games, isNotEmpty);
      }
  );

  test("parsing game without sticker letter should result in Game object with stickerLetter question mark",
          () async {
        var repository = CsvGameListParser();

        List<Game> games = repository.parseCsv("Die Trödler aus den Highlands,,1,,Normal,Familie,Brett,6,2024,2,4,30,45,10,2,,,,https://boardgamegeek.com/boardgame/428578/die-trodler-aus-den-highlands");

        Game parsedGame = games.first;
        expect(parsedGame.stickerLetter, equals("?"));
      }
  );
}