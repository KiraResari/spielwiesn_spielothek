import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../spielwiesn_context.dart';
import '../utils/shared_preferences_wrapper.dart';

class GameCsvClient {
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";

  final _sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();

  Future<String> get gamesCsv async {
    try {
      talker.info(
          "Trying to download latest games csv from $spielelisteDownloadUrl");
      http.Response response =
          await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        String csv = utf8.decode(response.bodyBytes);
        await _sharedPreferencesWrapper.setGamesCsv(csv);
        talker.info(
            "Successfully downloaded latest games csv from $spielelisteDownloadUrl");
        return csv;
      }
    } catch (e) {
      talker.error("Error while trying to download latest games csv", e);
    }
    talker.info("Checking if cached games csv exists");
    String? cachedCsv = await _sharedPreferencesWrapper.gamesCsv;
    if (cachedCsv != null && cachedCsv.isNotEmpty) {
      talker.info("Cached games csv found");
      return cachedCsv;
    }
    talker.info("Cached games csv not found; using static fallback list");
    return rootBundle.loadString(csvPath);
  }
}
