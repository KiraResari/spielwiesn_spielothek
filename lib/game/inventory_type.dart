enum InventoryType {
  unknown(name: "Unbekannt"),
  cards(name: "Karten"),
  child(name: "Kind"),
  normal(name: "Normal"),
  two(name: "Zwei");

  final String name;

  const InventoryType({required this.name});

  factory InventoryType.fromName(String name){
    return values.firstWhere(
          (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => unknown,
    );
  }
}
