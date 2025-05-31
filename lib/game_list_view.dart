import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_list_controller.dart';

class GameListView extends StatelessWidget {

  const GameListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameListController(),
      child: const GameFilterView(),
    );
  }
}

class GameFilterView extends StatelessWidget {
  const GameFilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GameListController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Spielwiesn Spielothek Spiele')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildFilterRow('Name', controller.nameController, controller),
            buildFilterRow(
                'Spieleranzahl', controller.playersController, controller),
            buildFilterRow(
                'Dauer (minuten)', controller.durationController, controller),
            buildFilterRow(
                'Erscheinungsjahr', controller.yearController, controller),
            buildFilterRow(
                'Mindestbewertung', controller.ratingController, controller),
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredGames.length,
                itemBuilder: (context, index) {
                  final game = controller.filteredGames[index];
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
                          Text('${game.minPlayers}-${game.maxPlayers} Spieler'),
                          Text(
                              '${game.minPlayTime}-${game.maxPlayTime} Minuten'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterRow(
      String label,
      TextEditingController controller,
      GameListController filterController
      ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => filterController.clearField(controller),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
