import 'package:flutter/material.dart';

import '../game_list_view_controller.dart';

class BaseDataFilterBlock extends StatelessWidget {
  final GameListViewController controller;

  const BaseDataFilterBlock({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberFilterField(
          controller.playersController,
          "Spieleranzahl",
        ),
        _buildNumberFilterField(
          controller.durationController,
          "Dauer (Minuten)",
        ),
        _buildNumberFilterField(
          controller.minAgeController,
          "Mindestalter",
        ),
      ],
    );
  }

  Widget _buildNumberFilterField(
    TextEditingController textFieldController,
    String label,
  ) {
    return TextField(
      controller: textFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => controller.clearField(textFieldController),
        ),
      ),
    );
  }
}
