import 'package:flutter/material.dart';

import '../game_list_controller.dart';

class NoveltyFilterButton extends StatelessWidget {
  final GameListController controller;

  const NoveltyFilterButton(this.controller, {super.key});

  bool get _isFilterActive => controller.selectedNovelty.length < 2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => _showNoveltyDialog(context),
      child: const Text("Neuheiten"),
    );
  }

  void _showNoveltyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Neuheiten"),
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

  List<Widget> _buildFilterChips(StateSetter setState) {
    return [
      FilterChip(
        label: const Text("Alle"),
        selected: !_isFilterActive,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          setState(() {
            if (_isFilterActive) {
              controller.selectedNovelty
                ..clear()
                ..addAll([true, false]);
            } else {
              controller.selectedNovelty.clear();
            }
            controller.filterGames();
          });
        },
      ),
      FilterChip(
        label: const Text("Neuheiten"),
        selected: controller.selectedNovelty.contains(true),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleNovelty(true);
          setState(() {});
        },
      ),
      FilterChip(
        label: const Text("Nicht Neuheiten"),
        selected: controller.selectedNovelty.contains(false),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleNovelty(false);
          setState(() {});
        },
      ),
    ];
  }
}
