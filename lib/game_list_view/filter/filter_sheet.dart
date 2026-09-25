import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_list_view_controller.dart';
import 'base_data_filter_block.dart';
import 'category_filter_block.dart';
import 'complexity_filter_block.dart';
import 'material_type_filter_block.dart';
import 'misc_filter_block.dart';
import 'reset_filters_button.dart';
import 'sort_type_block.dart';
import 'sticker_type_filter_block.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return _buildScrollSheetContent(context, scrollController);
      },
    );
  }

  Container _buildScrollSheetContent(
      BuildContext context, ScrollController scrollController) {
    bool hasActiveFilters =
        context.watch<GameListViewController>().hasActiveFilters;
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
              if (hasActiveFilters) ResetFiltersButton(),
              const SizedBox(height: 8),
              _buildFilterBlock(context, scrollController, setState),
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
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Expanded _buildFilterBlock(
    BuildContext context,
    ScrollController scrollController,
    StateSetter setState,
  ) {
    var controller = context.read<GameListViewController>();
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
            MaterialTypeFilterBlock(controller: controller, setState: setState),
            const SizedBox(height: 20),
            StickerTypeFilterBlock(controller: controller, setState: setState),
            const SizedBox(height: 20),
            MiscFilterBlock(controller: controller, setState: setState),
            const SizedBox(height: 20),
            SortTypeBlock(controller: controller, setState: setState),
          ],
        ),
      ),
    );
  }
}
