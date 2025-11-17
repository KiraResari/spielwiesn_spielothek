import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../popups/credits_popup.dart';
import '../popups/markdown_popup.dart';
import 'filter_buttons/category_filter_button.dart';
import 'filter_buttons/co_op_filter_button.dart';
import 'filter_buttons/complexity_filter_button.dart';
import 'filter_buttons/favorites_filter_button.dart';
import 'filter_buttons/novelty_filter_button.dart';
import 'filter_buttons/premium_filter_button.dart';
import 'game_card.dart';
import 'game_list_controller.dart';

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
        if (value == GameListView.imprintKey) {
          showMarkdownPopup(context, GameListView.imprintTitle, controller.imprint);
        } else if (value == GameListView.privacyKey) {
          showMarkdownPopup(context, GameListView.privacyTitle, controller.privacy);
        } else if (value == GameListView.creditsKey) {
          showCreditsPopup(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: GameListView.imprintKey,
          child: Text(GameListView.imprintTitle),
        ),
        const PopupMenuItem<String>(
          value: GameListView.privacyKey,
          child: Text(GameListView.privacyTitle),
        ),
        const PopupMenuItem<String>(
          value: GameListView.creditsKey,
          child: Text(GameListView.creditsTitle),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final controller = Provider.of<GameListController>(context);
    return Column(
      children: [
        _buildFullWidthField('Name', controller.nameController, controller),
        if (controller.showFilters) ...[
          _buildDoubleFieldRow(
            'Spieleranzahl',
            controller.playersController,
            'Dauer (Minuten)',
            controller.durationController,
            controller,
          ),
          const SizedBox(height: 12),
          _buildTripleFilterRow(context, controller),
        ],
      ],
    );
  }

  Widget _buildFullWidthField(
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

  Widget _buildTripleFilterRow(
    BuildContext context,
    GameListController controller,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ComplexityFilterButton(controller),
        CategoryFilterButton(controller),
        CoOpFilterButton(controller),
        PremiumFilterButton(controller),
        NoveltyFilterButton(controller),
        FavoritesFilterButton(controller),
      ],
    );
  }

  Widget _buildResultList(BuildContext context) {
    final controller = Provider.of<GameListController>(context);
    return Expanded(
      child: ListView.builder(
        itemCount: controller.filteredGames.length,
        itemBuilder: (context, index) {
          final game = controller.filteredGames[index];
          return GameCard(game);
        },
      ),
    );
  }
}
