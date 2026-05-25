import 'dart:io';

import 'package:spielwiesn_spielothek/game/game_csv_client.dart';

import '../assets/test_spieleliste.dart';

class GameCsvClientMock implements GameCsvClient {
  String source = TestSpieleliste.csvPath;
  Object? errorThatShouldBeThrown;

  @override
  Future<String> get gamesCsv {
    if (errorThatShouldBeThrown != null) {
      throw errorThatShouldBeThrown!;
    }
    return File(source).readAsString();
  }

  @override
  Future<String> updateFromSource() => gamesCsv;
}
