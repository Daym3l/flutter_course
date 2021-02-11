import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/product/widget.card_product.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(top: 4, left: 4, right: 4),
      child: ProductCard(products[index], index),
    );
  }

  Widget _buildProductList() {
    Widget productCard = Center(
      child: Text('Empty List'),
    );
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductList();
  }
}
