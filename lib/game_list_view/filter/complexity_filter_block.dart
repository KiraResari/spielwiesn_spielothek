import 'package:flutter/material.dart';

import '../../game/game_complexity_level.dart';
import '../game_list_view_controller.dart';

class ComplexityFilterBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const ComplexityFilterBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Komplexität',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildChips(),
        ),
      ],
    );
  }

  List<Widget> _buildChips() {
    return GameComplexityLevel.values.map((level) {
      bool isSelected = controller.selectedComplexityLevels.contains(level);
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
    }).toList();
  }
}
