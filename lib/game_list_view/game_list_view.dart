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
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildSearchBar('Name', controller.nameController, controller),
            const SizedBox(height: 8),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: controller.showFilters
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  _buildDoubleFieldRow(
                    'Spieleranzahl',
                    controller.playersController,
                    'Dauer (Minuten)',
                    controller.durationController,
                    controller,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildFilterRow(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, GameListController controller) {
    final theme = Theme.of(context);
    final pills = controller.activeFilterPills;
    final filterCount = pills.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              filterCount > 0 ? 'Filter ($filterCount)' : 'Filter',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text('${controller.filteredGames.length} Treffer'),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () => _showFilterPopup(context, controller),
              icon: const Icon(Icons.tune),
              label: const Text('Filter bearbeiten'),
            ),
            if (controller.hasActiveFilters)
              OutlinedButton.icon(
                onPressed: () => controller.clearAllFilters(),
                icon: const Icon(Icons.refresh),
                label: const Text('Zurücksetzen'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: pills.isEmpty
              ? Text(
                  'Keine aktiven Filter',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pills
                      .map(
                        (pill) => InputChip(
                          label: Text(pill.label),
                          onDeleted: () => controller.removeFilterPill(pill),
                        ),
                      )
                      .toList(),
                ),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter bearbeiten'),
          content: SingleChildScrollView(
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Kategorie'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildCategoryChips(
                      localCategories,
                      (category) {
                        setState(() {
                          if (localCategories.contains(category)) {
                            localCategories.remove(category);
                          } else {
                            localCategories.add(category);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Komplexität'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildComplexityChips(
                      localComplexities,
                      (level) {
                        setState(() {
                          if (localComplexities.contains(level)) {
                            localComplexities.remove(level);
                          } else {
                            localComplexities.add(level);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Sonstiges'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildMiscChips(
                      coopSelected: localCoop,
                      exklusivSelected: localExklusiv,
                      noveltySelected: localNovelty,
                      favoritesSelected: localFavorites,
                      onCoopToggle: (selected) {
                        setState(() {
                          localCoop = selected;
                        });
                      },
                      onExklusivToggle: (selected) {
                        setState(() {
                          localExklusiv = selected;
                        });
                      },
                      onNoveltyToggle: (selected) {
                        setState(() {
                          localNovelty = selected;
                        });
                      },
                      onFavoritesToggle: (selected) {
                        setState(() {
                          localFavorites = selected;
                        });
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.applyFilterSelections(
                  categories: localCategories,
                  complexities: localComplexities,
                  coopOnly: localCoop,
                  exklusivOnly: localExklusiv,
                  noveltyOnly: localNovelty,
                  favoritesOnly: localFavorites,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Fertig'),
            ),
          ],
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

  Widget _buildSearchBar(
    String label,
    TextEditingController controller,
    GameListController filterController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => filterController.clearField(controller),
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(filterController.showFilters ? Icons.expand_less : Icons.expand_more),
          onPressed: () => filterController.toggleFilters(),
          tooltip: filterController.showFilters ? 'Filter ausblenden' : 'Filter einblenden',
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
