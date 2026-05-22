import 'dart:io';

import 'package:spielwiesn_spielothek/game/game_csv_client.dart';

import '../assets/test_file_paths.dart';

class GameCsvClientMock implements GameCsvClient {
  @override
  Future<String> get gamesCsv => File(TestFilePaths.testCsvPath).readAsString();
}
