import 'package:flutter/material.dart';

import '../game/game_category.dart';
import '../game/game_complexity_level.dart';
import 'game_list_controller.dart';

class FilterPopup extends StatelessWidget {
  final GameListController controller;

  const FilterPopup({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter bearbeiten',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Grunddaten'),
                          const SizedBox(height: 10),
                          _buildDoubleFieldRow(
                            'Spieleranzahl',
                            controller.playersController,
                            'Dauer (Minuten)',
                            controller.durationController,
                            controller,
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Kategorie'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _buildCategoryChips(
                              controller.selectedCategories,
                              (category) {
                                controller.toggleCategory(category);
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Komplexität'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _buildComplexityChips(
                              controller.selectedComplexityLevels,
                              (level) {
                                controller.toggleComplexity(level);
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Sonstiges'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _buildMiscChips(
                              coopSelected:
                                  controller.selectedCoOp.contains(true),
                              exklusivSelected:
                                  controller.selectedExklusiv.contains(true),
                              noveltySelected:
                                  controller.selectedNovelty.contains(true),
                              favoritesSelected: controller.showOnlyFavorites,
                              onCoopToggle: (selected) {
                                controller.selectedCoOp =
                                    selected ? [true] : [];
                                controller.filterGames();
                                setState(() {});
                              },
                              onExklusivToggle: (selected) {
                                controller.selectedExklusiv =
                                    selected ? [true] : [];
                                controller.filterGames();
                                setState(() {});
                              },
                              onNoveltyToggle: (selected) {
                                controller.selectedNovelty =
                                    selected ? [true] : [];
                                controller.filterGames();
                                setState(() {});
                              },
                              onFavoritesToggle: (selected) {
                                controller.showOnlyFavorites = selected;
                                controller.filterGames();
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  List<Widget> _buildCategoryChips(
    List<GameCategory> selectedCategories,
    void Function(GameCategory category) onToggle,
  ) {
    List<GameCategory> selectableGameCategories = [
      GameCategory.family,
      GameCategory.skill,
      GameCategory.party,
      GameCategory.quiz,
      GameCategory.mystery,
      GameCategory.strategy,
      GameCategory.unknown,
    ];

    return selectableGameCategories.map((category) {
      final isSelected = selectedCategories.contains(category);
      return FilterChip(
        label: Text(category.name),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          onToggle(category);
        },
      );
    }).toList();
  }

  List<Widget> _buildComplexityChips(
    List<GameComplexityLevel> selectedComplexityLevels,
    void Function(GameComplexityLevel level) onToggle,
  ) {
    return GameComplexityLevel.values.map((level) {
      final isSelected = selectedComplexityLevels.contains(level);
      Color textColor = isSelected ? level.textColor : Colors.black;
      return FilterChip(
        label: Text(
          level.displayName,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: level.displayColor.withAlpha(50),
        selectedColor: level.displayColor,
        checkmarkColor: textColor,
        selected: isSelected,
        onSelected: (_) {
          onToggle(level);
        },
      );
    }).toList();
  }

  List<Widget> _buildMiscChips({
    required bool coopSelected,
    required bool exklusivSelected,
    required bool noveltySelected,
    required bool favoritesSelected,
    required ValueChanged<bool> onCoopToggle,
    required ValueChanged<bool> onExklusivToggle,
    required ValueChanged<bool> onNoveltyToggle,
    required ValueChanged<bool> onFavoritesToggle,
  }) {
    return [
      FilterChip(
        label: const Text('Kooperativ'),
        selected: coopSelected,
        onSelected: onCoopToggle,
      ),
      FilterChip(
        label: const Text('Exklusiv'),
        selected: exklusivSelected,
        onSelected: onExklusivToggle,
      ),
      FilterChip(
        label: const Text('Neuheit'),
        selected: noveltySelected,
        onSelected: onNoveltyToggle,
      ),
      FilterChip(
        label: const Text('Favoriten'),
        selected: favoritesSelected,
        onSelected: onFavoritesToggle,
      ),
    ];
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
}
