import 'package:flutter/material.dart';
import './products.dart';
import './product_control.dart';

class ProductManager extends StatefulWidget {
  final String startingProducts;

  ProductManager({this.startingProducts = 'Sweet Tester'});

  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
  void initState() {
    _products.add(widget.startingProducts);
    super.initState();
  }

  void _addProducts(String product) {
    setState(() {
      _products.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(4.0),
          child: ProductControl(_addProducts),
        ),
        Products(_products)
      ],
    );
  }
}
