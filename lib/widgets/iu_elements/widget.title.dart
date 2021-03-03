import 'package:flutter/material.dart';

class FormatTitle extends StatelessWidget {
  final String title;

  FormatTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontFamily: 'Oswald'),
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }
}
