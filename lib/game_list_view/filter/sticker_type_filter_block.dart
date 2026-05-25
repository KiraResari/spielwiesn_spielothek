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
        Text('Stickertyp', style: const TextStyle(fontWeight: FontWeight.w600)),
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
      return RawChip(
        label: SizedBox(
          width: 70,
          height: 70,
          child: Center(
            child: Text(
              stickerType.name,
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        backgroundColor: stickerType.stickerColor.withAlpha(50),
        selectedColor: stickerType.stickerColor,
        showCheckmark: false,
        selected: isSelected,
        shape: CircleBorder(
          side: isSelected ? const BorderSide() : BorderSide.none,
        ),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
        onSelected: (_) {
          controller.toggleStickerType(stickerType);
          setState(() {});
        },
      );
    }).toList();
  }
}
