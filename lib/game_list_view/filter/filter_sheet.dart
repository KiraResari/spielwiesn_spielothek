import 'package:flutter/material.dart';

import '../game_list_view_controller.dart';
import 'base_data_filter_block.dart';
import 'category_filter_block.dart';
import 'complexity_filter_block.dart';
import 'misc_filter_block.dart';

class FilterSheet extends StatelessWidget {
  final GameListViewController controller;

  const FilterSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return _buildScrollSheetContent(scrollController);
      },
    );
  }

  Container _buildScrollSheetContent(ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleRow(context),
              const SizedBox(height: 8),
              _buildFilterBlock(scrollController, setState),
            ],
          );
        }),
      ),
    );
  }

  Row _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Filter bearbeiten',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Expanded _buildFilterBlock(
    ScrollController scrollController,
    StateSetter setState,
  ) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseDataFilterBlock(controller: controller),
            const SizedBox(height: 20),
            CategoryFilterBlock(controller: controller, setState: setState),
            const SizedBox(height: 20),
            ComplexityFilterBlock(controller: controller, setState: setState),
            const SizedBox(height: 20),
            MiscFilterBlock(controller: controller, setState: setState),
          ],
        ),
      ),
    );
  }
}
