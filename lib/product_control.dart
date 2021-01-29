import 'package:flutter/material.dart';

class ProductControl extends StatelessWidget {
  final Function addProduct;
  ProductControl(this.addProduct);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      onPressed: () {
        addProduct({'title': 'Chocolate', 'image': 'assets/images/food.jpg'});
      },
      child: Icon(Icons.add),
    );
  }
}
