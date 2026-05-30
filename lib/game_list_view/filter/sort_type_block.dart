import 'package:flutter/material.dart';

import '../../game/sort_type.dart';
import '../game_list_view_controller.dart';

class SortTypeBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const SortTypeBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sortierung', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: _buildChips()),
      ],
    );
  }

  List<Widget> _buildChips() {
    return SortType.values.map((sortType) {
      bool isSelected = controller.sortType == sortType;
      return FilterChip(
        label: Text(sortType.name),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.setSortType(sortType);
          setState(() {});
        },
      );
    }).toList();
  }
}
