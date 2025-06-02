import 'package:flutter/material.dart';

import 'game_list_controller.dart';

class CoOpFilterButton extends StatelessWidget {
  final GameListController controller;

  const CoOpFilterButton(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showCoOpDialog(context),
      child: const Text("Co-Op"),
    );
  }

  void _showCoOpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Co-Op"),
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
    ];
  }
}
