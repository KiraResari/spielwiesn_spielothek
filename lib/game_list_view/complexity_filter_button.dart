import 'package:flutter/material.dart';

import '../game/game_complexity_level.dart';
import 'game_list_controller.dart';

class ComplexityFilterButton extends StatelessWidget {
  final GameListController controller;

  const ComplexityFilterButton(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final isFilterActive =
        controller.selectedComplexityLevels.length < GameComplexityLevel.values.length;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isFilterActive ? Colors.orange : null,
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
    return GameComplexityLevel.values.map((level) {
      final isSelected = controller.selectedComplexityLevels.contains(level);
      return FilterChip(
        label: Text(level.displayName),
        backgroundColor: level.displayColor.withAlpha(50),
        selectedColor: level.displayColor,
        selected: isSelected,
        onSelected: (_) {
          controller.toggleComplexity(level);
          setState(() {});
        },
      );
    }).toList();
  }
}
