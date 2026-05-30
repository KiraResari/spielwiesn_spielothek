import 'package:flutter/material.dart';

import '../game_list_view_controller.dart';

class BaseDataFilterBlock extends StatelessWidget {
  final GameListViewController controller;

  const BaseDataFilterBlock({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _isLandscapeOrientation(context)
        ? _buildHorizontalLayout()
        : _buildVerticalLayout();
  }

  bool _isLandscapeOrientation(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Row _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: _buildNumberFilterField(
            controller.playersController,
            "Spieleranzahl",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNumberFilterField(
            controller.minAgeController,
            "Mindestalter",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildNumberFilterField(
            controller.durationController,
            "Dauer (Minuten)",
          ),
        ),
      ],
    );
  }

  Column _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildNumberFilterField(
                controller.playersController,
                "Spieleranzahl",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberFilterField(
                controller.minAgeController,
                "Mindestalter",
              ),
            ),
          ],
        ),
        _buildNumberFilterField(
          controller.durationController,
          "Dauer (Minuten)",
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
