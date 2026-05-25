import 'package:flutter/material.dart';

import '../../game/game_category.dart';
import '../game_list_view_controller.dart';

class CategoryFilterBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const CategoryFilterBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategorie', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildCategoryChips(),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryChips() {
    return GameCategory.filterOrder.map((category) {
      bool isSelected = controller.selectedCategories.contains(category);
      return FilterChip(
        label: Text(category.name),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleCategory(category);
          setState(() {});
        },
      );
    }).toList();
  }
}
