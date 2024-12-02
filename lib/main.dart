import 'package:flutter/material.dart';
import 'xml_game_respository.dart';
import 'game.dart';
import 'game_repository.dart';

void main() {
  runApp(BoardGameApp());
}

class BoardGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Game Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: GameFilterScreen(
        repository: XmlGameRepository('assets/Spieleliste.xml'),
      ),
    );
  }
}

class GameFilterScreen extends StatefulWidget {
  final GameRepository repository;

  const GameFilterScreen({Key? key, required this.repository}) : super(key: key);

  @override
  _GameFilterScreenState createState() => _GameFilterScreenState();
}

class _GameFilterScreenState extends State<GameFilterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController playersController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  List<Game> games = [];
  List<Game> filteredGames = [];

  @override
  void initState() {
    super.initState();
    widget.repository.fetchGames().then((loadedGames) {
      setState(() {
        games = loadedGames;
        filteredGames = games;
      });
    });
  }

  void filterGames() {
    setState(() {
      filteredGames = games.where((game) {
        final name = nameController.text.trim().toLowerCase();
        final players = int.tryParse(playersController.text.trim());
        final duration = int.tryParse(durationController.text.trim());
        final year = int.tryParse(yearController.text.trim());
        final rating = double.tryParse(ratingController.text.trim());

        final matchesName = name.isEmpty || game.name.toLowerCase().contains(name);
        final matchesPlayers = players == null ||
            (players >= game.minPlayers && players <= game.maxPlayers);
        final matchesDuration = duration == null ||
            (duration >= game.minPlayTime && duration <= game.maxPlayTime);
        final matchesYear = year == null || year == game.yearPublished;
        final matchesRating = rating == null || game.rating >= rating;

        return matchesName &&
            matchesPlayers &&
            matchesDuration &&
            matchesYear &&
            matchesRating;
      }).toList();
    });
  }

  void clearField(TextEditingController controller) {
    controller.clear();
    filterGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Board Game Finder')),
      body: Column(
        children: [
          // Filters
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildFilterRow('Name', nameController),
                  buildFilterRow('Players', playersController),
                  buildFilterRow('Duration (min)', durationController),
                  buildFilterRow('Year', yearController),
                  buildFilterRow('Rating', ratingController),
                ],
              ),
            ),
          ),
          // Results
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${game.name} (${game.yearPublished}) ${game.rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text('${game.minPlayers}-${game.maxPlayers} players'),
                        Text('${game.minPlayTime}-${game.maxPlayTime} minutes'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFilterRow(String label, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (_) => filterGames(),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => clearField(controller),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
