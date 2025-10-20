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
    return Column(
      children: [
        _buildFullWidthField('Name', controller.nameController, controller),
        _buildDoubleFieldRow(
          'Spieleranzahl',
          controller.playersController,
          'Dauer (Minuten)',
          controller.durationController,
          controller,
        ),
        _buildTripleFilterRow(context, controller),
      ],
    );
  }

  Widget _buildFullWidthField(
    String label,
    TextEditingController controller,
    GameListController filterController,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => filterController.clearField(controller),
        ),
      ),
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
      children: [
        ComplexityFilterButton(controller),
        const SizedBox(width: 4),
        CategoryFilterButton(controller),
        const SizedBox(width: 4),
        CoOpFilterButton(controller),
        const SizedBox(width: 4),
        PremiumFilterButton(controller),
        const SizedBox(width: 4),
        NoveltyFilterButton(controller),
        const SizedBox(width: 4),
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
