import 'package:flutter/material.dart';

import '../constants/legal_info.dart';
import 'credits_popup.dart';
import 'markdown_popup.dart';

class MainMenuButton extends StatelessWidget {
  static const imprintKey = "imprint";
  static const privacyKey = "privacy";
  static const creditsKey = "credits";
  static const licencesKey = "licenses";
  static const imprintTitle = "Impressum";
  static const privacyTitle = "Datenschutzerklärung";
  static const creditsTitle = "Credits";
  static const licencesTitle = "Lizenzen";

  const MainMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        switch (value) {
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
}
