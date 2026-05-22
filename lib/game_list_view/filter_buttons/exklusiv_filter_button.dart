import 'package:flutter/material.dart';

import '../game_list_view_controller.dart';

class ExklusivFilterButton extends StatelessWidget {
  final GameListViewController controller;

  const ExklusivFilterButton(this.controller, {super.key});

  bool get _isFilterActive => controller.selectedExclusive.length < 2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => _showPremiumDialog(context),
      child: const Text("Exklusiv"),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Exklusiv"),
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
              controller.selectedExclusive
                ..clear()
                ..addAll([true, false]);
            } else {
              controller.selectedExclusive.clear();
            }
            controller.applyFilters();
          });
        },
      ),
      FilterChip(
        label: const Text("Exklusiv"),
        selected: controller.selectedExclusive.contains(true),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleExklusiv(true);
          setState(() {});
        },
      ),
      FilterChip(
        label: const Text("Nicht Exklusiv"),
        selected: controller.selectedExclusive.contains(false),
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleExklusiv(false);
          setState(() {});
        },
      ),
    ];
  }
}
