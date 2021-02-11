import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Text('This action cannot be undonde!'),
      actions: [
        FlatButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.cancel),
          label: Text('Cancel'),
        ),
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.check),
          label: Text('Accept'),
        )
      ],
    );
  }
}
