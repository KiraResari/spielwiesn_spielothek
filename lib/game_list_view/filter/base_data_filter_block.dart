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
        Text('Grunddaten', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildNumberFilterField(
              controller.playersController,
              'Spieleranzahl',
            ),
            const SizedBox(width: 10),
            _buildNumberFilterField(
              controller.durationController,
              'Dauer (Minuten)',
            ),
          ],
        ),
      ],
    );
  }

  Expanded _buildNumberFilterField(
    TextEditingController textFieldController,
    String label,
  ) {
    return Expanded(
      child: TextField(
        controller: textFieldController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.clearField(textFieldController),
          ),
        ),
      ),
    );
  }
}
