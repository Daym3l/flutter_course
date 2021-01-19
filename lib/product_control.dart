import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;
  ProductControl(this.addProduct);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      onPressed: () {
        addProduct('Sweet');
      },
      child: Text('Add Product'),
    );
  }
}
