enum GameCategory {
  unknown(name: "Unbekannt"),
  family(name: "Familie"),
  skill(name: "Geschick"),
  party(name: "Party"),
  quiz(name: "Quiz"),
  mystery(name: "Rätsel"),
  strategy(name: "Strategie");

  final String name;

  const GameCategory({required this.name});

  factory GameCategory.fromName(String name){
    return values.firstWhere(
          (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }

  static  List<GameCategory> get filterOrder => [
    GameCategory.family,
    GameCategory.strategy,
    GameCategory.skill,
    GameCategory.party,
    GameCategory.quiz,
    GameCategory.mystery,
  ];
}
