import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';

class MarkdownPopup extends StatelessWidget{
  final String title;
  final String content;

  const MarkdownPopup({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
    );
  }
}
