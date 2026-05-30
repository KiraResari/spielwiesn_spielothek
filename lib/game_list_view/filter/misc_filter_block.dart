import 'package:flutter/material.dart';

import '../game_list_view_controller.dart';

class MiscFilterBlock extends StatelessWidget {
  final GameListViewController controller;
  final StateSetter setState;

  const MiscFilterBlock({
    super.key,
    required this.controller,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sonstiges', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildKooperativChip(),
            _buildExklusivChip(),
            _buildNeuheitChip(),
            _buildFavoritenChip(),
          ],
        ),
      ],
    );
  }

  FilterChip _buildFavoritenChip() {
    return FilterChip(
      label: const Text('Favoriten'),
      selected: controller.showOnlyFavorites,
      onSelected: (selected) {
        controller.showOnlyFavorites = selected;
        controller.applyFilters();
        setState(() {});
      },
    );
  }

  FilterChip _buildNeuheitChip() {
    return FilterChip(
      label: const Text('Neuheit'),
      selected: controller.selectedNovelty.contains(true),
      onSelected: (selected) {
        controller.selectedNovelty = selected ? [true] : [];
        controller.applyFilters();
        setState(() {});
      },
    );
  }

  FilterChip _buildExklusivChip() {
    return FilterChip(
      label: const Text('Exklusiv'),
      selected: controller.selectedExclusive.contains(true),
      onSelected: (selected) {
        controller.selectedExclusive = selected ? [true] : [];
        controller.applyFilters();
        setState(() {});
      },
    );
  }

  FilterChip _buildKooperativChip() {
    return FilterChip(
      label: const Text('Kooperativ'),
      selected: controller.selectedCoOp.contains(true),
      onSelected: (selected) {
        controller.selectedCoOp = selected ? [true] : [];
        controller.applyFilters();
        setState(() {});
      },
    );
  }
}
