import 'game.dart';

abstract class GameRepository {
  Future<List<Game>> fetchGames();
}
