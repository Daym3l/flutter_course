import 'package:flutter/material.dart';
import 'package:flutter_course/pages/tab.page.editProduct.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatefulWidget {
  final MainModel mainModel;

  ProductListPage(this.mainModel);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPage();
  }
}

class _ProductListPage extends State<ProductListPage> {
  @override
  void initState() {
    widget.mainModel.fetchProducts();
    super.initState();
  }

  Widget _buildIconButton(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return IconButton(
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).accentColor,
        ),
        onPressed: () {
          model.selectProduct(model.allproducts[index].id);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return EditProductPage();
          }));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                model.selectProduct(model.allproducts[index].id);
                model.deleteProduct();
              }
            },
            background: Container(
              color: Colors.red,
              child: ListTile(
                leading: Icon(Icons.delete_forever_rounded),
                trailing: Icon(Icons.delete_forever_rounded),
              ),
            ),
            key: Key(model.allproducts[index].id),
            child: Column(children: [
              ListTile(
                  leading: CircleAvatar(
                    radius: 26.0,
                    backgroundImage:
                        NetworkImage(model.allproducts[index].image),
                  ),
                  title: Text(model.allproducts[index].title),
                  subtitle:
                      Text('\$${model.allproducts[index].price.toString()}'),
                  trailing: _buildIconButton(context, index)),
              Divider()
            ]),
          );
        },
        itemCount: model.allproducts.length,
      );
    });
  }
}
