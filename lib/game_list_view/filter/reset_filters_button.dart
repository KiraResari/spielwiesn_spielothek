import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_list_view_controller.dart';

class ResetFiltersButton extends StatelessWidget {
  const ResetFiltersButton({super.key});

  @override
  Widget build(BuildContext context) {
    GameListViewController controller = context.watch<GameListViewController>();
    return OutlinedButton.icon(
      onPressed: () => controller.clearAllFilters(),
      icon: const Icon(Icons.refresh),
      label: const Text('Filter zurücksetzen'),
    );
  }
}
