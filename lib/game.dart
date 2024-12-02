class Game {
  final String name;
  final int yearPublished;
  final int minPlayers;
  final int maxPlayers;
  final int minPlayTime;
  final int maxPlayTime;
  final double rating;

  Game({
    required this.name,
    required this.yearPublished,
    required this.minPlayers,
    required this.maxPlayers,
    required this.minPlayTime,
    required this.maxPlayTime,
    required this.rating,
  });
}
