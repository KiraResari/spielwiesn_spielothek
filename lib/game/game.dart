import 'game_category.dart';
import 'inventory_type.dart';
import 'material_type.dart';

class Game {
  final String name;
  final int copiesOwned;
  final String inventoryLetter;
  final InventoryType inventoryType;
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

  Game({
    required this.name,
    required this.copiesOwned,
    required this.inventoryLetter,
    required this.inventoryType,
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
}
