import 'package:flutter/material.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/product/widget.product.dart';
import 'package:flutter_course/widgets/iu_elements/widget.drawer.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('EasyList'),
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
      body: Products(),
    );
  }
}
