import 'package:flutter/material.dart';
import 'package:flutter_course/pages/tab.page.editProduct.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;
  final Function deleteProduct;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              deleteProduct(index);
            }
          },
          background: Container(
            color: Colors.red,
            child: ListTile(
              leading: Icon(Icons.delete_forever_rounded),
              trailing: Icon(Icons.delete_forever_rounded),
            ),
          ),
          key: Key(products[index]['title']),
          child: Column(children: [
            ListTile(
              leading: CircleAvatar(
                radius: 26.0,
                backgroundImage: AssetImage(products[index]['image']),
              ),
              title: Text(products[index]['title']),
              subtitle: Text('\$${products[index]['price'].toString()}'),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return EditProductPage(
                        product: products[index],
                        updateProduct: updateProduct,
                        productIndex: index);
                  }));
                },
              ),
            ),
            Divider()
          ]),
        );
      },
      itemCount: products.length,
    );
  }
}
