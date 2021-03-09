import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String content;

  MyDialog(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        FlatButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.cancel),
          label: Text('Close'),
        ),
      ],
    );
  }
}
