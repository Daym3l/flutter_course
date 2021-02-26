import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/iu_elements/widget.title.dart';
import 'package:flutter_course/widgets/product/widget.address_product.dart';

import 'widget.price_tag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;

  ProductCard(this.product, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(product.image),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormatTitle(product.title),
                SizedBox(
                  width: 8.0,
                ),
                PriceTag(product.price.toString())
              ],
            ),
          ),
          ProductAddress("Union Square, San Fransisco"),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.info_outline),
                color: Colors.blue,
                onPressed: () => Navigator.pushNamed(
                    context, '/product/' + index.toString()),
              ),
              IconButton(
                  icon: Icon(Icons.favorite_border_outlined),
                  color: Colors.red,
                  onPressed: () => Navigator.pushNamed(
                      context, '/product/' + index.toString()))
            ],
          )
        ],
      ),
    );
  }
}
