import 'package:flutter/material.dart';

import '../../game/game_category.dart';
import '../game_list_controller.dart';

class CategoryFilterButton extends StatelessWidget {
  final GameListController controller;

  const CategoryFilterButton(this.controller, {super.key});

  bool get _isFilterActive =>
      controller.selectedCategories.length < GameCategory.values.length;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => _showCategoryDialog(context),
      child: const Text("Kategorie"),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Kategorien"),
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

    chips.add(
      FilterChip(
        label: const Text("Alle"),
        selected: !_isFilterActive,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          setState(() {
            if (_isFilterActive) {
              controller.selectedCategories
                ..clear()
                ..addAll(GameCategory.values);
            } else {
              controller.selectedCategories.clear();
            }
            controller.filterGames();
          });
        },
      ),
    );

    List<GameCategory> selectableGameCategories = [
      GameCategory.family,
      GameCategory.skill,
      GameCategory.party,
      GameCategory.quiz,
      GameCategory.mystery,
      GameCategory.strategy,
      GameCategory.unknown,
    ];
    chips.addAll(selectableGameCategories.map((category) {
      final isSelected = controller.selectedCategories.contains(category);
      return FilterChip(
        label: Text(category.name),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleCategory(category);
          setState(() {});
        },
      );
    }).toList());

    return chips;
  }
}
