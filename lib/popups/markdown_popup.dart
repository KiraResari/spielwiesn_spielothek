import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';

void showMarkdownPopup(
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
