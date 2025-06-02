import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category_filter_button.dart';
import 'co_op_filter_button.dart';
import 'complexity_filter_button.dart';
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
        _buildTripleFilterRow(context, controller),
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
        _buildNumberFilterField(
          leftTextFieldController,
          leftLabel,
          filterController,
        ),
        const SizedBox(width: 10),
        _buildNumberFilterField(
          rightTextFieldController,
          rightLabel,
          filterController,
        ),
      ],
    );
  }

  Expanded _buildNumberFilterField(
    TextEditingController textFieldController,
    String label,
    GameListController filterController,
  ) {
    return Expanded(
      child: TextField(
        controller: textFieldController,
        keyboardType: TextInputType.number,
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

  Widget _buildTripleFilterRow(
    BuildContext context,
    GameListController controller,
  ) {
    return Wrap(
      children: [
        ComplexityFilterButton(controller),
        const SizedBox(width: 4),
        CategoryFilterButton(controller),
        const SizedBox(width: 4),
        CoOpFilterButton(controller),
      ],
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
