import 'package:flutter/material.dart';
import 'package:flutter_course/pages/tab.page.editProduct.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductListPage(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 26.0,
              backgroundImage: AssetImage(products[index]['image']),
            ),
            title: Text(products[index]['title']),
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return EditProductPage(product: products[index]);
                }));
              },
            ),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
