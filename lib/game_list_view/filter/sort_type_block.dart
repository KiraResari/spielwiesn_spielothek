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
        _buildDropdownButton(),
      ],
    );
  }

  DropdownButton<SortType> _buildDropdownButton() {
    return DropdownButton<SortType>(
      value: controller.sortType,
      onChanged: (SortType? newSortType) {
        if (newSortType != null) {
          controller.setSortType(newSortType);
          setState(() {});
        }
      },
      items: SortType.values.map((sortType) {
        return DropdownMenuItem<SortType>(
          value: sortType,
          child: Text(sortType.name),
        );
      }).toList(),
    );
  }
}
