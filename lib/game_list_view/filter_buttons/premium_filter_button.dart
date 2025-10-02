import 'package:flutter/material.dart';

import '../game_list_controller.dart';

class PremiumFilterButton extends StatelessWidget {
  final GameListController controller;

  const PremiumFilterButton(this.controller, {super.key});

  bool get _isFilterActive => controller.selectedPremium.length < 2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => _showPremiumDialog(context),
      child: const Text("Exclusiv"),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Exclusiv"),
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
              controller.selectedPremium
                ..clear()
                ..addAll([true, false]);
            } else {
              controller.selectedPremium.clear();
            }
            controller.filterGames();
          });
        },
      ),
      FilterChip(
        label: const Text("Exclusiv"),
        selected: controller.selectedPremium.contains(true),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.togglePremium(true);
          setState(() {});
        },
      ),
      FilterChip(
        label: const Text("Nicht Exclusiv"),
        selected: controller.selectedPremium.contains(false),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.togglePremium(false);
          setState(() {});
        },
      ),
    ];
  }
}
