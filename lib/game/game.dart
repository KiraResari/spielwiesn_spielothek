import 'game_category.dart';
import 'game_complexity_level.dart';
import 'sticker_type.dart';
import 'material_type.dart';

class Game {
  final String name;
  final String searchAnchors;
  final int copiesOwned;
  final String stickerLetter;
  final StickerType stickerType;
  final GameCategory category;
  final MaterialType materialType;
  final double rating;
  final int yearPublished;
  final int minPlayers;
  final int maxPlayers;
  final int minPlayTime;
  final int maxPlayTime;
  final int minAge;
  final double complexity;
  final bool cooperative;
  final bool novelty;
  final bool premium;
  final String link;

  bool favorite = false;

  Game({
    required this.name,
    this.searchAnchors = "",
    required this.copiesOwned,
    required this.stickerLetter,
    required this.stickerType,
    required this.category,
    required this.materialType,
    required this.rating,
    required this.yearPublished,
    required this.minPlayers,
    required this.maxPlayers,
    required this.minPlayTime,
    required this.maxPlayTime,
    required this.minAge,
    required this.complexity,
    required this.cooperative,
    required this.novelty,
    required this.premium,
    required this.link,
  });

  String get nameAndSearchAnchors => "$name $searchAnchors";

  GameComplexityLevel get complexityLevel {
    if (complexity <= 1) {
      return GameComplexityLevel.verySimple;
    } else if (complexity <= 2) {
      return GameComplexityLevel.simple;
    } else if (complexity <= 3) {
      return GameComplexityLevel.moderate;
    } else if (complexity <= 4) {
      return GameComplexityLevel.complex;
    }
    return GameComplexityLevel.veryComplex;
  }

  String get identifier => "$name$yearPublished$stickerType";
}
