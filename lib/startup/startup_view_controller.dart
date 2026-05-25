import 'package:flutter/foundation.dart';

import '../game/game_repository.dart';
import '../spielwiesn_context.dart';

class StartupViewController extends ChangeNotifier {
  final gameRepository = getIt<GameRepository>();

  StartupViewController(Future<void> Function() navigateToGameListView) {
    _initializeRepositoriesAndContinue(navigateToGameListView);
  }

  String get displayText => "Spiele werden geladen...";

  Future<void> _initializeRepositoriesAndContinue(
    Future<void> Function() navigateToGameListView,
  ) async {
    await gameRepository.initialize();
    await navigateToGameListView();
  }
}
