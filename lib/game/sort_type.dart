enum SortType{
  sticker(name: "Stickerbuchstabe"),
  alphabetic(name: "Alphabetisch"),
  rating(name: "Bewertung"),
  random(name: "Zufällig");

  final String name;

  const SortType({required this.name});
}