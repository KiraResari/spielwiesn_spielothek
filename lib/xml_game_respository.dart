import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

import 'game.dart';
import 'game_repository.dart';

class XmlGameRepository implements GameRepository {
  final String xmlPath;

  XmlGameRepository(this.xmlPath);

  @override
  Future<List<Game>> fetchGames() async {
    final String xmlString = await rootBundle.loadString(xmlPath);
    final XmlDocument xmlDoc = XmlDocument.parse(xmlString);

    return xmlDoc.findAllElements('item').map((item) {
      try {
        String name = item.findElements('name').first.innerText;
        String yearPublishedText = item.findElements('yearpublished').first.innerText;
        int yearPublished = int.parse(yearPublishedText);
        XmlElement stats = item.findElements('stats').first;
        String? minPlayersText = stats.getAttribute('minplayers');
        int minPlayers = int.parse(minPlayersText?? "0");
        String? maxPlayersText = stats.getAttribute('maxplayers');
        int maxPlayers = int.parse(maxPlayersText?? "0");
        String? minPlayTimeText = stats.getAttribute('minplaytime');
        int minPlayTime = int.parse(minPlayTimeText?? "0");
        String? maxPlayTimeText = stats.getAttribute('maxplaytime');
        int maxPlayTime = int.parse(maxPlayTimeText?? "0");
        XmlElement ratingNode = stats.findElements("rating").first;
        String? ratingText = ratingNode.findElements('average').first.getAttribute('value');
        double rating = double.parse(ratingText?? "0");
        return Game(
          name: name,
          yearPublished: yearPublished,
          minPlayers: minPlayers,
          maxPlayers: maxPlayers,
          minPlayTime: minPlayTime,
          maxPlayTime: maxPlayTime,
          rating: rating,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing item: $e');
        }
        return null;
      }
    }).whereType<Game>().toList();
  }
}
