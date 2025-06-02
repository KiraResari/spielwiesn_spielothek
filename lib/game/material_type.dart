enum MaterialType {
  unknown(name: "Unknown"),
  app(name: "App"),
  board(name: "Brett"),
  cards(name: "Karten"),
  material(name: "Material"),
  tiles(name: "Plaettchen"),
  storybook(name: "Storybook"),
  tableau(name: "Tableau"),
  dice(name: "Wuerfel");

  final String name;

  const MaterialType({required this.name});

  factory MaterialType.fromName(String name){
    return values.firstWhere(
          (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }
}
