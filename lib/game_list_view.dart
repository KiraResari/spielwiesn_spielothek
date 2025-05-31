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
    return Scaffold(
      appBar: AppBar(title: const Text('Spielwiesn Spielothek Spiele')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildFilterSection(context),
            _buildResultList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final controller = Provider.of<GameListController>(context);
    return Column(
      children: [
        _buildFullWidthField('Name', controller.nameController, controller),
        _buildDoubleFieldRow(
          'Spieleranzahl',
          controller.playersController,
          'Dauer (min)',
          controller.durationController,
          controller,
        ),
      ],
    );
  }

  Widget _buildFullWidthField(
    String label,
    TextEditingController controller,
    GameListController filterController,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => filterController.clearField(controller),
        ),
      ),
    );
  }

  Widget _buildDoubleFieldRow(
    String label1,
    TextEditingController controller1,
    String label2,
    TextEditingController controller2,
    GameListController filterController,
  ) {
    return Row(
      children: [
        _buildExpandedFilterField(
          controller1,
          label1,
          filterController,
          rightPadding: 4.0,
        ),
        _buildExpandedFilterField(
          controller2,
          label2,
          filterController,
          leftPadding: 4.0,
        ),
      ],
    );
  }

  Expanded _buildExpandedFilterField(
    TextEditingController controller1,
    String label1,
    GameListController filterController, {
    double leftPadding = 0.0,
    double rightPadding = 0.0,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            left: leftPadding, right: rightPadding),
        child: TextField(
          controller: controller1,
          decoration: InputDecoration(
            labelText: label1,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => filterController.clearField(controller1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(BuildContext context) {
    final controller = Provider.of<GameListController>(context);
    return Expanded(
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
                  Text('${game.minPlayTime}-${game.maxPlayTime} Minuten'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
