import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/iu_elements/widget.spiner.dart';
import 'package:flutter_course/widgets/product/widget.product.dart';
import 'package:flutter_course/widgets/iu_elements/widget.drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(
        child: Text('No Products Found!'),
      );
      if (model.displayProducts.length > 0 && !model.getLoading) {
        content = Products();
      } else if (model.getLoading) {
        content = Spiner("Loading Data...");
      }

      return content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
                icon: Icon(
                  model.displayFavoriteOnly
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  model.toggleDisplayMode();
                });
          })
        ],
      ),
      body: _buildProductList(),
    );
  }
}
