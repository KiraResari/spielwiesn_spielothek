import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../constants/legal_info.dart';
import '../game_list_view/game_list_view_controller.dart';
import '../spielwiesn_context.dart';
import 'credits_popup.dart';
import 'markdown_popup.dart';

class MainMenuButton extends StatelessWidget {
  static const updateGamesKey = "update_games";
  static const imprintKey = "imprint";
  static const privacyKey = "privacy";
  static const creditsKey = "credits";
  static const licencesKey = "licenses";
  static const debugLogsKey = "debug_logs";

  static const updateGamesTitle = "Spieleliste aktualisieren";
  static const imprintTitle = "Impressum";
  static const privacyTitle = "Datenschutzerklärung";
  static const creditsTitle = "Credits";
  static const licencesTitle = "Lizenzen";
  static const debugLogsTitle = "Debug Logs";

  final GameListViewController controller;

  const MainMenuButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
          case updateGamesKey:
            controller.updateSource();
            break;
          case imprintKey:
            _showImprintPopup(context);
            break;
          case privacyKey:
            _showPrivacyPopup(context);
            break;
          case creditsKey:
            _showCreditsPopup(context);
            break;
          case licencesKey:
            showLicensePage(context: context);
            break;
          case debugLogsKey:
            _showDebugLogs(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: updateGamesKey,
          child: _buildUpdatePanel(context),
        ),
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
        const PopupMenuItem<String>(
          value: debugLogsKey,
          child: Text(debugLogsTitle),
        ),
      ],
    );
  }

  Widget _buildUpdatePanel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(updateGamesTitle),
        Text(
          _buildLastUpdateString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _buildLastUpdateString() {
    DateTime? lastUpdateTimestamp = controller.lastUpdateTimestamp;
    if(lastUpdateTimestamp == null){
      return "Spieleliste ist noch auf Werkseinstellungen";
    }
    String timeString = lastUpdateTimestamp.toString().substring(0, 16);
    return "Letztes Update: $timeString";
  }

  void _showImprintPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          MarkdownPopup(title: imprintTitle, content: LegalInfo.imprint),
    );
  }

  void _showPrivacyPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => MarkdownPopup(
          title: privacyTitle, content: LegalInfo.privacyAgreement),
    );
  }

  void _showCreditsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CreditsPopup(),
    );
  }

  void _showDebugLogs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TalkerScreen(talker: talker),
      ),
    );
  }
}
