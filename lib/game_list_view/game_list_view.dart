import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game/game_category.dart';
import '../game/game_complexity_level.dart';
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

  Widget _buildTripleFilterRow(
      BuildContext context, GameListController controller) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () => _showComplexityDialog(context, controller),
          child: const Text("Komplexität"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _showCategoryDialog(context, controller),
          child: const Text("Kategorie"),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _showCoOpDialog(context, controller),
          child: const Text("Co-Op"),
        ),
      ],
    );
  }

  void _showComplexityDialog(
      BuildContext context, GameListController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Komplexität"),
              content: Wrap(
                spacing: 8,
                children: GameComplexityLevel.values.map((level) {
                  final isSelected =
                      controller.selectedComplexityLevels.contains(level);
                  return FilterChip(
                    label: Text(level.displayName),
                    backgroundColor: level.displayColor.withAlpha(50),
                    selectedColor: level.displayColor,
                    selected: isSelected,
                    onSelected: (_) {
                      controller.toggleComplexity(level);
                      setState(() {}); // <- this forces the chip UI to update
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fertig"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCategoryDialog(
      BuildContext context, GameListController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Kategorien"),
              content: Wrap(
                spacing: 8,
                children: GameCategory.values.map((category) {
                  final isSelected =
                      controller.selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category.name),
                    selected: isSelected,
                    onSelected: (_) {
                      controller.toggleCategory(category);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fertig"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCoOpDialog(BuildContext context, GameListController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Co-Op"),
              content: Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text("Co-Op"),
                    selected: controller.selectedCoOp.contains(true),
                    onSelected: (_) {
                      controller.toggleCoOp(true);
                      setState(() {});
                    },
                  ),
                  FilterChip(
                    label: const Text("Nicht Co-Op"),
                    selected: controller.selectedCoOp.contains(false),
                    onSelected: (_) {
                      controller.toggleCoOp(false);
                      setState(() {});
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Fertig"),
                ),
              ],
            );
          },
        );
      },
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
