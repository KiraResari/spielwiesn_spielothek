import 'package:get_it/get_it.dart';

import 'game/csv_game_list_parser.dart';
import 'game/game_provider.dart';
import 'game/game_repository.dart';
import 'utils/shared_preferences_wrapper.dart';

final getIt = GetIt.instance;

void initialiazeGetItContext(){
  getIt.registerSingleton(SharedPreferencesWrapper());
  getIt.registerSingleton(CsvGameListParser());
  getIt.registerSingleton(GameProvider());
  getIt.registerSingleton(GameRepository());
}