import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showCreditsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Credits'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: _buildCreditsPopupCore(context),
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

Widget _buildCreditsPopupCore(BuildContext context) {
  return Column(
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
        width: MediaQuery.of(context).size.width * .5,
      ),
      TextButton(
        onPressed: () => _launchURL('http://www.tri-tail.com/'),
        child: const Text(
          'www.tri-tail.com',
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
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
        width: MediaQuery.of(context).size.width * .5,
      ),
      TextButton(
        onPressed: () => _launchURL('https://www.mpagmbh.de/'),
        child: const Text(
          'www.mpagmbh.de',
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    ],
  );
}

void _launchURL(String url) {
  Uri uri = Uri.parse(url);
  launchUrl(uri, mode: LaunchMode.externalApplication);
}
