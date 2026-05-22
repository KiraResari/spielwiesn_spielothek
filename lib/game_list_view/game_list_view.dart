import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/legal_info.dart';
import '../popups/credits_popup.dart';
import '../popups/markdown_popup.dart';
import '../game/game.dart';
import 'filter_popup.dart';
import 'game_card.dart';
import 'game_list_view_controller.dart';

class GameListView extends StatelessWidget {
  static const imprintKey = "imprint";
  static const privacyKey = "privacy";
  static const creditsKey = "credits";
  static const licencesKey = "licenses";
  static const imprintTitle = "Impressum";
  static const privacyTitle = "Datenschutzerklärung";
  static const creditsTitle = "Credits";
  static const licencesTitle = "Lizenzen";

  const GameListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameListViewController(),
      builder: (context, child) => _buildMainApp(context),
    );
  }

  Widget _buildMainApp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielwiesn Spielothek"),
        backgroundColor: Colors.orange,
        actions: [_buildMenuButton(context)],
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

  PopupMenuButton<String> _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case imprintKey:
            showMarkdownPopup(context, imprintTitle, LegalInfo.imprint);
            break;
          case privacyKey:
            showMarkdownPopup(context, privacyTitle, LegalInfo.privacyAgreement);
            break;
          case creditsKey:
            showCreditsPopup(context);
            break;
          case licencesKey:
            showLicensePage(context: context);
            break;
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
        const PopupMenuItem<String>(
          value: licencesKey,
          child: Text(licencesTitle),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      children: [
        _buildSearchFieldAndFilterButtonRow(context),
        const SizedBox(height: 8),
        _buildResultCountAndFilterResetButtonBlock(context),
      ],
    );
  }

  Row _buildSearchFieldAndFilterButtonRow(BuildContext context) {
    return Row(
      children: [
        _buildSearchField(context),
        const SizedBox(width: 8),
        _buildFilterButton(context),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    GameListViewController controller = context.read<GameListViewController>();
    return Expanded(
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
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    int filterCount = context.watch<GameListViewController>().activeFilters.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showFilterPopup(context),
          icon: const Icon(Icons.tune),
          label: Text("Filter"),
        ),
        if (filterCount > 0) _buildActiveFilterCountBubble(filterCount),
      ],
    );
  }

  Positioned _buildActiveFilterCountBubble(int filterCount) {
    return Positioned(
      right: -6,
      top: -6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$filterCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCountAndFilterResetButtonBlock(BuildContext context) {
    GameListViewController controller = context.read<GameListViewController>();
    bool areFiltersActive =
        context.watch<GameListViewController>().hasActiveFilters;
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        _buildResultText(context),
        const Spacer(),
        if (areFiltersActive)
          OutlinedButton.icon(
            onPressed: () => controller.clearAllFilters(),
            icon: const Icon(Icons.refresh),
            label: const Text('Filter zurücksetzen'),
          ),
      ],
    );
  }

  Text _buildResultText(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String resultText = _determineResultText(context);
    return Text(
      resultText,
      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  String _determineResultText(BuildContext context) {
    bool areFiltersActive =
        context.watch<GameListViewController>().hasActiveFilters;
    bool isSearchFieldFilled =
        context.watch<GameListViewController>().nameController.text.isNotEmpty;
    int filteredGamesCount =
        context.watch<GameListViewController>().filteredGames.length;
    if (areFiltersActive || isSearchFieldFilled) {
      if (filteredGamesCount == 0) {
        return "Keine Treffer zu den aktiven Filtern";
      }
      return "$filteredGamesCount Treffer zu den aktiven Filtern";
    }
    if (filteredGamesCount == 0) {
      return "Spiele werden geladen...";
    }
    return "Wir haben insgesamt $filteredGamesCount Spiele";
  }

  void _showFilterPopup(BuildContext context) {
    GameListViewController controller = context.read<GameListViewController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterPopup(controller: controller);
      },
    );
  }

  Widget _buildResultList(BuildContext context) {
    GameListViewController controller = context.read<GameListViewController>();
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 200) {
            controller.loadMore();
          }
          return false;
        },
        child: _buildGameListSelector(),
      ),
    );
  }

  Selector<GameListViewController, List<Game>> _buildGameListSelector() {
    return Selector<GameListViewController, List<Game>>(
      selector: (_, controller) => controller.visibleGames,
      builder: (context, games, _) {
        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            Game game = games[index];
            return GameCard(
              game,
              key: ValueKey(game.identifier),
            );
          },
        );
      },
    );
  }
}
