import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPopup extends StatelessWidget{
  const CreditsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }

  Widget _buildCreditsPopupCore(BuildContext context) {
    double logoWidth = MediaQuery.of(context).size.width * .5;
    const linkStyle =
    TextStyle(color: Colors.blue, decoration: TextDecoration.underline);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Eine App von', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        const Text(
          'Kira Resari',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Image.asset('assets/tri-tail_logo.png', width: logoWidth),
        TextButton(
          onPressed: () => _launchURL('http://www.tri-tail.com/'),
          child: const Text('www.tri-tail.com', style: linkStyle),
        ),
        const SizedBox(height: 24),
        const Text('Im Auftrag der MPA', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Image.asset('assets/mpa_logo.png', width: logoWidth),
        TextButton(
          onPressed: () => _launchURL('https://www.mpagmbh.de/'),
          child: const Text('www.mpagmbh.de', style: linkStyle),
        ),
      ],
    );
  }

  void _launchURL(String url) {
    Uri uri = Uri.parse(url);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}