import 'package:spielwiesn_spielothek/utils/shared_preferences_wrapper.dart';

class SharedPreferencesWrapperMock implements SharedPreferencesWrapper {
  String? _gamesCsv;
  List<String> _favIds = [];

  @override
  Future<String?> get gamesCsv async => _gamesCsv;

  @override
  Future<void> setGamesCsv(String gamesCsv) async {
    _gamesCsv = gamesCsv;
  }

  @override
  Future<List<String>> get favIds async => _favIds;

  @override
  Future<void> setFavIds(List<String> favIds) async {
    _favIds = favIds;
  }
}
