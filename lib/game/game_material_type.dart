enum GameMaterialType {
  unknown(name: "Unbekannt", emoji: "❓"),
  app(name: "App", emoji: "📱"),
  board(name: "Brett", emoji: "🗺️"),
  cards(name: "Karten", emoji: "🎴"),
  material(name: "Material", emoji: "🧩"),
  tiles(name: "Plättchen", emoji: "▦"),
  storybook(name: "Storybook", emoji: "📖"),
  tableau(name: "Tableau", emoji: "🖼️"),
  dice(name: "Würfel", emoji: "🎲");

  final String name;
  final String emoji;

  const GameMaterialType({required this.name, required this.emoji});

  factory GameMaterialType.fromName(String name){
    return values.firstWhere(
          (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }

  static  List<GameMaterialType> get filterOrder => [
    GameMaterialType.board,
    GameMaterialType.tableau,
    GameMaterialType.cards,
    GameMaterialType.dice,
    GameMaterialType.tiles,
    GameMaterialType.material,
    GameMaterialType.storybook,
    GameMaterialType.app,
  ];

  String get nameAndEmoji => "$name $emoji";
}
