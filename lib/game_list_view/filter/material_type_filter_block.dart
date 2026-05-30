import 'package:flutter/material.dart';

import '../../game/game_material_type.dart';
import '../game_list_view_controller.dart';

class MaterialTypeFilterBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const MaterialTypeFilterBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Materialtyp',
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
    return GameMaterialType.filterOrder.map((materialType) {
      bool isSelected = controller.selectedMaterialTypes.contains(materialType);
      return FilterChip(
        label: Text(materialType.nameAndEmoji),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          controller.toggleMaterialType(materialType);
          setState(() {});
        },
      );
    }).toList();
  }
}
