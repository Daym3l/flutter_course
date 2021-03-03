import 'package:flutter/material.dart';

class FormatPrice extends StatelessWidget {
  final String price;

  FormatPrice(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text('\$', style: TextStyle(fontFamily: 'Oswald')),
          SizedBox(
            width: 2,
          ),
          Text(
            price,
            style: TextStyle(fontSize: 28, fontFamily: 'Oswald'),
            textAlign: TextAlign.left,
          )
        ],
      ),
    );
  }
}
