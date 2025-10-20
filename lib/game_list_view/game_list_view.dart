import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'filter_buttons/category_filter_button.dart';
import 'filter_buttons/co_op_filter_button.dart';
import 'filter_buttons/complexity_filter_button.dart';
import 'filter_buttons/favorites_filter_button.dart';
import 'filter_buttons/novelty_filter_button.dart';
import 'game_card.dart';
import 'game_list_controller.dart';
import 'filter_buttons/premium_filter_button.dart';

class GameListView extends StatelessWidget {
  const GameListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameListController(),
      child: const GameFilterView(),
    );
  }
}

class GameFilterView extends StatelessWidget {
  const GameFilterView({Key? key}) : super(key: key);

  static const imprintKey = "imprint";
  static const privacyKey = "privacy";
  static const creditsKey = "credits";
  static const imprintTitle = "Impressum";
  static const privacyTitle = "Datenschutzerklärung";
  static const creditsTitle = "Credits";

  @override
  Widget build(BuildContext context) {
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
          _showMarkdownDialog(context, imprintTitle, controller.imprint);
        } else if (value == privacyKey) {
          _showMarkdownDialog(context, privacyTitle, controller.privacy);
        } else if (value == creditsKey) {
          _showCreditsDialog(context);
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

  void _showMarkdownDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: MarkdownWidget(
              data: content,
              shrinkWrap: true,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Credits'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Eine App von',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kira Resari',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/tri-tail_logo.png',
                  width: 120,
                ),
                TextButton(
                  onPressed: () => _launchURL('http://www.tri-tail.com/'),
                  child: const Text(
                    'www.tri-tail.com',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Im Auftrag der MPA',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/mpa_logo.png',
                  width: 120,
                ),
                TextButton(
                  onPressed: () => _launchURL('https://www.mpagmbh.de/'),
                  child: const Text(
                    'www.mpagmbh.de',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) {
    Uri uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
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
