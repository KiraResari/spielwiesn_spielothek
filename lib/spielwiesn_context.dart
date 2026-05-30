import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'game/csv_game_list_parser.dart';
import 'game/game_csv_client.dart';
import 'game/game_repository.dart';
import 'utils/shared_preferences_wrapper.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();

void initializeContext(){
  getIt.registerSingleton(SharedPreferencesWrapper());
  getIt.registerSingleton(CsvGameListParser());
  getIt.registerSingleton(GameCsvClient());
  getIt.registerSingleton(GameRepository());
}
