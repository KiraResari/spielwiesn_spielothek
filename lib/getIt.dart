import 'package:get_it/get_it.dart';

import 'game/game_repository.dart';

final getIt = GetIt.instance;

void initialiazeGetItContext(){
  getIt.registerSingleton(GameRepository());
}