import '../getIt.dart';
import '../utils/shared_preferences_wrapper.dart';
import 'game.dart';
import 'game_provider.dart';

class GameRepository {
  final sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();
  final provider = getIt.get<GameProvider>();

  List<Game> _games = [];
  final List<Game> _favoriteGames = [];

  List<Game> get games => _games;

  Future<void> initialize() async {
    _games = await provider.games;
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<String> cachedFavIds = await sharedPreferencesWrapper.favIds;
    _favoriteGames.clear();
    for (String cachedFavId in cachedFavIds) {
      for (Game game in _games) {
        if (game.identifier == cachedFavId) {
          game.favorite = true;
          _favoriteGames.add(game);
        }
      }
    }
  }

  Future<void> toggleFavorite(Game game) async {
    game.favorite = !game.favorite;
    _favoriteGames.contains(game)
        ? _favoriteGames.remove(game)
        : _favoriteGames.add(game);
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    List<String> identifiers = _favoriteGames.map((g) => g.identifier).toList();
    await sharedPreferencesWrapper.setFavIds(identifiers);
  }
}
