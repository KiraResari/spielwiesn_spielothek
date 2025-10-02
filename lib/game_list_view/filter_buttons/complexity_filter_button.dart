import 'package:flutter/material.dart';

import '../../game/game_complexity_level.dart';
import '../game_list_controller.dart';

class ComplexityFilterButton extends StatelessWidget {
  final GameListController controller;

  const ComplexityFilterButton(this.controller, {super.key});

  bool get _isFilterActive =>
      controller.selectedComplexityLevels.length <
      GameComplexityLevel.values.length;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => _showComplexityDialog(context),
      child: const Text("Komplexität"),
    );
  }

  void _showComplexityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Komplexität"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _buildFilterChips(setState),
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

  List<FilterChip> _buildFilterChips(StateSetter setState) {
    final List<FilterChip> chips = [];

    chips.add(_buildAlleFilterChip(setState));

    chips.addAll(GameComplexityLevel.values
        .map((level) => _buildFilterChipForLevel(level, setState)));

    return chips;
  }

  FilterChip _buildAlleFilterChip(StateSetter setState) {
    return FilterChip(
      label: const Text("Alle"),
      selected: !_isFilterActive,
      onSelected: (_) {
        setState(() {
          if (_isFilterActive) {
            controller.selectedComplexityLevels
              ..clear()
              ..addAll(GameComplexityLevel.values);
          } else {
            controller.selectedComplexityLevels.clear();
          }
          controller.filterGames();
        });
      },
    );
  }

  FilterChip _buildFilterChipForLevel(
    GameComplexityLevel level,
    StateSetter setState,
  ) {
    final isSelected = controller.selectedComplexityLevels.contains(level);
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
        controller.toggleComplexity(level);
        setState(() {});
      },
    );
  }
}
