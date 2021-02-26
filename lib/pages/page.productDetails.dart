import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_course/widgets/iu_elements/widget.title.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + product.price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext context, Widget child, ProductsModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text(model.products[productIndex].title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(model.products[productIndex].image),
            Container(
              child: FormatTitle(model.products[productIndex].title),
              padding: EdgeInsets.all(8.0),
            ),
            _buildAddressPriceRow(model.products[productIndex]),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                model.products[productIndex].description,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      );
    }), onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    });
  }
}
