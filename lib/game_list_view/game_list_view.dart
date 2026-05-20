import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../popups/credits_popup.dart';
import '../popups/markdown_popup.dart';
import '../game/game.dart';
import 'game_card.dart';
import 'game_list_controller.dart';
import '../game/game_category.dart';
import '../game/game_complexity_level.dart';

class GameListView extends StatelessWidget {
  static const imprintKey = "imprint";
  static const privacyKey = "privacy";
  static const creditsKey = "credits";
  static const imprintTitle = "Impressum";
  static const privacyTitle = "Datenschutzerklärung";
  static const creditsTitle = "Credits";

  const GameListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameListController(),
      builder: (context, child) => _buildMainApp(context),
    );
  }

  Widget _buildMainApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielwiesn Spielothek"),
        backgroundColor: Colors.orange,
        actions: [_buildPopupMenuButton(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildFilterSection(context),
            const SizedBox(height: 16),
            _buildResultList(context),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenuButton(BuildContext context) {
    var controller = Provider.of<GameListController>(context, listen: false);
    return PopupMenuButton<String>(
      onSelected: (String value) {
        if (value == imprintKey) {
          showMarkdownPopup(context, imprintTitle, controller.imprint);
        } else if (value == privacyKey) {
          showMarkdownPopup(context, privacyTitle, controller.privacy);
        } else if (value == creditsKey) {
          showCreditsPopup(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: imprintKey,
          child: Text(imprintTitle),
        ),
        const PopupMenuItem<String>(
          value: privacyKey,
          child: Text(privacyTitle),
        ),
        const PopupMenuItem<String>(
          value: creditsKey,
          child: Text(creditsTitle),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final controller = Provider.of<GameListController>(context);
    final filterCount = controller.activeFilterPills.length;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.clearField(controller.nameController),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildFilterButtonWithBadge(
              count: filterCount,
              onPressed: () => _showFilterPopup(context, controller),
              label: 'Filter',
            ),
          ],
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        _buildFilterRow(context, controller),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context, GameListController controller) {
    final theme = Theme.of(context);
    final pills = controller.activeFilterPills;
    final filterCount = pills.length;
    return Row(
      children: [
        Text(
          '${controller.filteredGames.length} Treffer',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        if (controller.hasActiveFilters)
          OutlinedButton.icon(
            onPressed: () => controller.clearAllFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('Filter zurücksetzen'),
          ),
      ],
    );
  }

  void _showFilterPopup(BuildContext context, GameListController controller) {
    var localCategories = List<GameCategory>.from(controller.selectedCategories);
    var localComplexities =
        List<GameComplexityLevel>.from(controller.selectedComplexityLevels);
    var localCoop = controller.selectedCoOp.contains(true);
    var localExklusiv = controller.selectedExklusiv.contains(true);
    var localNovelty = controller.selectedNovelty.contains(true);
    var localFavorites = controller.showOnlyFavorites;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
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
                      Row(
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
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Grunddaten'),
                              const SizedBox(height: 10),
                              _buildDoubleFieldRow(
                                'Spieleranzahl',
                                controller.playersController,
                                'Dauer (Minuten)',
                                controller.durationController,
                                controller,
                              ),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 20),
                              _buildSectionTitle('Sonstiges'),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _buildMiscChips(
                                  coopSelected: controller.selectedCoOp.contains(true),
                                  exklusivSelected: controller.selectedExklusiv.contains(true),
                                  noveltySelected: controller.selectedNovelty.contains(true),
                                  favoritesSelected: controller.showOnlyFavorites,
                                  onCoopToggle: (selected) {
                                    controller.selectedCoOp = selected ? [true] : [];
                                    controller.filterGames();
                                    setState(() {});
                                  },
                                  onExklusivToggle: (selected) {
                                    controller.selectedExklusiv = selected ? [true] : [];
                                    controller.filterGames();
                                    setState(() {});
                                  },
                                  onNoveltyToggle: (selected) {
                                    controller.selectedNovelty = selected ? [true] : [];
                                    controller.filterGames();
                                    setState(() {});
                                  },
                                  onFavoritesToggle: (selected) {
                                    controller.showOnlyFavorites = selected;
                                    controller.filterGames();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  List<Widget> _buildCategoryChips(
    List<GameCategory> selectedCategories,
    void Function(GameCategory category) onToggle,
  ) {
    List<GameCategory> selectableGameCategories = [
      GameCategory.family,
      GameCategory.skill,
      GameCategory.party,
      GameCategory.quiz,
      GameCategory.mystery,
      GameCategory.strategy,
      GameCategory.unknown,
    ];

    return selectableGameCategories.map((category) {
      final isSelected = selectedCategories.contains(category);
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

  List<Widget> _buildComplexityChips(
    List<GameComplexityLevel> selectedComplexityLevels,
    void Function(GameComplexityLevel level) onToggle,
  ) {
    return GameComplexityLevel.values.map((level) {
      final isSelected = selectedComplexityLevels.contains(level);
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

  List<Widget> _buildMiscChips({
    required bool coopSelected,
    required bool exklusivSelected,
    required bool noveltySelected,
    required bool favoritesSelected,
    required ValueChanged<bool> onCoopToggle,
    required ValueChanged<bool> onExklusivToggle,
    required ValueChanged<bool> onNoveltyToggle,
    required ValueChanged<bool> onFavoritesToggle,
  }) {
    return [
      FilterChip(
        label: const Text('Kooperativ'),
        selected: coopSelected,
        onSelected: onCoopToggle,
      ),
      FilterChip(
        label: const Text('Exklusiv'),
        selected: exklusivSelected,
        onSelected: onExklusivToggle,
      ),
      FilterChip(
        label: const Text('Neuheit'),
        selected: noveltySelected,
        onSelected: onNoveltyToggle,
      ),
      FilterChip(
        label: const Text('Favoriten'),
        selected: favoritesSelected,
        onSelected: onFavoritesToggle,
      ),
    ];
  }

  Widget _buildFilterButtonWithBadge({
    required int count,
    required VoidCallback onPressed,
    String label = 'Filter hinzufügen',
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.tune),
          label: Text(label),
        ),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDoubleFieldRow(
    String leftLabel,
    TextEditingController leftTextFieldController,
    String rightLabel,
    TextEditingController rightTextFieldController,
    GameListController filterController,
  ) {
    return Row(
      children: [
        _buildNumberFilterField(
          leftTextFieldController,
          leftLabel,
          filterController,
        ),
        const SizedBox(width: 10),
        _buildNumberFilterField(
          rightTextFieldController,
          rightLabel,
          filterController,
        ),
      ],
    );
  }

  Expanded _buildNumberFilterField(
    TextEditingController textFieldController,
    String label,
    GameListController filterController,
  ) {
    return Expanded(
      child: TextField(
        controller: textFieldController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => filterController.clearField(textFieldController),
          ),
        ),
      ),
    );
  }

  Widget _buildResultList(BuildContext context) {
    final controller = Provider.of<GameListController>(context, listen: false);
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 200) {
            controller.loadMore();
          }
          return false;
        },
        child: Selector<GameListController, List<Game>>(
          selector: (_, c) => c.visibleGames,
          builder: (context, games, _) {
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return GameCard(
                  game,
                  key: ValueKey(game.identifier),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
