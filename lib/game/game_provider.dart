import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../getIt.dart';
import '../utils/shared_preferences_wrapper.dart';
import 'csv_game_list_parser.dart';
import 'game.dart';

class GameProvider{
  static const spielelisteDownloadUrl =
      'http://www.tri-tail.com/Spielwiesn/Spieleliste.csv';
  static const csvPath = "assets/Spieleliste.csv";

  final sharedPreferencesWrapper = getIt.get<SharedPreferencesWrapper>();
  final parser = getIt.get<CsvGameListParser>();

  Future<List<Game>> get games async {
    String csvString = await _getGamesCsv();
    csvString = _sanitizeCsv(csvString);
    return await compute(parser.parseCsv, csvString);
  }

  Future<String> _getGamesCsv() async {
    try {
      http.Response response =
      await http.get(Uri.parse(spielelisteDownloadUrl));

      if (response.statusCode == 200) {
        String csv = utf8.decode(response.bodyBytes);
        await sharedPreferencesWrapper.setGamesCsv(csv);
        return csv;
      }
    } catch (e) {
      stderr.writeln("Error while trying to download latest game csv: $e");
    }
    String? cachedCsv = await sharedPreferencesWrapper.gamesCsv;
    if (cachedCsv != null && cachedCsv.isNotEmpty) {
      return cachedCsv;
    }
    return rootBundle.loadString(csvPath);
  }

  String _sanitizeCsv(String csv) {
    if (csv.startsWith('\uFEFF')) {
      csv = csv.substring(1);
    }
    return csv.replaceAll('\r\n', '\n');
  }
}
