import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../getIt.dart';
import '../utils/shared_preferences_wrapper.dart';

class GameCsvClient {
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";

  final _sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();

  Future<String> get gamesCsv async {
    try {
      http.Response response =
          await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        String csv = utf8.decode(response.bodyBytes);
        await _sharedPreferencesWrapper.setGamesCsv(csv);
        return csv;
      }
    } catch (e) {
      stderr.writeln("Error while trying to download latest game csv: $e");
    }
    String? cachedCsv = await _sharedPreferencesWrapper.gamesCsv;
    if (cachedCsv != null && cachedCsv.isNotEmpty) {
      return cachedCsv;
    }
    return rootBundle.loadString(csvPath);
  }
}
