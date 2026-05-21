import 'package:get_it/get_it.dart';

import 'game/game_repository.dart';
import 'utils/shared_preferences_wrapper.dart';

final getIt = GetIt.instance;

void initialiazeGetItContext(){
  getIt.registerSingleton(SharedPreferencesWrapper());
  getIt.registerSingleton(GameRepository());
}