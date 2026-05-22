import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_list_view/game_list_view.dart';
import 'startup_view_controller.dart';

class StartupView extends StatelessWidget {
  const StartupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          StartupViewController(() async => _navigateToGameListView(context)),
      child: Builder(builder: _buildStartupView),
    );
  }

  Widget _buildStartupView(BuildContext context) {
    //Though this seems cumbersome, this is essential, because otherwise the StartupViewController is never created, and thus nothing gets initialized
    String displayText = context.read<StartupViewController>().displayText;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).canvasColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            displayText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToGameListView(BuildContext context) async {
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => GameListView()),
      (_) => false,
    );
  }
}
