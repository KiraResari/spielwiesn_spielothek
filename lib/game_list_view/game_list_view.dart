import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_card.dart';
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
      appBar: AppBar(
        title: const Text('Spielwiesn Spielothek Spiele'),
        backgroundColor: Colors.orange,
      ),
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
    String leftLabel,
    TextEditingController leftTextFieldController,
    String rightLabel,
    TextEditingController rightTextFieldController,
    GameListController filterController,
  ) {
    return Row(
      children: [
        _buildExpandedFilterField(
          leftTextFieldController,
          leftLabel,
          filterController,
        ),
        const SizedBox(width: 10),
        _buildExpandedFilterField(
          rightTextFieldController,
          rightLabel,
          filterController,
        ),
      ],
    );
  }

  Expanded _buildExpandedFilterField(
    TextEditingController textFieldController,
    String label,
    GameListController filterController,
  ) {
    return Expanded(
      child: TextField(
        controller: textFieldController,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => filterController.clearField(textFieldController),
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
          return GameCard(game);
        },
      ),
    );
  }
}
