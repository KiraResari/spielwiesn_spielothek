import 'package:flutter/material.dart';

import 'game_list_controller.dart';

class FavoritesFilterButton extends StatelessWidget {
  final GameListController controller;

  const FavoritesFilterButton(this.controller, {super.key});

  bool get _isFilterActive =>
      controller.showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFilterActive ? Colors.orange : null,
      ),
      onPressed: () => toggleFavoriteFiltering(),
      child: Icon(
        _isFilterActive ? Icons.star : Icons.star_border,
        color: _isFilterActive ? Colors.amber : Colors.grey,
      ),
    );
  }

  void toggleFavoriteFiltering() {
    controller.showOnlyFavorites = !controller.showOnlyFavorites;
    controller.filterGames();
  }
}