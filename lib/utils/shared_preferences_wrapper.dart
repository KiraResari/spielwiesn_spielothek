import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWrapper{
  static const gameListCacheKey = 'spielwiesn_spielothek_spieleliste';
  static const favoritesCacheKey = 'spielwiesn_spielothek_favoriten';

  Future<String?> get gamesCsv  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gameListCacheKey);
  }

  Future<void> setGamesCsv(String gamesCsv) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(gameListCacheKey, gamesCsv);
  }

  Future<List<String>> get favIds  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoritesCacheKey) ?? [];
  }

  Future<void> setFavIds(List<String> favIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoritesCacheKey, favIds);
  }
}
