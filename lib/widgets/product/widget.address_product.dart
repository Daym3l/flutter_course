import 'package:flutter/material.dart';

class ProductAddress extends StatelessWidget {
  final String address;
  ProductAddress(this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey),
      ),
      child: Text(address),
    );
  }
}
