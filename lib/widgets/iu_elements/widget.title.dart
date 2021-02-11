import 'package:flutter/material.dart';

class FormatTitle extends StatelessWidget {
  final String title;

  FormatTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
