import 'package:flutter/material.dart';

import '../game/game_category.dart';
import '../game/game_complexity_level.dart';
import 'game_list_view_controller.dart';

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
            _buildBaseDataBlock(),
            const SizedBox(height: 20),
            _buildCategoryBlock(setState),
            const SizedBox(height: 20),
            _buildComplexityBlock(setState),
            const SizedBox(height: 20),
            _buildMiscBlock(setState),
          ],
        ),
      ),
    );
  }

  Column _buildBaseDataBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Grunddaten'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600),
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

  Column _buildCategoryBlock(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Kategorie'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildCategoryChips(
            controller.selectedCategories,
            (category) {
              controller.toggleCategory(category);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryChips(
    List<GameCategory> selectedCategories,
    void Function(GameCategory category) onToggle,
  ) {
    return GameCategory.filterOrder.map((category) {
      bool isSelected = selectedCategories.contains(category);
      return FilterChip(
        label: Text(category.name),
        selected: isSelected,
        selectedColor: Colors.lightGreen,
        onSelected: (_) {
          onToggle(category);
        },
      );
    }).toList();
  }

  Column _buildComplexityBlock(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Komplexität'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildComplexityChips(
            controller.selectedComplexityLevels,
            (level) {
              controller.toggleComplexity(level);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildComplexityChips(
    List<GameComplexityLevel> selectedComplexityLevels,
    void Function(GameComplexityLevel level) onToggle,
  ) {
    return GameComplexityLevel.values.map((level) {
      bool isSelected = selectedComplexityLevels.contains(level);
      Color textColor = isSelected ? level.textColor : Colors.black;
      return FilterChip(
        label: Text(
          level.displayName,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: level.displayColor.withAlpha(50),
        selectedColor: level.displayColor,
        checkmarkColor: textColor,
        selected: isSelected,
        onSelected: (_) {
          onToggle(level);
        },
      );
    }).toList();
  }

  Column _buildMiscBlock(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sonstiges'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildKooperativChip(setState),
            _buildExklusivChip(setState),
            _buildNeuheitChip(setState),
            _buildFavoritenChip(setState),
          ],
        ),
      ],
    );
  }

  FilterChip _buildFavoritenChip(StateSetter setState) {
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

  FilterChip _buildNeuheitChip(StateSetter setState) {
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

  FilterChip _buildExklusivChip(StateSetter setState) {
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

  FilterChip _buildKooperativChip(StateSetter setState) {
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
