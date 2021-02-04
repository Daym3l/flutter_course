import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Container(
      child: Card(
        child: Column(
          children: [
            Image.asset(products[index]['image']),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    products[index]['title'],
                    style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      '\$ ${products[index]['price'].toString()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.grey),
              ),
              child: Text("Union Square, San Fransisco"),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    child: Text('Details'),
                    onPressed: () => Navigator.pushNamed(
                        context, '/product/' + index.toString()))
              ],
            )
          ],
        ),
      ),
      margin: EdgeInsets.only(top: 4, left: 4, right: 4),
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
