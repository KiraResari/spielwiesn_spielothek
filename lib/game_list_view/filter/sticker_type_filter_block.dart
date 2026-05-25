import 'package:flutter/material.dart';

import '../../game/sticker_type.dart';
import '../game_list_view_controller.dart';

class StickerTypeFilterBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const StickerTypeFilterBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sticker', style: const TextStyle(fontWeight: FontWeight.w600)),
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
    return StickerType.filterOrder.map((stickerType) {
      bool isSelected = controller.selectedStickerTypes.contains(stickerType);
      Color textColor = isSelected ? stickerType.textColor : Colors.black;
      return FilterChip(
        label: Text(
          stickerType.name,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: stickerType.stickerColor.withAlpha(50),
        selectedColor: stickerType.stickerColor,
        checkmarkColor: textColor,
        selected: isSelected,
        onSelected: (_) {
          controller.toggleStickerType(stickerType);
          setState(() {});
        },
      );
    }).toList();
  }
}
